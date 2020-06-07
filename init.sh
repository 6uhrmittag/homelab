#!/usr/bin/env bash

#install requirements
REQUIREMENTS="vim git virt-manager"
if [[ ! -z $REQUIREMENTS ]]; then
    apt-get update
    apt-get install -y -q --no-install-recommends $REQUIREMENTS
fi

if [[ -f '/data/libvirt/template_ubuntu_20.img' ]]; then
  wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -O /data/libvirt/template_ubuntu_20.img
fi

curl https://github.com/6uhrmittag.keys | tee -a ~/.ssh/authorized_keys

chmod u+x ./bin/*
cp ./bin/* /usr/bin/

