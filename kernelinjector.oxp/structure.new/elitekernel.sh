#!/system/bin/sh

# EliteKernel: deploy modules and misc files
sync
touch /data/local/em_modules_deployed
mount -o remount,rw /system
sync
rm -f /system/lib/modules/*
cp -fR /modules/*  /system/lib/modules
sync
chmod -R 0644 system/lib/modules
chown 0:0 /system/lib/modules/bcmdhd.ko
chown 0:0 /system/lib/modules/baseband_xmm_power2.ko
chown 0:0 /system/lib/modules/raw_ip_net.ko
chown 0:0 /system/lib/modules/baseband_usb_chr.ko
chown 0:0 /system/lib/modules/cdc_acm.ko
insmod /system/lib/modules/bcmdhd.ko
insmod /system/lib/modules/baseband_xmm_power2.ko
insmod /system/lib/modules/raw_ip_net.ko
insmod /system/lib/modules/baseband_usb_chr.ko
insmod /system/lib/modules/cdc_acm.ko
sync
mount -o remount,ro /system

# run EliteKernel tweaks (overrides ROM tweaks)
echo "sio" > /sys/block/mmcblk0/queue/scheduler
echo "sio" > /sys/block/mmcblk1/queue/scheduler

# need to enable all CPU cores in order to set them up
echo 4 > /sys/power/pnpmgr/hotplug/min_on_cpus

# set governors
echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

# set default speeds (cpus activate in order 0-3-2-1)
echo "1300000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "1600000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo "1500000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo "1400000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq

echo "51000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "51000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo "51000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo "51000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

sync
# reset core activation to default
echo 0 > /sys/power/pnpmgr/hotplug/min_on_cpus

# set ondemand prefs
echo "15" > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
echo "3000000" > /sys/devices/system/cpu/cpufreq/ondemand/input_boost_duration
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
echo "5" > /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
echo "5" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
echo "30000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
echo "10000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_min
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/touch_poke
echo "51000" > /sys/devices/system/cpu/cpufreq/ondemand/two_phase_bottom_freq
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/two_phase_dynamic
echo "340000" > /sys/devices/system/cpu/cpufreq/ondemand/two_phase_freq
echo "3" > /sys/devices/system/cpu/cpufreq/ondemand/ui_counter
echo "20000" > /sys/devices/system/cpu/cpufreq/ondemand/ui_sampling_rate
echo "40" > /sys/devices/system/cpu/cpufreq/ondemand/ui_threshold
echo "66" > /sys/devices/system/cpu/cpufreq/ondemand/ux_boost_threshold
echo "760000" > /sys/devices/system/cpu/cpufreq/ondemand/ux_freq
echo "20" > /sys/devices/system/cpu/cpufreq/ondemand/ux_loading

# set vm tweaks
sysctl -w vm.min_free_kbytes=5242
sysctl -w vm.vfs_cache_pressure=30
sysctl -w vm.swappiness=40
sysctl -w vm.page-cluster=0
sysctl -w vm.dirty_expire_centisecs=2400
sysctl -w vm.dirty_writeback_centisecs=600
sysctl -w vm.dirty_ratio=20
sysctl -w vm.dirty_background_ratio=30
sysctl -w vm.oom_kill_allocating_task=0
sysctl -w vm.panic_on_oom=0
sysctl -w vm.overcommit_memory=0
sysctl -w vm.overcommit_ratio=20
sysctl -w kernel.panic_on_oops=1
sysctl -w kernel.panic=10

# minfree
echo "0,1,2,5,7,15" > /sys/module/lowmemorykiller/parameters/adj
echo "1536,3072,6144,11264,16384,20480" > /sys/module/lowmemorykiller/parameters/minfree


#I/O tweaks
mount -o async,remount,noatime,nodiratime,delalloc,noauto_da_alloc,barrier=0,nobh /cache /cache
mount -o async,remount,noatime,nodiratime,delalloc,noauto_da_alloc,barrier=0,nobh /data /data
mount -o async,remount,noatime,nodiratime,delalloc,noauto_da_alloc,barrier=0,nobh /sd-ext /sd-ext
mount -o async,remount,noatime,nodiratime,delalloc,noauto_da_alloc,barrier=0,nobh /devlog /devlog
echo "2048" > /sys/block/mmcblk0/bdi/read_ahead_kb;
echo "2048" > /sys/block/mmcblk0/queue/read_ahead_kb;

# activate delayed config to override ROM
/system/xbin/busybox nohup /system/bin/sh /elitekernel_delayed.sh 2>&1 >/dev/null &



