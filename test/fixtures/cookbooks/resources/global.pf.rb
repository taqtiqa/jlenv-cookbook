name 'resources'

run_list 'resources::global'

default_source :chef_repo, "../../../../../"
default_source :chef_repo, "../"

cookbook 'resources'
cookbook 'shared'
