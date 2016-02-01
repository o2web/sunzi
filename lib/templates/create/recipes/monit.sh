if sunzi.to_be_done "install monit"; then
  sunzi.install "monit"

	chown root:root /etc/monit/monitrc
	chmod 0700 /etc/monit/monitrc

  /etc/init.d/monit start

  sunzi.done "install monit"
fi
