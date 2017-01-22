#!/system/bin/sh

############################
echo "Boot Script Started" | tee /dev/kmsg

# Other
echo 250 > /sys/class/kgsl/kgsl-3d0/wake_timeout
echo "0" /dev/cpuctl/cpu.notify_on_migrate;

#PowerHAL
mv /system/vendor/lib/hw/power.msm8226.so /system/vendor/lib/hw/power.msm8226.bak

# Arch_power
echo "ARCH_POWER" > /sys/kernel/debug/sched_features
echo "1" > /sys/kernel/sched/arch_power

# Hotplugging & Govs
stop mpdecision
echo 1 > /sys/module/autosmp/parameters/enabled
echo 0 > /sys/devices/system/cpu/cpuquiet/cpuquiet_driver/enabled

# Power Suspend
echo "3" > /sys/kernel/power_suspend/power_suspend_mode
echo "0" > /sys/kernel/power_suspend/power_suspend_state

# Scheduler and Read Ahead
echo 1 > /sys/block/mmcblk0/queue/nomerges
echo 2 > /sys/block/mmcblk0/queue/rq_affinity
echo 0 > /sys/block/mmcblk0/queue/add_random

# Disable debugging
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/kernel/parameters/initcall_debug
echo "0" > /sys/module/alarm/parameters/debug_mask
echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask
echo "0" > /sys/module/alarm_dev/parameters/debug_mask


echo "Post-Boot Script Completed!" | tee /dev/kmsg
