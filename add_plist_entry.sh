#!/bin/bash -le 

echo "adding boxen.update.plist to launchctl... possibly removed by ADS push to machine."
rm -rf /tmp/workstation-files
git clone http://admin@stash/scm/cypher/workstation-files.git /tmp/workstation-files

cp /tmp/workstation-files/LaunchAgents/boxen.update.plist ~/Library/LaunchAgents/boxen.update.plist

#launchctl unload ~/Library/LaunchAgents/boxen.update.plist
launchctl load ~/Library/LaunchAgents/boxen.update.plist
launchctl list | grep boxen
