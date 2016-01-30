if sunzi.to_be_done "setup noatime"; then
  sed -i -- 's/defaults/defaults,noatime/g' /etc/fstab

  mount -o remount /

  sunzi.done "setup noatime"
fi
