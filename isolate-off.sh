#!/bin/bash
#
# isolate-off.sh
#
echo
echo
echo
echo " Purpose:"
echo
echo " Remove isolated LXD/Incus VMs & Containers & xBR0 previously created"
echo "  by the 'isolate-on.sh' script."
echo
echo " Which Container/VM System Environment do you want to remove the isolated set of"
echo " Containers & VMs and xBR0 bridges?"
echo
echo


LIST=$'LXD\nIncus\nQuit'

IFS=$'\n'
select item in $LIST; do
    case "$item" in
        LXD) echo "1";;
        Incus) echo "2";;
        *) break;;
    esac
done

if $item="Quit"


lxc delete cn1 --force
lxc delete cn2 --force
lxc delete cn3 --force

#====================================================================
# Delete 3 LXD containers created by "isolate-on.sh"
#

lxc delete vm1 --force
lxc delete vm2 --force
lxc delete vm3 --force

#====================================================================
# Delete the 3 LXD bridges created by "isolate-on.sh"

lxc network delete lxdbr1
lxc network delete lxdbr2
lxc network delete lxdbr3

