DEPLOYER_NAME=<%= @attributes.deployer_name %>
DEPLOYER_PWD=<%= @attributes.deployer_password %>
DEPLOYER_PATH=/home/$DEPLOYER_NAME

if sunzi.to_be_done "create deployer"; then
  adduser $DEPLOYER_NAME --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
  echo "$DEPLOYER_NAME:$DEPLOYER_PWD" | sudo chpasswd
  adduser $DEPLOYER_NAME sudo

  mkdir $DEPLOYER_PATH/.ssh
  chmod 700 $DEPLOYER_PATH/.ssh

  mv files/authorized_keys $DEPLOYER_PATH/.ssh/authorized_keys
  chmod 644 $DEPLOYER_PATH/.ssh/authorized_keys

  chown -R $DEPLOYER_NAME:$DEPLOYER_NAME $DEPLOYER_PATH

	mv files/sudoers /etc/sudoers.d/$DEPLOYER_NAME
	chown root:root /etc/sudoers.d/$DEPLOYER_NAME
	chmod 0440 /etc/sudoers.d/$DEPLOYER_NAME

  sunzi.done "create deployer"
fi
