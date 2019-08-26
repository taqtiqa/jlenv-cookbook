name 'shared'

run_list 'shared::default'

# default_source :chef_repo, './../../../../'

cookbook 'jlenv', path: './../../../../'