#!/bin/sh
# This shell script sets up FreeBSD's sysctl.conf kernel variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this script as root! Thanks."
exit
fi

echo ######################### >> /etc/sysctl.conf
echo kern.elf32.aslr.enable=1 >> /etc/sysctl.conf
echo kern.elf32.aslr.honor_sbrk=0 >> /etc/sysctl.conf
echo kern.elf64.aslr.enable=1 >> /etc/sysctl.conf
echo kern.elf64.aslr.honor_sbrk=0 >> /etc/sysctl.conf
echo kern.sched.preempt_thresh=224 >> /etc/sysctl.conf
echo kern.vt.enable_bell=0 >> /etc/sysctl.conf
echo vfs.usermount=1 >> /etc/sysctl.conf
echo vfs.read_max=128 >> /etc/sysctl.conf
echo kern.coredump=0 >> /etc/sysctl.conf
echo kern.shutdown.poweroff_delay=2000 >> /etc/sysctl.conf
echo kern.shutdown.kproc_shutdown_wait=20 >> /etc/sysctl.conf
echo net.inet.ip.maxfragpackets=0 >> /etc/sysctl.conf
echo net.inet.ip.maxfragsperpacket=0 >> /etc/sysctl.conf
echo net.local.stream.recvspace=65536 >> /etc/sysctl.conf
echo net.local.stream.sendspace=65536 >> /etc/sysctl.conf
echo net.inet.tcp.blackhole=2 >> /etc/sysctl.conf
echo net.inet.udp.blackhole=1 >> /etc/sysctl.conf
echo net.inet.ip.random_id=1 >> /etc/sysctl.conf
echo net.inet.tcp.always_keepalive=0 >> /etc/sysctl.conf
echo net.inet.tcp.drop_synfin=1 >> /etc/sysctl.conf
echo net.inet.tcp.fast_finwait2_recycle=1 >> /etc/sysctl.conf
echo net.inet.tcp.icmp_may_rst=0 >> /etc/sysctl.conf
echo net.inet.ip.redirect=0 >> /etc/sysctl.conf
echo net.inet.tcp.syncache.rexmtlimit=0 >> /etc/sysctl.conf
echo net.inet.tcp.syncookies=0 >> /etc/sysctl.conf
echo net.inet.tcp.cc.algorithm=cubic >> /etc/sysctl.conf
echo hw.acpi.power_button_state=S3 >> /etc/sysctl.conf
echo hw.kbd.keymap_restrict_change=4 >> /etc/sysctl.conf
echo net.inet.ip.check_interface=1 >> /etc/sysctl.conf
echo net.inet.ip.process_options=0 >> /etc/sysctl.conf
echo net.inet.tcp.drop_synfin=1 >> /etc/sysctl.conf
echo net.inet.tcp.icmp_may_rst=0 >> /etc/sysctl.conf
echo net.inet.tcp.nolocaltimewait=1 >> /etc/sysctl.conf
echo net.inet.tcp.path_mtu_discovery=0 >> /etc/sysctl.conf
echo net.inet6.icmp6.rediraccept=0 >> /etc/sysctl.conf
echo net.inet6.ip6.redirect=0 >> /etc/sysctl.conf
echo security.bsd.hardlink_check_gid=1 >> /etc/sysctl.conf
echo security.bsd.hardlink_check_uid=1 >> /etc/sysctl.conf
echo kern.metadelay=2 >> /etc/sysctl.conf
echo kern.dirdelay=3 >> /etc/sysctl.conf
echo kern.filedelay=5 >> /etc/sysctl.conf
echo kern.cam.scsi_delay=2000 >> /etc/sysctl.conf
echo kern.ipc.shmmax=1000000000 >> /etc/sysctl.conf
echo kern.ipc.shm_use_phys=1 >> /etc/sysctl.conf
echo kern.ipc.shm_allow_removed=1 >> /etc/sysctl.conf
echo kern.ipc.shmall=256000 >> /etc/sysctl.conf
echo hw.snd.default_auto=0 >> /etc/sysctl.conf
echo hw.snd.vpc_0db=1 >> /etc/sysctl.conf
echo hw.snd.latency=5 >> /etc/sysctl.conf
echo hw.snd.feeder_rate_quality=4 >> /etc/sysctl.conf
echo machdep.syscall_ret_flush_l1d=1 >> /etc/sysctl.conf
echo hw.spec_store_bypass_disable=2 >> /etc/sysctl.conf
echo hw.mds_disable=3 >> /etc/sysctl.conf
echo hw.ibrs_disable=0 >> /etc/sysctl.conf
echo kern.sched.slice=3 >> /etc/sysctl.conf
echo "" >> /etc/sysctl.conf
echo "### VirtualBox stuff ###" >> /etc/sysctl.conf
echo vfs.aio.max_buf_aio=8192 >> /etc/sysctl.conf
echo vfs.aio.max_aio_queue_per_proc=65536 >> /etc/sysctl.conf
echo vfs.aio.max_aio_per_proc=8192 >> /etc/sysctl.conf
echo vfs.aio.max_aio_queue=65536 >> /etc/sysctl.conf
