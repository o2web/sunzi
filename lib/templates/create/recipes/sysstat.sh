if sunzi.to_be_done "install sysstat"; then
  sunzi.install "sysstat"

  sed -i 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat
  /etc/init.d/sysstat restart

  sunzi.done "install sysstat"
fi
