sunzi.setup_progress

start=$(sunzi.start_time)

source recipes/setup.sh
source recipes/libraries.sh
source recipes/nodejs.sh
<% case @attributes.db_adapter -%>
<% when 'postgresql' -%>
source recipes/postgres.sh
<% when 'mysql', 'mysql2' -%>
source recipes/mysql.sh
<% end -%>
source recipes/passenger.sh
source recipes/user.sh
source recipes/analysers.sh
source recipes/logrotate.sh
source recipes/noatime.sh

sunzi.elapsed_time $start

reboot
