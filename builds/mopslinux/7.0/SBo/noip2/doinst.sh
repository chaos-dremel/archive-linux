# Handle configuration files
config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}
# List of configuration files (they should end in .new)

config etc/rc.d/rc.noip2.new

SCRIPT="rc.noip2"
x=`cat /etc/rc.d/rc.local | grep $SCRIPT`
if [ "$x" = "" ]; then
    echo "" >> /etc/rc.d/rc.local
    echo "# no-ip" >> /etc/rc.d/rc.local
    echo "if [ -x /etc/rc.d/$SCRIPT ]; then" >> /etc/rc.d/rc.local
    echo "  /etc/rc.d/$SCRIPT start" >> /etc/rc.d/rc.local
    echo "fi" >> /etc/rc.d/rc.local
    echo "" >> /etc/rc.d/rc.local
fi
