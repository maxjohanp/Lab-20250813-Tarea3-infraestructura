#!/bin/bash
# ZBX-0813 · Zabbix 7.0 LTS (servidor, web y agente) con MySQL y Apache · Ubuntu Server 24.04
# Se ejecuta una vez, con la VM en NAT (internet) y por SSH desde Windows:  sudo bash ZBX-0813_instalar-zabbix.sh
# La clave del usuario zabbix de MySQL se escribe cuando la pide; no queda en este archivo.
set -euo pipefail
timedatectl set-timezone America/Santo_Domingo
cd /tmp
wget -q https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server zabbix-server-mysql zabbix-frontend-php \
  zabbix-apache-conf zabbix-sql-scripts zabbix-agent snmp
DEBIAN_FRONTEND=noninteractive apt-get install -y snmp-mibs-downloader || true
sed -i 's/^mibs :/# mibs :/' /etc/snmp/snmp.conf || true
locale-gen es_ES.UTF-8 > /dev/null
while true; do
  read -rsp 'Clave para el usuario zabbix de MySQL: ' P1; echo
  read -rsp 'Repítela: ' P2; echo
  [ -n "$P1" ] && [ "$P1" = "$P2" ] && break
  echo 'Vacía o no coincide. Otra vez.'
done
SQLP=${P1//\\/\\\\}; SQLP=${SQLP//\'/\'\'}
mysql <<SQL
CREATE DATABASE IF NOT EXISTS zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS 'zabbix'@'localhost' IDENTIFIED BY '${SQLP}';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
SQL
echo 'Importando el esquema de Zabbix (tarda un par de minutos)...'
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | MYSQL_PWD="$P1" mysql --default-character-set=utf8mb4 -uzabbix zabbix
mysql -e 'SET GLOBAL log_bin_trust_function_creators = 0;'
sed -i '/^DBPassword=/d' /etc/zabbix/zabbix_server.conf
printf 'DBPassword=%s\n' "$P1" >> /etc/zabbix/zabbix_server.conf
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
systemctl is-active zabbix-server apache2 mysql || true
echo "Listo. Web: http://$(ip -4 -br a show enp0s8 | awk '{print $3}' | cut -d/ -f1)/zabbix"
