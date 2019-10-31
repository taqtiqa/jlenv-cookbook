# frozen_string_literal: true

class Chef
  module Jlenv
    module PackageDeps
      def install_julia_dependencies
        case ::File.basename(new_resource.version)
        when /^special-julia-/
          puts 'call another package install method'
        else
          apt_update if node['platform_family'] == 'debian'
          package_deps.each do |deps|
            package deps
          end
        end
        ensure_java_environment if new_resource.version =~ /^jjulia-/
      end

      def package_deps
        case node['platform']
        when 'mac_os_x'
          %w[openssl makedepend pkg-config libyaml libffi]
        when 'rhel', 'fedora', 'amazon'
          %w[bzip2 gcc-5 g++-5 chkconfig openssl-devel readline-devel zlib-devel
             ncurses-devel make]
        when 'debian'
          if node['platform_version'].to_i >= 18
            %w[autoconf bison gcc-5 g++-5 libssl1.0-dev libreadline6-dev zlib1g-dev
               libncurses5-dev make]
          else
            %w[autoconf bison gcc-5 g++-5 libssl-dev libreadline6-dev zlib1g-dev
               libncurses5-dev make]
          end
        when 'ubuntu'
          case node['platform_version']
          when '18.04'
            case node['hostnamectl']['architecture']
            when 'x86-64'
              %w[bar bzip2 cmake ccache curl dpkg gawk gcc-5 g++-5 gfortran-5
                libatomic1 libqd-dev libssl1.0.0 make m4 patch perl pkg-config
                python-minimal time]
            else
              %w[bar bzip2 cmake ccache curl dpkg gawk gcc-5 g++-5 gfortran-5
                gcc-5-multilib g++-5-multilib libatomic1 libqd-dev libssl1.0.0
                make m4 patch perl pkg-config python-minimal time binutils
                make:i386 libssl-dev:i386 gfortran-5 gfortran-5-multilib]
            end
          when '16.04'
            case node['hostnamectl']['architecture']
            when 'x86-64'
              %w[bar bzip2 cmake ccache curl dpkg gawk gcc-5 g++-5 gfortran-5
                libatomic1 libqd-dev libssl1.0.0 make m4 patch perl pkg-config
                python-minimal time]
            else
              %w[bar bzip2 cmake ccache curl dpkg gawk gcc-5 g++-5 gfortran-5
                gcc-5-multilib g++-5-multilib libatomic1 libqd-dev libssl1.0.0
                make m4 patch perl pkg-config python-minimal time binutils
                make:i386 libssl-dev:i386 gfortran-5 gfortran-5-multilib]
            end
          when '14.04'
            case node['hostnamectl']['architecture']
            when 'x86-64'
              %w[bar bzip2 cmake ccache curl dpkg gawk gcc-5 g++-5 gfortran-5
                libatomic1 libqd-dev libssl1.0.0 make m4 patch perl pkg-config
                python-minimal time]
            else
              %w[bar bzip2 cmake ccache curl dpkg gawk gcc-5 g++-5 gfortran-5
                gcc-5-multilib g++-5-multilib libatomic1 libqd-dev libssl1.0.0
                make m4 patch perl pkg-config python-minimal time binutils
                make:i386 libssl-dev:i386 gfortran-5 gfortran-5-multilib]
            end
          end
        when 'suse'
          %w[gcc-5 g++-5 gfortran-5 make automake ncurses-devel readline-devel
            zlib-devel libopenssl-devel update-alternatives]
        end
      end
    end
  end
end
