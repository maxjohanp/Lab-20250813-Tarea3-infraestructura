#!/bin/bash
# ZBX-0813 · comprueba desde el servidor el SNMP de solo lectura de R-0813 y SW-0813
# Uso: bash ZBX-0813_verificar-snmp.sh   (la comunidad se escribe cuando la pide; no queda guardada)
read -rsp 'Comunidad SNMP: ' C; echo
for ip in 10.20.25.1 10.20.25.2; do
  echo "== $ip · grupo system (sysDescr, sysName, sysLocation...)"
  snmpwalk -v2c -c "$C" "$ip" 1.3.6.1.2.1.1
done
echo "== Interfaces de R-0813 (IF-MIB::ifDescr)"
snmpwalk -v2c -c "$C" 10.20.25.1 1.3.6.1.2.1.2.2.1.2
echo "== Interfaces de SW-0813 (IF-MIB::ifDescr)"
snmpwalk -v2c -c "$C" 10.20.25.2 1.3.6.1.2.1.2.2.1.2
