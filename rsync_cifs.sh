#!/bin/sh
# install as hourly: 
# vi /etc/crontab or cron.d/
# 04 *	* * *	root	/usr/local/sbin/rsync_cifs.sh
# or any other user
bkpdir="smb_azet/home_bkp"
user="azet"

rsync -av --progress --bwlimit=8500 --exclude /home/$user/.gvfs /home/$user /media/$bkpdir  || ( echo "attention: backup failed!" | wall ; exit 1 )
