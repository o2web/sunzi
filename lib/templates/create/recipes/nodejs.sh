if sunzi.to_be_done "install nodejs"; then
  curl -sL https://deb.nodesource.com/setup | sudo bash -
  sunzi.install "nodejs"

  sunzi.done "install nodejs"
fi
