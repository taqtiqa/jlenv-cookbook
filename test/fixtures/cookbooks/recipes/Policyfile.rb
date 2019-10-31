name 'recipes'

run_list 'recipes::system_install',
         'recipes::user_install',
         'recipes::global'

# default_source :chef_repo, "../../../../../"
# default_source :chef_repo, "../"

# cookbook 'recipes'
# cookbook 'shared'
default_source :chef_repo, './../'

cookbook 'recipes'
cookbook 'shared'
cookbook 'jlenv', path: './../../../../'
