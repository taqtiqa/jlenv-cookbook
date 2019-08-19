name 'resources'

run_list 'resources::system_install'

default_source :chef_repo, "../../../../../"
default_source :chef_repo, "../"

cookbook 'resources'
cookbook 'shared'
