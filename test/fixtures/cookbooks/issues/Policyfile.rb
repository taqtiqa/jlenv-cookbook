name 'issues'

run_list 'issues::default'

default_source :chef_repo, '../../../../../'
default_source :chef_repo, '../'

cookbook 'issues'
cookbook 'shared'
