#!/system/bin/sh

sleep 65 # do the configuration again to override ROM and hardcoded tegra governor

# run EliteKernel tweaks (overrides ROM tweaks)
echo "sio" > /sys/block/mmcblk0/queue/scheduler
echo "sio" > /sys/block/mmcblk1/queue/scheduler

# set and lock governors
echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

# set default speeds
echo "1400000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "1600000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo "1600000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo "1400000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq

echo "204000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "51000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo "51000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo "102000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

# set governor prefs and lock
echo "15" > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
echo "3000000" > /sys/devices/system/cpu/cpufreq/ondemand/input_boost_duration
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
echo "3" > /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias
echo "2" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
echo "30000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
echo "10000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_min
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/touch_poke
echo "204000" > /sys/devices/system/cpu/cpufreq/ondemand/two_phase_bottom_freq
echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/two_phase_dynamic
echo "760000" > /sys/devices/system/cpu/cpufreq/ondemand/two_phase_freq
echo "4" > /sys/devices/system/cpu/cpufreq/ondemand/ui_counter
echo "15000" > /sys/devices/system/cpu/cpufreq/ondemand/ui_sampling_rate
echo "85" > /sys/devices/system/cpu/cpufreq/ondemand/ui_threshold
echo "85" > /sys/devices/system/cpu/cpufreq/ondemand/ux_boost_threshold
echo "910000" > /sys/devices/system/cpu/cpufreq/ondemand/ux_freq
echo "8" > /sys/devices/system/cpu/cpufreq/ondemand/ux_loading

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

touch /data/local/em_delayed_tweaks


