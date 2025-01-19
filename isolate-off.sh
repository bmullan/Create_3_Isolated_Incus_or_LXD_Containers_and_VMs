#!/bin/bash

echo
echo
echo
echo "====={ Destroy isolated LXD/Incus VM & Container Environment }==========================="
echo
echo " Purpose:"
echo
echo " Which Container/VM System Environment do you want to delete LXD or Incus?"
echo
echo


#"==={ FUNCTION:  Incus Isolate Off }=========================================================="

incus-isolate-off () {

echo
echo "---------------------------------------------------------------------"
echo "You chose to DELETE the isolated Incus environment of VM & Containers"
echo

#"===================================================================="
#" Delete the 3 Incus Containers"

incus delete cn1 --force
incus delete cn2 --force
incus delete cn3 --force

#"===================================================================="
# Delete the 3 Incus VMs

incus delete vm1 --force
incus delete vm2 --force
incus delete vm3 --force

#====================================================================
# Delete the 3 Incus bridges.

incus network delete incusbr1
incus network delete incusbr2
incus network delete incusbr3

#
#
sudo ip link set dev incusbr1 down
sudo ip link set dev incusbr2 down
sudo ip link set dev incusbr3 down
#
sudo brctl delbr incusbr1
sudo brctl delbr incusbr2
sudo brctl delbr incusbr3

echo
echo
echo "Listing of remaining Incus Containers, VMs and their Incus Bridges..."
echo
echo

incus ls

echo
echo
echo

}

#"==={ FUNCTION:  LXD Isolate OFF }==========================================================="

lxd-isolate-off () {
echo
echo "---------------------------------------------------------------"
echo "You chose to DELETE the isolated LXD VM & Container environment"
echo

#"===================================================================="
#"Delete the 3 LXD containers"

lxc delete cn1 --force
lxc delete cn2 --force
lxc delete cn3 --force

#"===================================================================="
#"Delete the 3 LXD VMs (vm1, vm2, vm3)"

lxc delete vm1 --force
lxc delete vm2 --force
lxc delete vm3 --force

#"===================================================================="
#"Delete the 3 LXD bridges."

lxc network delete lxdbr1
lxc network delete lxdbr2
lxc network delete lxdbr3

#
#

sudo ip link set dev lxcbr1 down
sudo ip link set dev lxcbr2 down
sudo ip link set dev lxcbr3 down

sudo brctl delbr lxcbr1
sudo brctl delbr lxcbr2
sudo brctl delbr lxcbr3

echo
echo
echo "Listing any remaining LXD Containers and VMs..."
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
        LXD) lxd-isolate-off ;;
        Incus) incus-isolate-off ;;
        *) break;;
    esac
done


echo "--------"
echo "  Done  "
echo "--------"
echo
exit






