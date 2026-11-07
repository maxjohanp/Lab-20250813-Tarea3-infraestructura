#!/bin/bash
# ZBX-0813 · red dentro de GNS3 (se pega por SSH desde Windows: ssh maxy0813@192.168.56.111)
#   enp0s3 = adaptador 1 · LAN del laboratorio · cliente DHCP del router (reserva 10.20.25.10)
#   enp0s8 = adaptador 2 · sólo-anfitrión · web de Zabbix y SSH desde Windows
# dhcp-identifier: mac -> el router reconoce a ZBX-0813 por 01 + MAC (client-identifier de la reserva)
sudo tee /etc/netplan/50-cloud-init.yaml >/dev/null <<'YAML'
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
      dhcp-identifier: mac
      optional: true
    enp0s8:
      dhcp4: true
YAML
sudo chmod 600 /etc/netplan/50-cloud-init.yaml && sudo netplan apply
sudo networkctl renew enp0s3
sleep 5
networkctl status enp0s3 --no-pager
ip -br a
