#!/usr/bin/env bash

#install requirements
REQUIREMENTS="vim git virt-manager qemu-kvm libvirt-daemon-system virtinst cloud-utils"
UPDATE=""
for PACKAGE in $REQUIREMENTS; do
  if [[ -n $UPDATE ]]; then
    apt-get update
    UPDATE="DONE"
  fi
  apt-get install -y -q --no-install-recommends $PACKAGE
done

if [[ -f '/var/lib/libvirt/images/template_ubuntu_20.img' ]]; then
  wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -O /var/lib/libvirt/images/template_ubuntu_20.img
fi

curl https://github.com/6uhrmittag.keys > ~/.ssh/authorized_keys

for file in $(ls ./bin); do
  cp ./bin/$file /usr/bin/
  chmod u+x /usr/bin/$file
done