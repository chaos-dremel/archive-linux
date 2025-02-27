config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

rc_d() {
# Keep same perms on rc.polipo.new:
if [ -e etc/rc.d/rc.polipo ]; then
  cp -a etc/rc.d/rc.polipo etc/rc.d/rc.polipo.new.incoming
  cat etc/rc.d/rc.polipo.new > etc/rc.d/rc.polipo.new.incoming
  mv etc/rc.d/rc.polipo.new.incoming etc/rc.d/rc.polipo.new
fi
config etc/rc.d/rc.polipo.new
}

rc_d
config etc/polipo/config.new
