# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=CM+ Kernel by LDAP98 @ xda-developers
do.devicecheck=0
do.initd=0
do.modules=0
do.cleanup=1
device.name1=titan
device.name2=
device.name3=
device.name4=
device.name5=

# shell variables
block=/dev/block/platform/msm_sdcc.1/by-name/boot;
initd=/system/etc/init.d;
bindir=/system/bin;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk
chmod 644 $ramdisk/sbin/post_boot_script.sh


## AnyKernel install
dump_boot;

# begin ramdisk changes
ui_print " "; ui_print "Tweaking ramdisk...";

# init.qcom.rc
backup_file init.qcom.rc;
replace_line init.qcom.rc "    start mpdecision" "    stop mpdecision";
append_file init.qcom.rc "post_boot_script" init.qcom.patch;


# add frandom compatibility
backup_file ueventd.rc;
insert_line ueventd.rc "frandom" after "urandom" "/dev/frandom              0666   root       root\n";
insert_line ueventd.rc "erandom" after "urandom" "/dev/erandom              0666   root       root\n";

backup_file file_contexts;
insert_line file_contexts "frandom" after "urandom" "/dev/frandom				u:object_r:frandom_device:s0\n";
insert_line file_contexts "erandom" after "urandom" "/dev/erandom				u:object_r:erandom_device:s0\n";

# xPrivacy
# Thanks to @Shadowghoster & @@laufersteppenwolf
param=$(grep "xprivacy" service_contexts)
if [ -z $param ]; then
    echo -ne "xprivacy453                               u:object_r:system_server_service:s0\n" >> service_contexts
fi

# Selinux
mount -o remount,ro /system;

cmdtmp=`cat $split_img/*-cmdline`;
case "$cmdtmp" in
     *selinux=permissive*) ui_print " "; ui_print "SElinux Its Already Permissive..."; ;;
     *) ui_print " "; ui_print "Setting SElinux To Permissive..."; echo "$cmdtmp androidboot.selinux=permissive" > $split_img/*-cmdline ;;
esac;

# end ramdisk changes

write_boot;

## end install

