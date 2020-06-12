#!/bin/bash

MACH=ls3a7a
QVER=loongson-v1.0
# Based on v3.10
KVER=loongnix-release-1903
RVER=2016.05
# Minimal memory for boot is 256M, but with graphic, 1024M is required
MEM=1024M


# Kernel and dtb
DTB=kernel/$KVER/loongson3_ls7a.dtb
KERNEL=kernel/$KVER/vmlinuz
# Rootfs
INITRD=root/$RVER/rootfs.cpio.gz
# Qemu environments
XENVS=INITRD_OFFSET=0x04000000

# Usb input devices
USB="-device usb-mouse -device usb-kbd -show-cursor"

# maxcpus=1 must be passed to not hang at booting
# Booting CPU#1...
# [    0.150000] CPU#1, func_pc=ffffffff80da1c7c, sp=980000000c0f3eb0, gp=980000000c0f0000
# [    0.256000] random: fast init done

# Graphic boot or not, 1 for graphic, 0 for serial

G=0
if [ $G -eq 1 ]; then
  CONSOLE=tty0
  GOPT=
else
  GOPT=-nographic
  CONSOLE=ttyS0
fi

env $XENVS ./qemu/$QVER/bin/qemu-system-mips64el -M $MACH -m $MEM -smp 1 -no-reboot $GOPT \
	-kernel $KERNEL \
	-initrd $INITRD \
	-dtb $DTB \
	$USB \
	-append "route=172.17.0.5 root=/dev/ram0 console=$CONSOLE maxcpus=1"
	#-net nic,model=synopgmac -net tap
