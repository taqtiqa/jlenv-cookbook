# Chef Jlenv Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/jlenv-cookbook.svg)](https://supermarket.chef.io/cookbooks/jlenv-cookbook)
[![Build Status](https://img.shields.io/circleci/project/github/jlenv/jlenv-cookbook/master.svg)](https://circleci.com/gh/jlenv/jlenv-cookbook)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)
[![CircleCI](https://circleci.com/gh/taqtiqa-mark/jlenv-cookbook.svg?style=svg)](https://circleci.com/gh/taqtiqa-mark/jlenv-cookbook)

## Description

Manages [jlenv](https://github.com/jlenv/jlenv) installed Julias.

## Maintainers

This cookbook is maintained by volunteers.
[All contributions and bug reports are welcome](./CONTRIBUTING).

## Requirements

### Chef

This cookbook requires Chef 13.0+.

### Platform

- Debian derivatives (Ubuntu etc.)
- Fedora
- macOS (not currently tested)
- RHEL derivatives (RHEL, CentOS, Amazon Linux, Oracle, Scientific Linux)
- openSUSE and openSUSE leap
- Windows (not supported)

## Usage

Example installations are provided in `test/fixtures/cookbooks/test/recipes/`.

A `jlenv_user_install` is required to be set so that jlenv knows which version
you want to use, and is installed on the system.

| **NOTE:** |
| System wide installations of jlenv are discouraged by the jlenv maintainer.|
|---|

However they are supported by this cookbook, see
[these](https://github.com/rbenv/rbenv/issues/38/)
[two](https://github.com/rbenv/rbenv/issues/306/) issues in the rbenv repository
for the reasons why.

## Package

Used to install a package into the selected jlenv environment.

```ruby
jlenv_package 'pkg_name' do
  options # Optional: Options for the packagecommand e.g. '--no-rdoc --no-ri'
  source # Optional: source URL/location for gem.
  timeout # Optional: Pkg install timeout
  version # Optional: Pkg version to install
  response_file # Optional: response file to reconfigure a gem
  jlenv_version # Required: Which jlenv version to install the packageto.
  user # Which user to install for. REQUIRED if you're using jlenv_user_install
end
```

## Global

Sets the global Julia version. The name of the resource is the version to set.

```ruby
jlenv_global '1.1.0' do
  user # Optional: Sets the users global version.
       # Leave unset, to set the system global version.
end
```

If a user is passed in to this resource it sets the global version for the user,
under the users `root_path` (usually `~/.jlenv/version`), otherwise it sets the
system global version.

## Plugin

Installs a jlenv plugin.

```ruby
jlenv_plugin 'julia-build' do
  git_url # Git URL of the plugin
  git_ref # Git reference of the plugin
  user # Optional: Install to the users jlenv.
       # Do not set, to set installs to the system jlenv.
end
```

If user is passed in, the plugin is installed to the users install of jlenv.

## Rehash

```ruby
jlenv_rehash 'rehash' do
  user 'vagrant' # Optional: Rehash the user jlenv otherwise rehash system jlenv
end
```

If user is passed in, the user Julia is rehashed rather than the system Julia.

## Julia

Installs a given Julia version to the system or user location.

```ruby
jlenv_julia '1.1.0' do
  user # Optional, but recommended: If passed, the user to install jlenv to
  jlenv_action # Optional: Action to perform:
               # 'install' (default), 'uninstall' etc.
end
```

Shorter example `jlenv_julia '1.1.0'`

## Script

Runs a jlenv aware script.

```ruby
jlenv_script 'foo' do
  jlenv_version #jlenv version to run the script against
  environment # Optional: Hash of environment variables in the form of
              # ({"ENV_VARIABLE" => "VALUE"}).
  user # Optional: User to run as
  group # Optional: Group to run as
  returns # Optional: Expected return code
  code # Script code to run
end
```

Note that environment overwrites the entire variable.
For example. setting the `$PATH` variable can be done like this:

```ruby
jlenv_script 'bundle package' do
  cwd node["bundle_dir"]
  environment ({"PATH" => "/usr/local/jlenv/shims:/usr/local/jlenv/bin:#{ENV["PATH"]}"})
  code "bundle package --all"
end
```

Where `#{ENV["PATH"]}` appends the existing `PATH` to the end of the newly set
`PATH`.

## System_install

Installs jlenv to the system location, by default `/usr/local/jlenv`

```ruby
jlenv_system_install 'foo' do
  git_url # URL of the plugin repo you want to checkout
  git_ref # Optional: Git reference to checkout
  update_jlenv # Optional: Keeps the git repo up to date
end
```

## User_install

Installs jlenv to the user path, making jlenv available to that user only.

```ruby
jlenv_user_install 'vagrant' do
  git_url # Optional: Git URL to checkout jlenv from.
  git_ref # Optional: Git reference to checkout e.g. 'master'
  user # Which user to install jlenv to (also given in the resources name above)
end
```

## System-Wide macOS Installation Note

This cookbook takes advantage of managing profile fragments in an
`/etc/profile.d` directory, common on most Unix-flavored platforms.
Unfortunately, macOS does not support this idiom out of the box, so you may
need to [modify][mac_profile_d] your user profile.

## Development

- Source hosted at [GitHub](https://github.com/jlenv/jlenv-cookbook/)
- Report Issues/Questions/Feature requests on
  [GitHub Issues](https://github.com/jlenv/jlenv-cookbook/issues)

Pull requests are very welcome! Make sure your patches are well tested.

## Testing

For local unit tests:

```bash
delivery local <all | unit | lint | syntax>
```

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
<table><tr><td align="center"><a href="http://blog.taqtiqa.com"><img src="https://avatars1.githubusercontent.com/u/1468258?v=4" width="100px;" alt="Mark Van de Vyver"/><br /><sub><b>Mark Van de Vyver</b></sub></a><br /><a href="#infra-taqtiqa-mark" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/taqtiqa-mark/jlenv-cookbook/commits?author=taqtiqa-mark" title="Tests">⚠️</a> <a href="https://github.com/taqtiqa-mark/jlenv-cookbook/commits?author=taqtiqa-mark" title="Code">💻</a></td></tr></table>

<!-- ALL-CONTRIBUTORS-LIST:END -->
This project exists thanks to all the people who contribute.
