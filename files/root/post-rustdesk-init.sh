#!/bin/sh
#
sleep 10

publickey=$(sh -c "cat /var/db/rustdesk-server/id_ed25519.pub")

echo " "
echo -e "\e[1;37m ################################################ \e[0m"
echo -e "\e[1;37m RustDesk Server agent credentials                \e[0m"
echo -e "\e[1;37m Server   : jail-host-ip                          \e[0m"
echo -e "\e[1;37m Key      : ${publickey}                          \e[0m"
echo -e "\e[1;37m ################################################ \e[0m"
echo " "

sleep 5
