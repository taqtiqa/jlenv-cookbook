
# Install jlenv and makes it avilable to the selected user

# Ensure test setup
include_recipe 'shared::default'

# Keeps the jlenv install upto date
jlenv_user_install 'vagrant'

# User installs are idempotent.
jlenv_user_install 'vagrant'
