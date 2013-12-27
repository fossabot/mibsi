#!/bin/bash
btsync_bin=/home/${USER}/.btsync/btsync
start_btsync(){
  btsync_pid=$(pidof btsync)
  
  if [ ${btsync_pid} ];then
    notify-send "BtSync is already running"
  
  else
    ${btsync_bin}
    #sleep 4
    btsync_pid=$(pidof btsync)
    if [ ${btsync_pid} ];then
      notify-send "BtSync was Started on PID: ${btsync_pid}"
      
    else
      notify-send "not started"
      
    fi
  fi

}

stop_btsync(){
  btsync_pid=$(pidof btsync)
  
  
  if [ ! ${btsync_pid} ];then
    notify-send "BtSync is not running"
    
  else
    kill -9 ${btsync_pid}
    #sleep 4
    btsync_pid=$(pidof btsync)
    if [ ! ${btsync_pid} ];then
      notify-send "BtSync was Killed"
      
    else
      notify-send "not killed"
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
    notify-send "${btsync_bin} does not exist so cannot start."
    
  fi


}

chkbin
