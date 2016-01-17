if sunzi.to_be_done "install librairies"; then
  sunzi.install "autoconf"
  sunzi.install "bison"
  sunzi.install "libncurses5-dev"
  sunzi.install "libgdbm3"
  sunzi.install "libgdbm-dev"

  sunzi.install "git-core"
  sunzi.install "zlib1g-dev"
  sunzi.install "build-essential"
  sunzi.install "libssl-dev"
  sunzi.install "libreadline-dev"
  sunzi.install "libyaml-dev"
  sunzi.install "libsqlite3-dev"
  sunzi.install "sqlite3"
  sunzi.install "libxml2-dev"
  sunzi.install "libxslt1-dev"
  sunzi.install "libcurl4-openssl-dev"
  sunzi.install "python-software-properties"
  sunzi.install "libffi-dev"
  sunzi.install "imagemagick"

  sunzi.done "install librairies"
fi
