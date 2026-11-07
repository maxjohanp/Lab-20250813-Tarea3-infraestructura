# Evidencias

Capturas tomadas durante la práctica (6 de noviembre de 2026). La comunidad SNMP está tapada donde aparecía.

| # | Archivo | Qué se ve |
|---|---|---|
| 01 | [`01-topologia-gns3.png`](01-topologia-gns3.png) | Proyecto de GNS3: R1 (R-0813) ↔ Switch-1 (SW-0813) ↔ ZBX-0813-1, los tres encendidos |
| 02 | [`02-ubuntu-instalacion-perfil.png`](02-ubuntu-instalacion-perfil.png) | Instalador de Ubuntu Server: nombre del servidor `zbx-0813` |
| 03 | [`03-zabbix-asistente-resumen.png`](03-zabbix-asistente-resumen.png) | Asistente web de Zabbix: MySQL en localhost, base y usuario `zabbix`, servidor `ZBX-0813` |
| 04 | [`04-zabbix-dashboard.png`](04-zabbix-dashboard.png) | Dashboard de Zabbix 7.0.32 en `http://192.168.56.111/zabbix`, servidor en marcha |
| 05 | [`05-zbx-netplan-dhcp.png`](05-zbx-netplan-dhcp.png) | Netplan aplicado por SSH: `enp0s3` con `dhcp-identifier: mac` y la MAC 08:00:27:06:b9:0f |
| 06 | [`06-zbx-ip-por-dhcp.png`](06-zbx-ip-por-dhcp.png) | `ip a` dentro de GNS3: `enp0s3` con 10.20.25.10/24 dinámica y `enp0s8` con 192.168.56.111 |
| 07 | [`07-r-dhcp-binding.png`](07-r-dhcp-binding.png) | R-0813: `show ip dhcp binding` → 10.20.25.10 · `0108.0027.06b9.0f` · Manual · Active |
| 08 | [`08-sw-dhcp-snooping-y-vlan.png`](08-sw-dhcp-snooping-y-vlan.png) | SW-0813: `show ip dhcp snooping binding` (ZBX en Gi0/1, VLAN 13) y `show vlan brief` |
| 09 | [`09-zbx-snmpwalk-r-y-sw.png`](09-zbx-snmpwalk-r-y-sw.png) | `snmpwalk` desde ZBX-0813: grupo *system* de R-0813 y de SW-0813 |
| 10 | [`10-zabbix-macro-comunidad-secreta.png`](10-zabbix-macro-comunidad-secreta.png) | Host en Zabbix con la macro `{$SNMP_COMMUNITY}` de tipo *Secret text* |
| 11 | [`11-zabbix-hosts-snmp-disponible.png`](11-zabbix-hosts-snmp-disponible.png) | Monitoring ▸ Hosts: R-0813 y SW-0813 con SNMP disponible (54 y 50 ítems) |
| 12 | [`12-zabbix-datos-r-0813.png`](12-zabbix-datos-r-0813.png) | Latest data de R-0813: CPU, fuentes, modelo CISCO7206VXR, memoria y temperatura |
| 13 | [`13-zabbix-datos-sw-0813.png`](13-zabbix-datos-sw-0813.png) | Latest data de SW-0813: ping ICMP, tiempo de respuesta y tráfico de Gi0/0 |
| 14 | [`14-zabbix-interfaces-descubiertas.png`](14-zabbix-interfaces-descubiertas.png) | Interfaces descubiertas por SNMP (Fa0/0, Gi0/0, Gi0/1, Vl13) con sus descripciones |
| 15 | [`15-zabbix-r-snmp-timeout.png`](15-zabbix-r-snmp-timeout.png) | R-0813 sin respuesta SNMP mientras la macro tenía la comunidad en minúsculas |
