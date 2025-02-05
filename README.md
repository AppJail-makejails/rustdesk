# rustdesk
Self hosted RustDesk server.

## Requirements
Before you can install RustDesk Server using this makejail you need some initial configurations

#### Enable Packet filter
We need add somes lines to /etc/rc.conf

```sh
# sysrc pf_enable="YES"
# sysrc pflog_enable="YES"

# cat << "EOF" >> /etc/pf.conf
nat-anchor 'appjail-nat/jail/*'
nat-anchor "appjail-nat/network/*"
rdr-anchor "appjail-rdr/*"
EOF
# service pf reload
# service pf restart
# service pflog restart
```
rdr-anchor section is necessary for use dynamic redirect from jails

### Enable forwarding
```sh
# sysrc gateway_enable="YES"
# sysctl net.inet.ip.forwarding=1
```
#### Bootstrap a FreeBSD version
Before you can begin creating containers, AppJail needs fetch and extract components for create jails. If you are creating FreeBSD jails it must be a version equal or lesser than your host version. In this example we will create a 14.2-RELEASE bootstrap

```sh
# appjail fetch
```
#### Create a virtualnet
Create a virtualnet for add RustDesk Server jail from rustdesk-server-makejail. Otherwise you can use your own virtualnet if you created it previously

```sh
# appjail network add rustdesk-net 10.0.0.0/24
```
it will create a bridge named ruskdesk-net in where Rust Desktop jail epair interfaces will be attached. By default rustdesk-server-makejail will use NAT for internet outbound. Do not forget added a pass rule to /etc/pf.conf because rustdesk-server-makefile will try to download and install packages and some another resources for configuration of it

```sh
pass out quick on rustdesk-net inet proto { tcp udp } from 10.0.0.2 to any
```

#### Create a lightweight container system
Create a container named rustdesk with a private IP address 10.0.0.2. Take on mind IP address must be part of rustdesk-net network

```sh
# appjail makejail -f gh+alonsobsd/rustdesk-server-makejail -j rustdesk -- --network rustdesk-net --server_ip 10.0.0.2
```
When it is done you will see credentials info for connect a supported RustDesk client to RustDesk Server.

```sh
 ################################################ 
 RustDesk Server agent credentials                
 Server   : jail-host-ip                          
 Key      : 2wEvTjkTqKdrV+0KAN+nhcI15RMGQX9ELmB2CC0SVMI=                          
 ################################################  
 ```
Keep them to another secure place

## License
This project is licensed under the BSD-3-Clause license.
