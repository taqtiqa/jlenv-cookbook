#
# https://blog.daveallie.com/clean-monkey-patching/

module GitExt

  def self.prepended(base)
    base.singleton_class.prepend(ClassMethods)
  end

  module ClassMethods
    # Placeholder
  end
 
  # Resolve SHA values given references such as, (ordered):
  # 1. tags first: "refs/tags/"
  # 2. then heads: "refs/heads/"
  # 3. then revisions: "refs/pulls/v1.0"
  # spec tests: 
  # 1. v1.0^{} i.e. converts from an annotated tag to the tagged SHA (not SHA of tag)
  # 2. v1.0
  # 3. v1.0 returns refs/tags/v1.0 before refs/tags/releases/v1.0
  # 4. refs/heads/v1.0 is accepted, etc
  # 5. "origin/" raises Chef::Exceptions::InvalidRemoteGitReference
  # 6. "junk" raises Chef::Exceptions::UnresolvableGitReference
  # 7. "" Returns HEAD SHA
  #
  # bash implmentation logic:
  # git_ref_type() {
  #     [ -n "$1" ] || die "Missing ref name"
  #     if git show-ref -q --verify "refs/tags/$1" 2>/dev/null; then
  #         echo "tag"
  #     elif git show-ref -q --verify "refs/heads/$1" 2>/dev/null; then
  #         echo "branch"
  #     elif git show-ref -q --verify "refs/pulls/$1" 2>/dev/null; then
  #         echo "revision"
  #     elif git show-ref -q --verify "refs/remote/$1" 2>/dev/null; then
  #         echo "remote"
  #     elif git rev-parse --verify "$1^{commit}" >/dev/null 2>&1; then
  #         echo "hash"
  #     else
  #         echo "unknown"
  #     fi
  #     return 0
  # }

  def find_current_revision
    logger.trace("#{new_resource} finding current git revision")
    if ::File.exist?(::File.join(cwd, ".git"))
      # 128 is returned when not in a git repo - no problem.
      result = git("rev-parse", "HEAD", 
                    cwd: cwd, 
                    returns: [0, 128],
                    live_stdout: StringIO.new,
                    live_stderr: StringIO.new,
                    live_stream: StringIO.new
                  ).live_stdout.string.strip
    end
    sha_hash?(result) ? result : nil
  end

  def clone
    converge_by("clone from #{repo_url} into #{cwd}") do
      remote = new_resource.remote
      clone_cmd = ["clone"]
      clone_cmd << "-o #{remote}" unless remote == "origin"
      clone_cmd << "--depth #{new_resource.depth}" if new_resource.depth
      clone_cmd << "--no-single-branch" if new_resource.depth && git_has_single_branch_option?
      clone_cmd << "\"#{new_resource.repository}\""
      clone_cmd << "\"#{cwd}\""

      logger.info "#{new_resource} cloning repo #{repo_url} to #{cwd}"
      git(clone_cmd, returns: [0, 128])
    end
    target_revision
  end

  def target_revision
    return '' unless existing_git_clone?
    @target_revision ||=
      begin
        if sha_hash?(new_resource.revision)
          @target_revision = new_resource.revision
        else
          @target_revision = local_resolve_reference
        end
      end
  end

  def local_resolve_reference
    @resolved_reference = git_ref(rev_search_pattern)
    @resolved_reference
  end

  def rev_search_pattern
    if ["", "HEAD"].include? new_resource.revision
      "HEAD"
    else
      new_resource.revision
    end
  end

  def git_ref(reference)
    # Raise an error if not valid reference format....
    valid = git_ref_format_valid?(reference)
    hash = ''
    %w[refs/heads refs/tags packed-refs].each do |prefix|
      # 128 is returned when not in a git repo - no problem.
      hash = git('show-ref', '--verify', "\"#{prefix}/#{reference}\"",
                  cwd: cwd,
                  returns: [0, 128],
                  live_stdout: StringIO.new,
                  live_stderr: StringIO.new,
                  live_stream: StringIO.new
                )
      break if hash.exitstatus == 0
    end
    # This avoids stdout which is not available where no /dev/tty
    ref = hash.exitstatus == 0 ? hash.live_stdout.string : ''
    ref.chomp.split(' ').first
  end

  def git_ref_format_valid?(reference)
    valid  = false
    result = git('check-ref-format', '--allow-onelevel', reference, returns: [0, 1])
    if result.exitstatus
      valid = true
    else
      git('check-ref-format', reference).exit_status ? valid = true : valid = false
    end
    unless valid
      # For invalid reference formats git cannot return a revision
      raise Chef::Exceptions::User, "The given reference '#{reference}' is not a valid Git reference format." 
    end
    valid
  end

end

Chef::Provider::Git.prepend(GitExt)
