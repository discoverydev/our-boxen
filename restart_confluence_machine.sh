#!/bin/sh
progress_bar() {
  SECS=120
  while [[ 0 -ne $SECS ]]; do
    echo ".\c"
    sleep 1
    SECS=$[$SECS-1]
  done
  echo "\nTime is up, moving on."
}

# sleeping in order to allow the box to stabilize before the script starts
progress_bar

export PATH=/opt/boxen/homebrew/bin:$PATH
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/ga-mlsdiscovery/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

echo "* Restarting Confluence machine"
echo "** shutting boot2docker down"
boot2docker down

echo "** boot2docker startup"
$(boot2docker shellinit)
boot2docker up --vbox-share=disable
boot2docker ip

echo "* enable host nfs daemon for /Users"
echo "/Users -mapall=`whoami`:staff `boot2docker ip`\n" >> exports
sudo mv exports /etc && sudo /sbin/nfsd restart
sleep 15

echo "* enable boot2docker nfs client"
boot2docker ssh 'ls -ltra /var/lib/boot2docker/'
boot2docker ssh '. /var/lib/boot2docker/bootlocal.sh'
echo "* display mounted nfs share"
boot2docker ssh mount
boot2docker ssh 'ls -ltra /Users'

echo "* defining directory for data shares (must be under the above nfs share)"
DATA_DIR=/Users/Shared/data

echo "** docker confluence startup"
docker --tlsverify=false restart confluence
docker ps

echo "* wait for confluence to startup"
progress_bar

echo "** open confluence browser"
open http://localhost:8090/
