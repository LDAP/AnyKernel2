# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=LOS+ Kernel by LDAP98 @ xda-developers
do.devicecheck=0
do.initd=0
do.modules=0
do.disable=1
do.cleanup=1
device.name1=
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
# backup_file init.qcom.rc;
replace_line init.qcom.rc "    start mpdecision" "    stop mpdecision";
append_file init.qcom.rc "post_boot_script" init.qcom.patch;

# Selinux

cmdtmp=`cat $split_img/*-cmdline`;
case "$cmdtmp" in
     *selinux=permissive*) ui_print " "; ui_print "SElinux Its Already Permissive..."; ;;
     *) ui_print " "; ui_print "Setting SElinux To Permissive..."; echo "$cmdtmp androidboot.selinux=permissive" > $split_img/*-cmdline ;;
esac;

# end ramdisk changes

write_boot;

## end install

