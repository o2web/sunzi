if sunzi.to_be_done "setup system"; then
  sunzi.mute "apt-get update"
  yes | apt-get upgrade
  sunzi.mute "timedatectl set-timezone <%= @attributes.timezone %>"
  sunzi.mute "locale-gen <%= @attributes.locales %>"
  sunzi.mute "dpkg-reconfigure locales"
  sunzi.install "curl"
  sunzi.install "ntp"

  sunzi.done "setup system"
fi
