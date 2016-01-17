# This file is used to define functions under the sunzi.* namespace.

# Set $sunzi_pkg to "apt-get" or "yum", or abort.
#
if which apt-get >/dev/null 2>&1; then
  export sunzi_pkg=apt-get
elif which yum >/dev/null 2>&1; then
  export sunzi_pkg=yum
fi

if [ "$sunzi_pkg" = '' ]; then
  echo 'sunzi only supports apt-get or yum!' >&2
  exit 1
fi

# Mute STDOUT and STDERR
#
function sunzi.mute() {
  echo "Running \"$@\""
  `$@ >/dev/null 2>&1`
  return $?
}

function sunzi.sudo_mute() {
  echo "Running \"$@\""
  `sudo $@ >/dev/null 2>&1`
  return $?
}

# Installer
#
function sunzi.installed() {
  if [ "$sunzi_pkg" = 'apt-get' ]; then
    dpkg -s $@ >/dev/null 2>&1
  elif [ "$sunzi_pkg" = 'yum' ]; then
    rpm -qa | grep $@ >/dev/null
  fi
  return $?
}

# When there's "set -e" in install.sh, sunzi.install should be used with if statement,
# otherwise the script may exit unexpectedly when the package is already installed.
#
function sunzi.install() {
  if sunzi.installed "$@"; then
    echo "$@ already installed"
  else
    echo "No packages found matching $@. Installing..."
    sunzi.mute "$sunzi_pkg -y install $@"
  fi
  return 0
}

function sunzi.sudo_install() {
  if sunzi.installed "$@"; then
    echo "$@ already installed"
  else
    echo "No packages found matching $@. Installing..."
    sunzi.sudo_mute "$sunzi_pkg -y install $@"
  fi
  return 0
}

function sunzi.setup_progress() {
  if [[ -e "$HOME/sunzi_progress.txt" ]]; then
    echo "Provisioning already started"
  else
    echo "New provisioning"
    touch "$HOME/sunzi_progress.txt"
  fi
  return 0
}

function sunzi.to_be_done() {
  if [[ -z $(grep -Fx "Done $@" "$HOME/sunzi_progress.txt") ]]; then
    echo "Executing $@"
    return 0
  else
    echo "Done $@"
    return 1
  fi
}

function sunzi.done() {
  echo "Done $@" | tee -a "$HOME/sunzi_progress.txt"
  return 0
}

function sunzi.start_time() {
  echo $(date -u +"%s")
}

function sunzi.elapsed_time() {
  start=$1
  finish=$(date -u +"%s")
  elapsed_time=$(($finish-$start))
  echo "$(($elapsed_time / 60)) minutes and $(($elapsed_time % 60)) seconds elapsed."
  return 0
}
