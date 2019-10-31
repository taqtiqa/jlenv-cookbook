name 'resources'

run_list 'resources::system_install',
         'resources::user_install',
         'resources::plugin'

default_source :chef_repo, './../'

cookbook 'resources'
cookbook 'shared'
cookbook 'jlenv', path: './../../../../'
