#!/bin/bash                                            
 
sleep 10                                               
 
notify-send "ATTENTION:" "All local data will be lost during logout or restart! Make sure your data is backed up in the cloud or on an external device if necessary."   
 
sleep 60                                                
 
pkill notify-send                                          

