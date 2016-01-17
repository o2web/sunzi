DEPLOYER_NAME=<%= @attributes.deployer_name %>
DEPLOYER_PATH=/home/$DEPLOYER_NAME
RBENV_PATH=$DEPLOYER_PATH/.rbenv
PLUGINS_PATH=$RBENV_PATH/plugins
PROFILE=$DEPLOYER_PATH/.bashrc
RUBY_VERSION=<%= @attributes.ruby_version %>
RBENV_EXPORT_PATH="export PATH=\"$RBENV_PATH/bin:$PLUGINS_PATH/ruby-build/bin:$PATH\""
RBENV_INIT='eval "$(rbenv init -)"'

if sunzi.to_be_done "install ruby"; then
  git clone git://github.com/sstephenson/rbenv.git $RBENV_PATH
  git clone git://github.com/sstephenson/ruby-build.git $PLUGINS_PATH/ruby-build
  git clone git://github.com/sstephenson/rbenv-gem-rehash.git $PLUGINS_PATH/rbenv-gem-rehash
  git clone git://github.com/dcarley/rbenv-sudo.git $PLUGINS_PATH/rbenv-sudo

  eval $RBENV_EXPORT_PATH
  eval $RBENV_INIT
  echo $RBENV_EXPORT_PATH >> $PROFILE
  echo $RBENV_INIT >> $PROFILE

  rbenv install $RUBY_VERSION
  rbenv global $RUBY_VERSION
  echo 'gem: --no-ri --no-rdoc' > $DEPLOYER_PATH/.gemrc
  gem install bundler
  gem install backup

  sunzi.done "install ruby"
fi
