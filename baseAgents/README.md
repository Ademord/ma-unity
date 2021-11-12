# How to setup a VM 

# setup X everywhere

```
sudo apt install -y ubuntu-desktop xrdp \
&& sudo adduser xrdp ssl-cert \
&& systemctl status xrdp \
&& nvidia-smi \
&& sudo reboot

sudo passwd ubuntu
W123!
sudo nvidia-xconfig \
&& sudo reboot

login with romina
sudo apt-get install mesa-utils
```

# setup Volume in server
```
lsblk
# setup new volume
sudo fdisk /dev/vdb
# make a partition steps: g, n, > (enter), >, >, w
# format the partition DEPRECATED sudo mkfs.xfs /dev/vdb1
sudo mkfs -t ext4 /dev/vdb1

sudo su
# make /mnt folder
mkdir /mnt
chown ubuntu:ubuntu /mnt
# mount the volume at /mnt
mount /dev/vdb1 /mnt
# sync your ubuntu folder at /mnt (all .ssh keys and configurations)
rsync -av /home/ubuntu/ /mnt
# test that it is mounted and copied 
# unmount the volume from /mnt
umount /mnt
# mount what is specificed in the recently modified file /etc/fstab
mount -a

# get UUID
sudo blkid /dev/vdb1 # UUID="2a65e549-8e7c-4cd2-8a83-4699eee83360"
# edit mount points on start
sudo nano /etc/fstab
UUID=YOUR_UUID /home/ubuntu/ ext4 defaults 0 0

```

# setup NFS in server
```
# on server
sudo -i 
apt install -y nfs-kernel-server
# default cloud.cfg install (N)
nano /etc/exports
# add the following line
# MOUNT_PATH CLIENT_IP(rw,sync,no_subtree_check,no_root_squash)
# example: /home/ubuntu/ 10.0.2.57(rw,sync,no_subtree_check,no_root_squash)
/home/ubuntu/ 10.0.1.204(rw,sync,no_subtree_check,no_root_squash)

exportfs -r #making the file share available
systemctl restart nfs-kernel-server #restarting the NFS kernel
```
# setup NFS in clients
```
# direct client commands
sudo -i
apt install -y nfs-common
# as test: mount -t nfs 10.0.1.7:/home/ubuntu /home/ubuntu
echo "10.0.1.7:/home/ubuntu /home/ubuntu   nfs  defaults,_netdev  0 0" >> /etc/fstab
mount -a
ls /home/ubuntu
```
# setup python and libraries
1. `sudo apt install -y python3-pip && pip install mlagents torch tensorflow cattrs==1.0.0`
2. `echo "export PATH=\"`python3 -m site --user-base`/bin:\$PATH\"" >> ~/.bashrc`
3. romina into this machine
4. start a terminal

# some errors
- xlrdp permission, fixed with adding it to group
- segmentation fault >> the executable of the game MUST BE started in a terminal from romina and CANNOT be a screen. set as background Process with `&`.

# debug helpers
- `ps aux | grep "config/run"`
# training log

## u1
- ✅ `run65`
- ✅ `run65-pure`
## u2
- ✅ `run66`
- ✅ `run67`
## u3
- ✅ `run68`
- ✅ `run68++050`
## u4
- ✅ `run68++100`
- ✅ `run61`
## u5
- ✅ `run62`
- ✅ `run63`
## u6
- ✅ `run63++025`
- ✅ `run63++050`
## u7
- ✅ `run63++075`
- ✅ `run63++100`
## u8
5. `run64`

## configLoader_v2 
- ✅ - fixes Object detector error =0 >> NOT FIXED!!!
- ✅ - fixes config loading in play-mode without config
- ✅ - fixes obs space
- ✅ - adds obs for inside or outside of allowed space `m_OutsideAllowed`
- ✅ - fixed look error
- ✅ - fixed moving forward to not be 0 or 1 (boolean) but instead a rounded value every 0.1 so that the plot becomes a bit more interpretable.
