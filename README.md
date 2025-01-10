
## Create or Delete "Isolated" Sets of Incus/LXD Containers/VMs & respective Bridges  

Two Bash Scripts to *Create* (**isolate-on\.sh**) and/or *Cleanup* (**isolate-off\.sh)**
three isolated Incus or LXD Network bridges and their respective Incus/LXD Network Isolated
Incus/LXD Containers and VM

Three pairs of"isolated" Container/VM are used CN1/VM1, CN2/VM2 and CN3/VM3)

***Sample use-case:***
There are probably a lot of examples but one might be that you may want to test something
like a VPN between servers on multiple Clouds but don't want to pay for multiple Cloud Servers Instances.
 You could use these scripts to simulate isolated Cloud servers.

 ***Sample use-case:***
 Implement a Mult-Tenant architectue where each "Tenant" is allocated separate isolated Incus/LXD Bridges and
 the Containers/VMs created behind them and each Tenant is prevented from accessing another Tenant's Container
 or VM "services.

*Here are 2 simple Bash scripts creating 3 Incus/LXD bridges, Containers and VMs.*

> **isolate-on\.sh**   
> **isolate-off\.sh**

---

### isolate-on\.sh

***Purpose:***
- Create 3 new Incus/LXD Bridges (incusbr1/lxdbr1, incusbr2/lxdbr2, incusbr3/lxdbr3)
- Create 3 sets of "Isolated" (from each other)  Incus/LXD  Containers and VMs, each attached to a corresponding Bridge

***Assignments are***

| Container/VM     | Bridge   |
| :--------------- | --------:|
| incus-cn1        | incusbr1 |
| incus-cn2        | incusbr2 |
| incus-cn3        | incusbr3 |
| incus-vm1       | incusbr1 |
| incus-vm2       | incusbr2 |
| incus-vm3       | incusbr3 |

**and/or**

| Container/VM   | Bridge |
| :------------- | ------:|
| lxd-cn1        | lxdbr1 |
| lxd-cn2        | lxdbr2 |
| lxd-cn3        | lxdbr3 |
| lxd-vm1        | lxdbr1 |
| lxd-vm2        | lxdbr2 |
| lxd-vm3        | lxdbr3 |

After executing ***isolate-on\.sh*** each of those 3 Incus or LXD Containers/VM will be network isolated from each other
but not from the Host, the Internet or their "counterpart".

### Example:   

CN1 and VM1 will get IPv4 addresses on the same subnet so they can communicate with the Internet/Host
and each other.

The same happens for CN2/VM2 and CN3/VM3.

But
CN1 CN2 and CN3 can't talk to each other
and
VM1 VM2 and VM3 can't talk to each other

---

### isolate-off\.sh  

***Purpose:***
* Delete the 3 isolated Incus/LXD Containers and VMs
* Delete the Incus/LXD Network Bridges

After executing ***isolate-off\.sh*** Incus/LXD will clean-up/remove the respective Containers and VMs and
remove the Incus/LXD Network Bridges





