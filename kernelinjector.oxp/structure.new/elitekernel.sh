#!/system/bin/sh

# EliteKernel: deploy modules and misc files
sync
touch /data/local/em_modules_deployed
mount -o remount,rw /system
sync
cp -fR /modules/*  /system/lib/modules
sync
mount -o remount,ro /system

insmod /system/lib/modules/bcmdhd.ko


