##### Mibsi Config - config.sh #####

#installation directory (must include trailing slash)
destDir="/home/${USER}/.btsync/"

#64 bit archive URL of btsync
URL64="http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable"

#32 bit archive URL of btsync
URL32="http://download-lb.utorrent.com/endpoint/btsync/os/linux-i386/track/stable"

#backup directory (must include trailing /)
BackupDir="/home/${USER}/.btsync/backup/"

#name of final backup archive
BackupFile="btsync-backup-$(date +%Y%m%d).tar.gz"

#filename toggle script
ToggleScript="btsync-toggle.sh"

#path to create start/stop toggle script
ToggleScriptDir="/home/${USER}/"

#whether or not to generate a start/stop toggle script
#possible values: "enable", "disable"
MakeToggleScript="enable"

#enable/eisable prompt to open btsync manager after installation
#useful if you want to run Easy Btsync at boot time.
#Possible values: "enable", "disable"
AskPrompt="enable"

#enable/eisable graphical notification popup
#Possible values: "enable", "disable"
Notify="enable"
