#!/bin/bash
 
#############################################################
## Title: Mibsi (Mindless Bittorrent Sync Installer)
## Description: Automatic Bittorrent Sync updater/installer
## Version: 0.05a-9
## License: ISC
## Date: December 27, 2013
## Author: Mollusk
## Email: hookahkitty@gmail.com
## Website: http://homebutter.com
## Comments: If you have any suggestions please email me
#############################################################


 
 
 
##### SETTINGS #####

#installation directory (must include trailing slash)
destDir="/home/${USER}/.btsync/"

#64 bit archive of btsync
URL64="http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable"

#32 bit archive of btsync
URL32="http://download-lb.utorrent.com/endpoint/btsync/os/linux-i386/track/stable"

#backup directory (must include trailing /)     
BackupDir="/home/${USER}/.btsync/backup/"

#name of final backup archive
BackupFile="btsync-backup-$(date +%Y%m%d).tar.gz"

#startup script
StartScript="/home/${USER}/btsync-toggle.sh"

#whether or not to generate a start script
#possible values: "enabled", "Disabled"
MakeStartScript="enabled"

#enable/eisable prompt to open btsync manager after installation
#useful if you want to run Easy Btsync at boot time.
#Possible values: "enable", "disable"
AskPrompt="enable" 

#enable/eisable graphical notification popup
#Possible values: "enable", "disable"
Notify="enable"
  
  
##############################################
## DONT CHANGE ANYTHING BELOW THIS MESSAGE  ##
## UNLESS YOU KNOW WHAT YOU ARE DOING!      ##
##############################################

scriptGen(){

echo "#!/bin/bash" > ${StartScript}


echo "btsync_bin="${destDir}"btsync" >> ${StartScript}


echo 'chkNotify(){
  if [ -f /usr/bin/notify-send ];then
    return true
    
  else
    return false
    
  fi

}


start_btsync(){
  btsync_pid=$(pidof btsync)
  
  if [ ${btsync_pid} ];then
    if [ chkNotify ];then
      notify-send "BtSync is already running"
    else
      echo "BtSync is already running"
    fi
  
  else
    ${btsync_bin}
    #sleep 4
    btsync_pid=$(pidof btsync)
    if [ ${btsync_pid} ];then
      if [ chkNotify ];then
        notify-send "BtSync was Started on PID: ${btsync_pid}"
      else
        echo "BtSync was Started on PID: ${btsync_pid}"
      fi
      
    else
      if [ chkNotify ];then
        notify-send "BtSync not started"
      else
        echo "BtSync was not started"
      fi
    fi
  fi

}

stop_btsync(){
  btsync_pid=$(pidof btsync)
  
  
  if [ ! ${btsync_pid} ];then
    if [ chkNotify ];then
      notify-send "BtSync is not running"
    else
      echo "BtSync is not running"
    fi

  else
    kill -9 ${btsync_pid}
    #sleep 4
    btsync_pid=$(pidof btsync)
    if [ ! ${btsync_pid} ];then
      if [ chkNotify ];then
        notify-send "BtSync was Killed"
      else
        echo "BtSync was killed"
      fi
    fi
    
    
  fi

}


chkbin(){
  btsync_pid=$(pidof btsync)
  if [ -f ${btsync_bin} ];then
    if [ ${btsync_pid} ];then
      stop_btsync
      
    elif [ ! ${btsync_pid} ];then
      start_btsync
    fi
    
  elif [ ! -f ${btsync_bin} ];then
    if [ chkNotify ];then
      notify-send "${btsync_bin} does not exist so cannot start."
    else
      echo "${btsync_bin} does not exist so cannot start."
    fi
    
  fi


}


chkbin' >> ${StartScript}

}

checkArc(){    
    ARC=$(getconf LONG_BIT) #get the arcitecture of the machine
    
    echo
    echo
    echo "Detecting system architecure..."
    
    if [ ${ARC} = "64" ];then
      echo
      echo "Detected 64 bit architecture! (^-^)"
      echo "Downloading latest stable release..."
      echo
      wget ${URL64} -P /tmp
      checkFile              #execute function which verifies downloaded file
      
    elif [ ${ARC} = "32" ];then
      echo
      echo "Detected 32 bit architecture!"
      echo "Downloading latest stable release"
      echo
      wget ${URL32} -P /tmp
      checkFile
      
    else
      echo "Could not detect machine architecture!"
      exit 0;
    fi
}


rmArchive(){

  echo
    
  
    
  if [ -f /tmp/stable ];then #check if archive file exists
    echo -e "Removing /tmp/stable\n"
    rm /tmp/stable
  elif [ ! -f /tmp/stable ];then
    echo "The archive file: /tmp/stable was removed"
    echo
      
  fi

}
checkFile(){
 
  if [ -f /tmp/stable ];then  #check if downloaded file exists
    echo "Backing up .sync directory to: ${BackupDir}"
    echo
    if [ -d ${destDir}.sync ];then
      echo
      echo "Backing up .sync directory to: ${BackupDir}"
      bacKup
      echo
    else
      echo "No .sync folder found"
      
    fi
    echo
    echo -e "Extracting archive to: ${destDir}\n"
    tar xvf /tmp/stable -C ${destDir} #extract archive contents to destDir
    rmArchive
    checkPid #execute function which checks for process ID of btsync
    
    
       
  elif [ ! -f /tmp/stable ];then #check if downloaded file does not exist
    echo "The file archive doesn't seem to exist"
    echo "Either you don't have correct permissions, the URL has an issue"
    echo "or there is no internet connection."
    checkPid
    
  
  else
    echo "Something went wrong!"
    exit 0;
    
  fi
}

askOpen(){
  if [ "${AskPrompt}" = "enable" ];then
    echo "================================================================="
    echo "NOTE: You can disable the prompt below in the script itself"
    echo
    echo -n "Do you want to open the BtSync interface?(y/n): "
    read answer
  
    if [ "${answer}" = "y" ];then
    
      xdg-open http://localhost:8888 > /dev/null
    
    
    else
      echo
      echo "You can manage your secret keys by opening your web browser"
      echo "and entering: http://localhost:8888 into the address bar"
      echo
      exit 0;
    
    fi
  elif [ "${AskPrompt}" = "disable" ];then
    echo
    echo "You can manage your secret keys by opening your web browser"
    echo "and entering: http://localhost:8888 into the address bar"
    echo
    exit 0;
  else
    echo "Please set the variable 'AskOpen' to enable or disable"
    
  fi

}

KillBts(){
  btsync_pid=$(pidof btsync)
  #Send any errors to /dev/null | grep pid | extract 1st field using space as
  #dilimiter | take the first line only
  PIDUID=$(awk '/^Uid:/{print $2}' /proc/${btsync_pid}/status)
  OUTPIDUID=$(getent passwd "${PIDUID}" | awk -F: '{print $1}')
  if [ "${OUTPIDUID}" != "${USER}" ];then 
    sudo /bin/kill -s KILL ${btsync_pid}
    echo "Process was killed by superuser"
  
  else
    /bin/kill -s KILL ${btsync_pid}
    echo "Process was killed by user"
  
  fi

}


chkGenScript(){
  if [ "${MakeStartScript}" = "enabled" ];then
    if [ -f ${StartScript} ];then
      echo 
      echo "${StartScript} already exists!"
    
    else
      scriptGen
    
      if [ -f ${StartScript} ];then
	chmod +x ${StartScript}
	echo
	echo "Start/Stop script was created in: ${StartScript}"
	notify-send "Start/Stop script was created in: ${StartScript}"
      
      else
	echo
	echo "Start/Stop script was not created!"
      fi
    fi
  elif [ "${MakeStartScript}" = "disabled" ];then
    echo "Generate Start Script: disabled"
      
   
  fi
}

chkBin(){    
    if [ -f ${destDir}btsync ];then #check if binary exists
      ${destDir}btsync
      echo
      echo "done!"
      chkGenScript
      askOpen
      chkNotify
      
    elif [ ! -f ${destDir}btsync ];then #check if binary does not exist 
      echo "${destDir}btsync does not seem to exist!"
      exit 0;
    fi
    
}


checkPid(){
  btsync_pid=$(pidof btsync)
  #echo "The pid is: ${btsync_pid}" #for testing purposes
  echo
  echo -e "Killing existing process...\n"
  if [[ ${btsync_pid} ]];then #check if pid exists
    echo
    KillBts
    echo  
    echo "Waiting 4 seconds for process to kill.."
    echo "4";sleep 1;echo "3";sleep 1;echo "2";sleep 1;echo "1";sleep 1;
      
    echo
    echo -e "Starting BtSync...\n"
    chkBin
    
    elif [[ -z ${btsync_pid} ]];then #-z checks if string is empty (no pid)
    echo
    echo -e "Starting BtSync...\n"
    chkBin
  fi 
      

}

bacKup(){
  
  if [ -d ${BackupDir} ];then
    cd ${destDir}
    tar czvf ${BackupFile} .sync
    mv ${BackupFile} ${BackupDir}
    
    if [ -f ${BackupDir}${BackupFile} ];then
      echo
      echo "Backup file created in: ${BackupDir}${BackupFile}"
    elif [ ! -f ${BackupDir}${BackupFile} ];then
      echo
      echo "Could not create backup file in: ${BackupDir}"
    fi
    
  elif [ ! -d ${BackupDir} ];then
    mkdir -p ${BackupDir}
    cd ${destDir}
    tar czvf ${BackupFile} .sync
    mv ${BackupFile} ${BackupDir}
    
  else
    echo "Something went wrong creating ${BackupDir}"
    
  fi
    
    


}

chkNotify(){
if [ "${Notify}" = "enable" ];then
  if [ -f /usr/bin/notify-send ];then
  notify-send "BtSync has finished installing to: ${destDir}"

  
  else
    exit 0;
  fi
  
elif [ "${Notify}" = "disable" ];then
  return;
  
else
  exit 0;
fi

}

checkDir(){

  echo "|======================================|"
  echo "|                                      |"
  echo "|                Mibsi                 |"
  echo "|               v0.05a-9               |"
  echo "|         Released: 12/27/2013         |"
  echo "|     http://mibsi.homebutter.com      |"
  echo "|                                      |"
  echo "|======================================|"


  if [ -d ${destDir} ];then #verify if destDir exists
    checkArc
               
  elif [ ! -d ${destDir} ];then #verify if destDir does not exist
     mkdir -p ${destDir}
   if [ -d ${destDir} ];then #check status of last run command (mkdir)
     checkArc
   elif [ ! -d ${destDir} ];then
       echo "Directory: ${destDir} could not be created!"
       exit 0;
   fi
  

     
 fi
}

checkDir
