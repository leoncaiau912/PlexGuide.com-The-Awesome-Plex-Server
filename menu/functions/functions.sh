#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
}

badinput1 () {
echo
read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
question1
}

variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

removemounts () {
  ansible-playbook /opt/plexguide/menu/remove/mounts.yml
}

readrcloneconfig () {
  touch /opt/appdata/plexguide/rclone.conf
  chown -R 1000:1000 /opt/appdata/plexguide/rclone.conf
  mkdir -p /var/plexguide/rclone/

  gdcheck=$(cat /opt/appdata/plexguide/rclone.conf | grep -A 2 gdrive| grep token)
  if [ "$gdcheck" != "" ]; then "good" > /var/plexguide/rclone/gdrive.status && gdstatus=good; fi

  #cat /opt/appdata/plexguide/rclone.conf | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone/gdrive.status
  #cat /opt/appdata/plexguide/rclone.conf | grep 'gcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone/gcrypt.status
  #cat /opt/appdata/plexguide/rclone.conf | grep 'tdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone/tdrive.status
  #cat /opt/appdata/plexguide/rclone.conf | grep 'tcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone/tcrypt.status
  #gdrive=$(cat /var/plexguide/rclone/gdrive.status)
  #gcrypt=$(cat /var/plexguide/rclone/gcrypt.status)
  #tdrive=$(cat /var/plexguide/rclone/tdrive.status)
  #tcrypt=$(cat /var/plexguide/rclone/tcrypt.status)
}

rcloneconfig () {

rclone config --config /opt/appdata/plexguide/rclone.conf
}