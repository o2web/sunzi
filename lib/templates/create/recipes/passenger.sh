DEPLOYER_NAME=<%= @attributes.deployer_name %>
DEPLOYER_PATH=/home/$DEPLOYER_NAME
RBENV_PATH=$DEPLOYER_PATH/.rbenv

if sunzi.to_be_done "install passenger"; then
  sunzi.mute "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7"
  sunzi.install "apt-transport-https"
  sunzi.install "ca-certificates"
  sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
  sunzi.mute "apt-get update"

  sunzi.install "nginx-extras"
  sunzi.install "passenger"

  sed -i -e "s|# passenger_root|passenger_root|g" /etc/nginx/nginx.conf
  sed -i -e "s|# passenger_ruby /usr/bin/passenger_free_ruby|passenger_ruby $RBENV_PATH/shims/ruby|g" /etc/nginx/nginx.conf

  sunzi.done "install passenger"
fi
