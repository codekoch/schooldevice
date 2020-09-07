#!/bin/bash                                            
 
sleep 10                                               
 
notify-send "ACHTUNG:" "Alle lokalen Veränderungen am System gehen beim Logout verloren! Bitte sichern Sie ihre Daten auf einem externen Datenträger."   
 
sleep 60                                                
 
pkill notify-send                                          

