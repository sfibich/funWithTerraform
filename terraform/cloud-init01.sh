#! /bin/bash
echo "cloud init start" >> /tmp/cloud-init.log
sudo apt-get update -y >> /tmp/cloud-init.log
sudo apt-get upgrade -y >> /tmp/cloud-init.log


