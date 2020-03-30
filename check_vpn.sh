#!/bin/bash

##################################################################
# Script: check_vpn.sh                                           #
# Author: Wilson Fernandes                                       #
# Contact: Email: wilsonwers@gmail.com                           #
# Date: 2020-03-30                                               #
# Description: Monitoramento cliente VPN SSL Fortigate           #
# Use: check_vpn.sh 192.168.0.1 wfernandes time                  #
##################################################################

IP=$1
USER=$2
OP=$3
COMMUNITY=public
SNMP="snmpwalk -v 2c -c "${COMMUNITY}" "${IP}"" 

user="$(timeout 5 "${SNMP}" .1.3.6.1.4.1.12356.101.12.2.4.1.3 | grep "${USER}" | cut -d'.' -f9 | awk '{print $1}')"

if [ -z $user ]; then
echo "0"
exit 1
else
case $OP in

in)
${SNMP} .1.3.6.1.4.1.12356.101.12.2.4.1.7.${user}  | awk -F":"  '{print $4}'
;;

out)
${SNMP} .1.3.6.1.4.1.12356.101.12.2.4.1.8.${user}  | awk -F":"  '{print $4}'
;;

time)
${SNMP} .1.3.6.1.4.1.12356.101.12.2.4.1.6.${user}  | awk -F":"  '{print $4}'
;;

*)
echo "ZBX_NOTSUPPORTED: Unsupported item key."
;;
esac
fi
