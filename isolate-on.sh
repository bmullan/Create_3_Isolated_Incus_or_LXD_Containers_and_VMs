#!/bin/bash

OS="ubuntu"
VER="24.04"

echo
echo
echo
echo "====={ Create isolated LXD/Incus VMs & Containers }======================================"
echo
echo " Purpose:"
echo
echo " Create and Network Isolate 3 LXD/Incus VMs/ Containers from each other but not the"
echo " LXD/Incus Host or the Internet"
echo
echo " Which Container/VM System Environment do you want to create the isolated set of"
echo " Containers & VMs behind separate xBR0 bridges?"
echo
echo


#"==={ FUNCTION:  Incus Isolate On }==========================================================="

incus-isolate-on () {

echo
echo "------------------------------------------------------"
echo "You chose to create the isolated Incus VM & Containers"
echo

#====================================================================
# Create 3 Incus bridges.  Incus Containers and Incus VMs created and
# attached to these Incus Bridges will be on different 10.x.x.x
# subnets from each other depending on which LXDBRx bridge they are
# attached to at creation.

incus network create incusbr1
incus network create incusbr2
incus network create incusbr3

#====================================================================
# Create ACL firewall rules required to isolate cn1, cn2 and cn3 from
# direct communication with each other as well as vm1, vm2 and vm3
# isolated from each other

sudo iptables -A FORWARD -i incusbr1 -o incusbr2 -j REJECT
sudo iptables -A FORWARD -i incusbr1 -o incusbr3 -j REJECT
sudo iptables -A FORWARD -i incusbr2 -o incusbr1 -j REJECT
sudo iptables -A FORWARD -i incusbr2 -o incusbr3 -j REJECT
sudo iptables -A FORWARD -i incusbr3 -o incusbr1 -j REJECT
sudo iptables -A FORWARD -i incusbr3 -o incusbr2 -j REJECT

#====================================================================
# Create 3 Incus Containers using Ubuntu $OS:$VER
#
# Assign cn1 to use the incusbr1 bridge
# Assign cn2 to use the incusbr2 bridge
# Assign cn3 to use the incusbr3 bridge

incus launch images:$OS/$VER cn1 -n incusbr1
incus launch images:$OS/$VER cn2 -n incusbr2
incus launch images:$OS/$VER cn3 -n incusbr3

#====================================================================
# Create 3 Incus VMs (vm1, vm2, vm3) using $OS:$VER
#
# Assign vm1 to use the incusbr1 bridge
# Assign vm2 to use the incusbr2 bridge
# Assign vm3 to use the incusbr3 bridge

incus launch images:$OS/$VER vm1 --vm -n incusbr1
incus launch images:$OS/$VER vm2 --vm -n incusbr2
incus launch images:$OS/$VER vm3 --vm -n incusbr3

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

}

#"==={ FUNCTION:  LXD Isolate On }==========================================================="

lxd-isolate-on () {
echo
echo "----------------------------------------------------"
echo "You chose to create the isolated LXD VM & Containers"
echo

#====================================================================
# Create 3 LXD bridges.  LXD Containers and LXD VMs created and
# attached to these LXD Bridges will be on different 10.x.x.x subnets
# from each other depending on which LXDBRx bridge they are attached
# to at creation.

lxc network create lxdbr1
lxc network create lxdbr2
lxc network create lxdbr3

#====================================================================
# Create ACL firewall rules required to isolate cn1, cn2 and cn3 from
# direct communication with each other as well as vm1, vm2 and vm3
# isolated from each other

sudo iptables -A FORWARD -i lxdbr1 -o lxdbr2 -j REJECT
sudo iptables -A FORWARD -i lxdbr1 -o lxdbr3 -j REJECT
sudo iptables -A FORWARD -i lxdbr2 -o lxdbr1 -j REJECT
sudo iptables -A FORWARD -i lxdbr2 -o lxdbr3 -j REJECT
sudo iptables -A FORWARD -i lxdbr3 -o lxdbr1 -j REJECT
sudo iptables -A FORWARD -i lxdbr3 -o lxdbr2 -j REJECT

#====================================================================
# Create 3 LXD containers using Ubuntu 22.04LTS
#
# Assign cn1 to use the LXDBR1 bridge
# Assign cn2 to use the LXDBR2 bridge
# Assign cn3 to use the LXDBR3 bridge

lxc launch $OS:$VER cn1 -n lxdbr1
lxc launch $OS:$VER cn2 -n lxdbr2
lxc launch $OS:$VER cn3 -n lxdbr3

#====================================================================
# Create 3 LXD VMs (vm1, vm2, vm3) using Ubuntu 22.04LTS
#
# Assign vm1 to use the LXDBR1 bridge
# Assign vm2 to use the LXDBR2 bridge
# Assign vm3 to use the LXDBR3 bridge

lxc launch $OS:$VER vm1 --vm -n lxdbr1
lxc launch $OS:$VER vm2 --vm -n lxdbr2
lxc launch $OS:$VER vm3 --vm -n lxdbr3

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

}

LIST=$'LXD\nIncus\nQuit'

IFS=$'\n'
select OPT in $LIST; do
    case "$OPT" in
        LXD) lxd-isolate-on ;;
        Incus) incus-isolate-on ;;
        *) break;;
    esac
done


echo "----------------------------------"
echo "All done... "
echo
exit

