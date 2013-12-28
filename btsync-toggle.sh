#!/bin/bash
btsync_bin=/home/${USER}/.btsync/btsync

chkNotify(){
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

chkbin
