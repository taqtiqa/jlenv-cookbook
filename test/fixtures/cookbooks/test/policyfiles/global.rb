name 'Test Global Recipe'

path = File.expand_path('base.rb', __dir__)
instance_eval(IO.read(path))

#include_policy 'base', path: '.'
# The run list is also ignored by ChefSpec but you need to specify one.
run_list 'test::global'
