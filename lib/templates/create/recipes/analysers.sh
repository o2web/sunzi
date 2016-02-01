if sunzi.to_be_done "install analysers"; then
  echo "deb http://deb.goaccess.io/ $(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/goaccess.list
  wget -O - http://deb.goaccess.io/gnugpg.key | apt-key add -

  sunzi.mute "apt-get update"

  sunzi.install "goaccess" #TODO: http://goaccess.io/faq#howto-config
  sunzi.install "iotop"
  sunzi.install "iftop"
  sunzi.install "ifstat"
  sunzi.install "nethogs"
  sunzi.install "sysstat"

  sed -i 's/#time-format %H:%M:%S/time-format %H:%M:%S/' /etc/goaccess.conf
  sed -i 's|#date-format %d/%b/%Y|date-format %d/%b/%Y|' /etc/goaccess.conf
  sed -i 's/#log-format %h %\^\[%d:%t %\^\] "%r" %s %b "%R" "%u"/log-format %h - %\^ \[%d:%t %\^\] "%r" %s %b "%R" "%u" %T %\^/' /etc/goaccess.conf

  sed -i 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat
  /etc/init.d/sysstat restart

  sunzi.done "install analysers"
fi
