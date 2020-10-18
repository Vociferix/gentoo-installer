#!/bin/sh

source `dirname $0`/utils.sh

check_root

rm -f ${BASEDIR}/gentoo-installer.iso
mkdir -p ${BASEDIR}/cdroot

rm -f ${BASEDIR}/cdroot/LiveOS/squashfs.img
mkdir -p ${BASEDIR}/cdroot/LiveOS
rm -rf ${BASEDIR}/rootfs/tmp/*
rm -rf ${BASEDIR}/rootfs/run/*
mksquashfs ${BASEDIR}/rootfs ${BASEDIR}/cdroot/LiveOS/squashfs.img || exit 1

touch ${BASEDIR}/cdroot/livecd

mkdir -p ${BASEDIR}/cdroot/isolinux
cp /usr/share/syslinux/isolinux.bin ${BASEDIR}/cdroot/isolinux/
cp /usr/share/syslinux/hdt.c32 ${BASEDIR}/cdroot/isolinux/
cp /usr/share/syslinux/ldlinux.c32 ${BASEDIR}/cdroot/isolinux/
cp /usr/share/syslinux/libcom32.c32 ${BASEDIR}/cdroot/isolinux/
cp /usr/share/syslinux/libutil.c32 ${BASEDIR}/cdroot/isolinux/
cp /usr/share/syslinux/reboot.c32 ${BASEDIR}/cdroot/isolinux/
cp /usr/share/syslinux/vesamenu.c32 ${BASEDIR}/cdroot/isolinux/
cp ${BASEDIR}/conf/isolinux.cfg ${BASEDIR}/cdroot/isolinux/isolinux.cfg

mkdir -p ${BASEDIR}/cdroot/boot/grub
cp ${BASEDIR}/conf/grub.cfg ${BASEDIR}/cdroot/boot/grub/

mv ${BASEDIR}/cdroot/vmlinuz-* ${BASEDIR}/cdroot/kernel
mv ${BASEDIR}/cdroot/initramfs-* ${BASEDIR}/cdroot/initramfs
mv ${BASEDIR}/cdroot/config-* ${BASEDIR}/cdroot/kernel-config
mv ${BASEDIR}/cdroot/System.map-* ${BASEDIR}/cdroot/System.map

grub-mkrescue \
	-o ${BASEDIR}/gentoo-installer.iso \
	${BASEDIR}/cdroot/ \
	-- \
	-as mkisofs \
	-R \
	-r \
	-V "Gentoo-Live-CD" \
	-J \
	-l \
	-joliet-long \
	-boot-info-table \
	-o ${BASEDIR}/gentoo-installer.iso \
	-b isolinux/isolinux.bin \
	-c boot.cat \
	-no-emul-boot \
	-boot-load-size 4 || exit 1
