#!/bin/sh
# This shell script sets up FreeBSD's sysctl.conf kernel variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this script as root! Thanks."
exit
fi

sysctl kern.elf32.aslr.enable=1
sysctl kern.elf32.aslr.honor_sbrk=0
sysctl kern.elf64.aslr.enable=1
sysctl kern.elf64.aslr.honor_sbrk=0
sysctl kern.sched.preempt_thresh=224
sysctl kern.vt.enable_bell=0
sysctl vfs.usermount=1
sysctl vfs.read_max=128
sysctl kern.coredump=0
sysctl kern.shutdown.poweroff_delay=2000
sysctl kern.shutdown.kproc_shutdown_wait=20
sysctl net.inet.ip.maxfragpackets=0
sysctl net.inet.ip.maxfragsperpacket=0
sysctl net.local.stream.recvspace=65536
sysctl net.local.stream.sendspace=65536
sysctl net.inet.tcp.blackhole=2
sysctl net.inet.udp.blackhole=1
sysctl net.inet.ip.random_id=1
sysctl net.inet.tcp.always_keepalive=0
sysctl net.inet.ip.redirect=0
sysctl net.inet.tcp.cc.algorithm=cubic
sysctl hw.acpi.power_button_state=S3
sysctl hw.kbd.keymap_restrict_change=4
sysctl net.inet.ip.check_interface=1
sysctl net.inet.ip.process_options=0
sysctl net.inet.tcp.drop_synfin=1
sysctl net.inet.tcp.icmp_may_rst=0
sysctl net.inet.tcp.nolocaltimewait=1
sysctl net.inet.tcp.path_mtu_discovery=0
sysctl net.inet6.icmp6.rediraccept=0
sysctl net.inet6.ip6.redirect=0
sysctl security.bsd.hardlink_check_gid=1
sysctl security.bsd.hardlink_check_uid=1
sysctl kern.metadelay=2
sysctl kern.dirdelay=3
sysctl kern.filedelay=5
sysctl kern.cam.scsi_delay=2000
sysctl kern.ipc.shmmax=1000000000
sysctl kern.ipc.shm_use_phys=1
sysctl kern.ipc.shmall=256000
sysctl hw.snd.default_auto=0
sysctl hw.snd.vpc_0db=1
sysctl hw.snd.latency=5
sysctl hw.snd.feeder_rate_quality=4
sysctl machdep.syscall_ret_flush_l1d=1
sysctl hw.spec_store_bypass_disable=1
sysctl hw.mds_disable=3
echo "" >> /etc/sysctl.conf
echo "### VirtualBox stuff ###" >> /etc/sysctl.conf
sysctl vfs.aio.max_buf_aio=8192
sysctl vfs.aio.max_aio_queue_per_proc=65536
sysctl vfs.aio.max_aio_per_proc=8192
sysctl vfs.aio.max_aio_queue=65536
