#!/bin/sh
# This shell script sets up FreeBSD's sysctl.conf kernel variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
    echo "Please run this script as root! Thanks."
    exit
fi

cat << EOF >> /etc/sysctl.conf
#########################

# Enable users to mount drives.
vfs.usermount=1

# Improve read/write permormance.
vfs.read_max=128
vfs.lorunningspace=1048576
vfs.hirunningspace=5242880

# Disable creating *.core files in home directory.
kern.coredump=0

# Speed up shutdown.
kern.shutdown.poweroff_delay=2000
kern.shutdown.kproc_shutdown_wait=20

# Security enhancements.
hw.kbd.keymap_restrict_change=4
kern.randompid=1
kern.sugid_coredump=0
security.bsd.hardlink_check_gid=1
security.bsd.hardlink_check_uid=1
security.bsd.stack_guard_page=1
machdep.syscall_ret_flush_l1d=1
hw.spec_store_bypass_disable=2
hw.mds_disable=3
hw.ibrs_disable=0

# Network security enhancements.
net.inet.udp.blackhole=1
net.inet.tcp.blackhole=2
net.inet.icmp.drop_redirect=1
net.inet.ip.process_options=0
net.inet.ip.random_id=1
net.inet.ip.redirect=0
net.inet.ip.accept_sourceroute=0
net.inet.ip.forwarding=0
net.inet.ip.sourceroute=0
net.inet.tcp.always_keepalive=0
net.inet.tcp.drop_synfin=1
net.inet.tcp.icmp_may_rst=0
net.inet.tcp.nolocaltimewait=1
net.inet.tcp.path_mtu_discovery=0
net.inet.icmp.bmcastecho=0
net.inet6.icmp6.rediraccept=0
net.inet6.ip6.redirect=0
net.inet.ip.maxfragpackets=0
net.inet.ip.maxfragsperpacket=0
net.local.stream.recvspace=65536
net.local.stream.sendspace=65536
net.inet.tcp.fast_finwait2_recycle=1
net.inet.tcp.syncache.rexmtlimit=0
net.inet.tcp.syncookies=0
net.inet.tcp.cc.algorithm=cubic

# Desktop tweaks.
kern.sched.preempt_thresh=224
hw.acpi.power_button_state=S3
kern.metadelay=2
kern.dirdelay=3
kern.filedelay=5
kern.cam.scsi_delay=2000
kern.ipc.shmmax=1000000000
kern.ipc.shm_use_phys=1
kern.ipc.shm_allow_removed=1
kern.ipc.shmall=256000
hw.snd.vpc_0db=1
hw.snd.latency=5
hw.snd.feeder_rate_quality=4
kern.sched.slice=3
kern.maxfiles=100000
kern.geom.part.mbr.enforce_chs=0

# Fix stuttering issue on AMD CPUs.
kern.sched.steal_thresh=1
EOF
