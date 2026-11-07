# ZBX-0813 · configuración aplicada (Ubuntu Server y Zabbix)

Ubuntu no tiene un *running-config* como IOS. Este archivo recoge la configuración aplicada en el servidor, sin secretos, con las capturas que la muestran (carpeta [`docs/Evidencias`](../docs/Evidencias)). Se hizo con [`scripts/ZBX-0813_instalar-zabbix.sh`](../scripts/ZBX-0813_instalar-zabbix.sh) y [`scripts/ZBX-0813_red.sh`](../scripts/ZBX-0813_red.sh).

## Máquina virtual · capturas 02 y 04

| Parámetro | Valor |
|---|---|
| Sistema | Ubuntu Server 24.04.5 LTS (instalación estándar, con OpenSSH) |
| Virtualización | VM de VirtualBox `ZBX-0813`: 2 vCPU, 2 GB de RAM, disco de 20 GB |
| En GNS3 | Nodo VirtualBox `ZBX-0813-1`, plantilla con **2 adaptadores** y *Allow GNS3 to use any configured VirtualBox adapter* **desmarcado** |
| Nombre del equipo | `zbx-0813` |
| Usuario | `maxy0813` (clave: `<ELIMINADO>`) |
| Zona horaria | America/Santo_Domingo (UTC-04:00), igual que `clock timezone AST -4 0` en IOS |

## Red · capturas 05 y 06

| Adaptador de VirtualBox | Interfaz | Conectado a | IP | Uso |
|---|---|---|---|---|
| 1 · *No conectado* (lo maneja GNS3) | `enp0s3` | Gi0/1 de SW-0813, VLAN 13 | 10.20.25.10/24 por **DHCP** de R-0813 (reserva por MAC 08:00:27:06:B9:0F) | Consultas SNMP a R-0813 y SW-0813 |
| 2 · Sólo-anfitrión | `enp0s8` | VirtualBox Host-Only Ethernet Adapter | 192.168.56.111/24 por DHCP de VirtualBox | Web de Zabbix y SSH desde Windows |

Durante la instalación, el adaptador 1 estuvo en NAT para descargar los paquetes; después se dejó en *No conectado* para que GNS3 lo cablee. El archivo de netplan es [`ZBX-0813_netplan.yaml`](ZBX-0813_netplan.yaml): `dhcp-identifier: mac` hace que el cliente se identifique con `01` + MAC, que es lo que espera la reserva del router.

## Zabbix · capturas 03 y 04

| Parámetro | Valor |
|---|---|
| Versión | Zabbix 7.0.32 LTS (servidor, frontend y agente) desde `repo.zabbix.com` |
| Base de datos | MySQL 8.0 · base `zabbix` (utf8mb4 / utf8mb4_bin) · usuario `zabbix` (clave: `<ELIMINADO>`) |
| Web | Apache + PHP 8.3 · `http://192.168.56.111/zabbix` · nombre del servidor `ZBX-0813` |
| Herramientas | Net-SNMP (`snmpwalk`, `snmpget`) con las MIB estándar cargadas (`snmp-mibs-downloader`) |
| Acceso web | Usuario `Admin` (clave: `<ELIMINADO>`) |

## Hosts monitoreados · capturas 10 a 14

| Host | Grupo | Interfaz | Plantilla | Comunidad | Datos |
|---|---|---|---|---|---|
| R-0813 | Red LAB0813 | SNMP v2c · 10.20.25.1:161 | Cisco IOS by SNMP | macro `{$SNMP_COMMUNITY}` tipo *Secret text* | 54 ítems · 5 gráficas |
| SW-0813 | Red LAB0813 | SNMP v2c · 10.20.25.2:161 | Cisco IOS by SNMP | macro `{$SNMP_COMMUNITY}` tipo *Secret text* | 50 ítems · 3 gráficas |
| Zabbix server | Zabbix servers | Agente · 127.0.0.1:10050 | (de fábrica) | — | 162 ítems |

## Cómo comprobarlo en el servidor

```bash
ip -br a
networkctl status enp0s3 --no-pager
systemctl is-active zabbix-server zabbix-agent apache2 mysql
snmpget -v2c -c <COMUNIDAD-RO> 10.20.25.1 sysName.0 sysDescr.0
snmpget -v2c -c <COMUNIDAD-RO> 10.20.25.2 sysName.0 sysDescr.0
```
