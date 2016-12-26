DB_NAME=<%= @attributes.db_database %>
DB_USER=<%= @attributes.db_username %>
DB_PWD=<%= @attributes.db_password %>

if sunzi.to_be_done "install postgres"; then
  sunzi.install "postgresql"
  sunzi.install "postgresql-contrib"
  sunzi.install "libpq-dev"

#  sudo -u postgres psql -c "create user $DB_USER with password '$DB_PWD';"
  sudo -u postgres psql -c "create database $DB_NAME owner $DB_USER;"

  sunzi.done "install postgres"
fi
