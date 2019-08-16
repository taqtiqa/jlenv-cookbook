name 'test'

run_list 'test::system_install'

cookbook 'test', path: '.'
cookbook 'jlenv', path: '../../../../'
