if sunzi.to_be_done "setup logrotate"; then
	mv files/rails_logs /etc/logrotate.d/rails_logs
	chown root:root /etc/logrotate.d/rails_logs
	chmod 0644 /etc/logrotate.d/rails_logs

  sunzi.done "setup logrotate"
fi
