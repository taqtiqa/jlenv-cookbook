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
        case node['platform_family']
        when 'mac_os_x'
          %w(openssl makedepend pkg-config libyaml libffi)
        when 'rhel', 'fedora', 'amazon'
          %w(gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel make)
        when 'debian'
          if node['platform_version'].to_i >= 18
            %w(gcc autoconf bison build-essential libssl1.0-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev make)
          else
            %w(gcc autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev make)
          end
        when 'suse'
          %w(gcc make automake gdbm-devel libyaml-devel ncurses-devel readline-devel zlib-devel libopenssl-devel )
        end
      end
    end
  end
end
