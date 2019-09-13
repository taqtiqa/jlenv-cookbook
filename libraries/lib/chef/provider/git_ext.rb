# git_ext.rb

module GitExt
  def self.prepended(base)
    base.singleton_class.prepend(ClassMethods)
  end

  # module ClassMethods
  #   def remote_resolve_reference(ref)
  #     super || JSON.parse(obj_or_json_string) rescue nil
  #   end
  # end
 
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

  def remote_resolve_reference(reference)
    case strip(reference)
      when ''
        git_head_ref
      when /^a/
      else
    end
  end
  def git_ls_remote(rev_pattern)
    git("ls-remote", "\"#{new_resource.repository}\"", "\"#{rev_pattern}\"").stdout
  end
end

Chef::Provider::Git.prepend(GitExt)
