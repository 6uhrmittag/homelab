#!/usr/bin/env bash

VM_NAME=$1
VM_HDD=$2
VM_RAM="1024"
VM_RAM=$3

PATH_VMS='/var/lib/libvirt/images'
PATH_TMP='/var/lib/libvirt/images/template_ubuntu_20.img'

cat <<EOF >> "$PATH_VMS"/"$VM_NAME"_init.txt
#cloud-config
hostname: $VM_NAME
fqdn: $VM_NAME.slashlog.org
manage_etc_hosts: true
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    home: /home/ubuntu
    shell: /bin/bash
    lock_passwd: false
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDW7vQpNngL64CA1jzlxCsmmm5sKkJTncK64scLa4vpUz2HuZ3hM5bOrsbnr1En1SPnWIApyQGkY8OzNCHWDzJYJwkiFembxUR5pRsUjaC0399JHtmkZaIycgDB0nRvDLxWh07/OcQvBK2TWtewtcwHOTqBfIH/NU4eXeFQez3kDMR9sEQJO9ZiEe3uvqhKPTEfxJeMjvSCvwVA5LJoh6NGFbdhobI9ntGai7aKS8ZT6T5gQAbCX1SmmiWH9qKzKnBem/qWdXlbwOviwPx6cD/u1IxvOI3E+b96bs9sRrlYgtk7xLn3ai/rRw729llv7GWP6KbrNBy0uBbdIZ6DP3FGeLBSVexl9xM9XBQVL2dbhFhM5yg56wpa2NrDPv5WErstWEFchwAKtXoBfkxiuimo1Jsz7kOryYzkJcGmkUG7SySwAi5j7kzTov86QxVYzr8OSEp/WjVVlwivGlA9zC0f1mHMS+jd3ERFFXOQM4EENmd9qbleRzk9tjdbPiwbcIhEgDr+76uo+V5l5OaKVXVFcuuqAy8wG5PVgA/0VSEMEW8Q+LOgtCuBQPIJr3Mt1K/RLwwR5VcA6X+7XbqDOfl28K3Tq5HS7eeSoSsqXRXnM44z9TuCOEsvf96igcoACVEbBywGsS5vdiqTewE44HmD2LS8tNyCqRdNIEZRSVNFKw== marvin@6uhrmittag.de
# only cert auth via ssh (console access can still login)
ssh_pwauth: false
disable_root: false
chpasswd:
  list: |
     ubuntu:linux
  expire: False
packages:
  - qemu-guest-agent
  - vim
  - git
package_upgrade: true
EOF

qemu-img create -v -b "$PATH_TMP" -f qcow2 "$PATH_VMS"/"$VM_NAME"-ubuntu20.qcow2 "$VM_HDD"

cloud-localds "$PATH_VMS"/$VM_NAME.iso "$PATH_VMS"/"$VM_NAME"_init.txt


virt-install \
--name $VM_NAME \
--memory $VM_RAM \
--vcpus 8 \
--disk "$PATH_VMS"/"$VM_NAME"-ubuntu20.qcow2,device=disk,bus=virtio \
--disk "$PATH_VMS"/$VM_NAME.iso,device=cdrom \
--os-type linux \
--os-variant ubuntu20.04 \
--virt-type kvm \
--graphics none \
--network network=default \
--autostart \
--import  \
--noautoconsole
