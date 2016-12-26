DEPLOYER_NAME=<%= @attributes.deployer_name %>
DEPLOYER_PATH=/home/$DEPLOYER_NAME
RBENV_PATH=$DEPLOYER_PATH/.rbenv
PLUGINS_PATH=$RBENV_PATH/plugins
PROFILE=$DEPLOYER_PATH/.bashrc
RUBY_VERSION=<%= @attributes.ruby_version %>
RBENV_EXPORT_PATH="export PATH=\"$RBENV_PATH/bin:$PLUGINS_PATH/ruby-build/bin:$PATH\""
RBENV_INIT='eval "$(rbenv init -)"'
RUBY_VERSION_PATH="$RBENV_PATH/versions/$RUBY_VERSION"

if sunzi.to_be_done "install ruby"; then

  if ! [ -d "$RBENV_PATH" ]
  then
    git clone git://github.com/sstephenson/rbenv.git $RBENV_PATH
    git clone git://github.com/sstephenson/ruby-build.git $PLUGINS_PATH/ruby-build
    git clone git://github.com/sstephenson/rbenv-gem-rehash.git $PLUGINS_PATH/rbenv-gem-rehash
    git clone git://github.com/dcarley/rbenv-sudo.git $PLUGINS_PATH/rbenv-sudo
  fi

  # Change user and group to deployer to allow gem installs
  chown -R deployer:deployer $DEPLOYER_PATH/.rbenv

  eval $RBENV_EXPORT_PATH
  eval $RBENV_INIT
  echo $RBENV_EXPORT_PATH >> $PROFILE
  echo $RBENV_INIT >> $PROFILE

  if [ -d "$RUBY_VERSION_PATH" ]
  then
    echo 'deleting existing ruby version $RUBY_VERSION_PATH'
    rm -R $RUBY_VERSION_PATH
  fi

  echo 'installing ruby version $RUBY_VERSION'
  rbenv install -v $RUBY_VERSION

  echo 'setting global for ruby version $RUBY_VERSION'
  rbenv global $RUBY_VERSION

  echo 'setting doc for deployer'
  echo 'gem: --no-ri --no-rdoc' > $DEPLOYER_PATH/.gemrc

  echo 'install bundler and backup'
  gem install bundler
  gem install backup

  sunzi.done "install ruby"
fi
