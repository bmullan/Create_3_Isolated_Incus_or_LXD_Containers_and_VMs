#!/bin/bash

OS="ubuntu"
VER="24.04"

echo
echo
echo
echo "====={ delete isolated LXD/Incus VMs & Containers }======================================"
echo
echo " Purpose:"
echo
echo " delete and Network Isolate 3 LXD/Incus VMs/ Containers from each other but not the"
echo " LXD/Incus Host or the Internet"
echo
echo " Which Container/VM System Environment do you want to delete the isolated set of"
echo " Containers & VMs behind separate xBR0 bridges?"
echo
echo

LIST=$'LXD\nIncus\nQuit'

IFS=$'\n'
select OPT in $LIST; do
    case "$OPT" in
        LXD) echo "1";;
        Incus) echo "2";;
        *) break;;
    esac
done

exit

if $OPT="LXD"
then
echo
echo "----------------------------------------------------"
echo "You chose to delete the isolated LXD VM & Containers"
echo

#====================================================================
# delete 3 LXD bridges.  LXD Containers and LXD VMs deleted and 
# attached to these LXD Bridges will be on different 10.x.x.x subnets
# from each other depending on which LXDBRx bridge they are attached
# to at creation.

lxc network delete lxdbr1
lxc network delete lxdbr2
lxc network delete lxdbr3

#====================================================================
# delete ACL firewall rules required to isolate cn1, cn2 and cn3 from
# direct communication with each other as well as vm1, vm2 and vm3
# isolated from each other

sudo iptables -A FORWARD -i lxdbr1 -o lxdbr2 -j REJECT
sudo iptables -A FORWARD -i lxdbr1 -o lxdbr3 -j REJECT
sudo iptables -A FORWARD -i lxdbr2 -o lxdbr1 -j REJECT
sudo iptables -A FORWARD -i lxdbr2 -o lxdbr3 -j REJECT
sudo iptables -A FORWARD -i lxdbr3 -o lxdbr1 -j REJECT
sudo iptables -A FORWARD -i lxdbr3 -o lxdbr2 -j REJECT

#====================================================================
# delete 3 LXD containers using Ubuntu 22.04LTS
#

lxc delete cn1 --force
lxc delete cn2 --force
lxc delete cn3 --force

#====================================================================
# delete 3 LXD VMs (vm1, vm2, vm3) using Ubuntu 22.04LTS
#

lxc delete vm1 --force
lxc delete vm2 --force
lxc delete vm3 --force

echo
echo
echo "Listing of new LXD Containers, VMs and their LXD Bridges..."
echo
echo "Note:"
echo "The VMs may take a few seconds to get their IPv4 address listed."
echo "Notice CN1 and VM1 etc...  are on the same 10.x.x.x subnet."
echo
echo

lxc ls

echo
echo
echo


break

elif [ $OPT = "Incus" ] &> /dev/null
then
echo
echo "------------------------------------------------------"
echo "You chose to delete the isolated Incus VM & Containers"
echo

#====================================================================
# delete 3 Incus bridges.  Incus Containers and Incus VMs deleted and
# attached to these Incus Bridges will be on different 10.x.x.x
# subnets from each other depending on which LXDBRx bridge they are
# attached to at creation.

lxc network delete incusbr1
lxc network delete incusbr2
lxc network delete incusbr3

#====================================================================
# delete ACL firewall rules required to isolate cn1, cn2 and cn3 from
# direct communication with each other as well as vm1, vm2 and vm3
# isolated from each other

sudo iptables -A FORWARD -i incusbr1 -o incusbr2 -j REJECT
sudo iptables -A FORWARD -i incusbr1 -o incusbr3 -j REJECT
sudo iptables -A FORWARD -i incusbr2 -o incusbr1 -j REJECT
sudo iptables -A FORWARD -i incusbr2 -o incusbr3 -j REJECT
sudo iptables -A FORWARD -i incusbr3 -o incusbr1 -j REJECT
sudo iptables -A FORWARD -i incusbr3 -o incusbr2 -j REJECT

#====================================================================
# delete 3 Incus Containers using Ubuntu $OS:$VER
#

incus delete cn1 --force
incus delete cn2 --force
incus delete cn3 --force

#====================================================================
# delete 3 Incus VMs (vm1, vm2, vm3) using $OS:$VER
#

incus delete vm1 --force
incus delete vm2 --force
incus delete vm3 --force


echo
echo
echo "Listing of new Incus Containers, VMs and their Incus Bridges..."
echo
echo "Note:"
echo "The VMs may take a few seconds to get their IPv4 address listed."
echo "Notice CN1 and VM1 etc...  are on the same 10.x.x.x subnet."
echo
echo
incus ls

echo
echo
echo

break


elif [ $OPT = "Quit" ] &> /dev/null
then
echo
echo "----------------------------------"
echo "All done... "
echo
exit
break

fi
done

