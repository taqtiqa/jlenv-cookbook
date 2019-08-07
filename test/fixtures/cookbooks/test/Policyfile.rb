name 'test'
# The run list is also ignored by ChefSpec but you need to specify one.
run_list 'test:::pkg'

default_source :supermarket

cookbook 'test', path: '.'
# cookbook 'jlenv', path: '../../../../'
