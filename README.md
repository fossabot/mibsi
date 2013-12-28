#Mibsi


###A mindless btsync installer Bash script  
  
    
Main Site: http://mibsi.homebutter.com

<hr>


#Getting the latest stable release  
To get the latest stable release, copy the following entire command into terminal:
```bash
wget http://mibsi.homebutter.com/downloads/latest/stable/mibsi-latest-stable.tar.gz && \  
tar xzvf mibsi-latest-stable.tar.gz && \  
cd mibsi && \    
chmod +x mibsi.sh && \  
./mibsi.sh  
```  
#Features  
- Automatically downloads and extracts the latest stable version of BtSync for your system arcitecture
- Automatically creates a backup archive of your .sync folder to a defined directory
- Ability to generate a start/stop toggle script for BtSync binary automatically
- Can be used as a general boot script for BtSync
- Lets user define installation directories
- Asks if user wishes to open BtSync web frontend

#Default Settings

Installation Directory: /home/user/.btsync/  
Backup Directory: /home/user/.btsync/backup/  
Automatic toggle script creation: "disabled"  
Output directory of toggle script: /home/user/   
Ask to open web frontend: "enabled"  
Graphical notifications: "enabled" 










