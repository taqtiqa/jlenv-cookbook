name 'shared'

run_list 'shared::default'

# default_source :chef_repo, './../../../../'
default_source :chef_repo, './../'

cookbook 'shared'
cookbook 'jlenv', path: './../../../../'
