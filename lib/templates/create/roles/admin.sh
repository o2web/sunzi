sunzi.setup_progress

start=$(sunzi.start_time)

source recipes/setup.sh
source recipes/libraries.sh
source recipes/nodejs.sh
source recipes/postgres.sh
# source recipes/mysql.sh
source recipes/passenger.sh
source recipes/user.sh
# source recipes/sysstat.sh

sunzi.elapsed_time $start

reboot
