#!/bin/busybox ash
/bin/busybox --install -s
sleep 2
echo Mounting SD root
mkdir -p /dos
mount -t msdos /dev/mmcblk0p1 /dos || (echo Mount msdos failed, dropping to ash; /bin/ash)
mount -t ext4 -o loop /dos/lowrisc.img /mnt || (echo Mount rootfs failed, dropping to ash; /bin/ash)
echo Mounting proc
mkdir -p /mnt/proc
mount -t proc none /mnt/proc
echo Mounting sysfs
mkdir -p /mnt/sys
mount -t sysfs none /mnt/sys
echo Mounting devtmpfs
mkdir -p /mnt/dev
mount -t devtmpfs udev /mnt/dev
mkdir -p /mnt/dev/pts
echo Mounting devpts
mount -t devpts devpts /mnt/dev/pts
echo Mounting tmpfs
mkdir -p /mnt/tmp
mount -t tmpfs tmpfs /mnt/tmp
mkdir -p /mnt/run
mount -t tmpfs tmpfs /mnt/run
mv /bin/busybox /mnt/bin
echo Executing switch_root
exec switch_root /mnt /sbin/init
