# Install jlenv and make it avilable to the selected user

# Ensure test setup
include_recipe 'shared::default'

# Keeps the jlenv install upto date
jlenv_user_install 'vagrant'

# Issue: https://github.com/jlenv/jlenv-cookbook/issues/2
#
# User installs are independent.
#jlenv_user_install 'jovyan'

# User installs are idempotent.
jlenv_user_install 'vagrant'
