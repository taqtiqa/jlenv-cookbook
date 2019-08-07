name 'jlenv'

path = File.expand_path('../policyfiles/base.rb', __FILE__)
instance_eval(IO.read(path))

run_list 'jlenv::default'
cookbook 'jlenv', path: '.'
