#!/system/bin/sh

sleep 45 # do the configuration again to override ROM hardcoded stuff

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

touch /data/local/em_delayed_tweaks


