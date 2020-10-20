#!/bin/bash

source `dirname $0`/utils.sh

check_root

mkdir -p ${BASEDIR}/rootfs
mkdir -p ${BASEDIR}/cdroot
${BASEDIR}/scripts/download-stage3.sh ${BASEDIR} || exit 1
cd ${BASEDIR}/rootfs || exit 1
tar xpvf ${BASEDIR}/stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner || exit 1
cd ${BASEDIR}

cp ${BASEDIR}/scripts/build-image.sh ${BASEDIR}/rootfs/tmp/ || exit 1
if [ "$MIRROR" == "" ]; then
    MIRROR="https://bouncer.gentoo.org/fetch/root/all/"
fi
cp ${BASEDIR}/conf/package.license ${BASEDIR}/rootfs/etc/portage/ || exit 1
mkdir -p ${BASEDIR}/rootfs/etc/portage/repos.conf
cp ${BASEDIR}/rootfs/usr/share/portage/config/repos.conf ${BASEDIR}/rootfs/etc/portage/repos.conf/gentoo.conf || exit 1
cp --dereference /etc/resolv.conf ${BASEDIR}/rootfs/etc/ || exit 1
cp ${BASEDIR}/conf/50-dhcp.network ${BASEDIR}/rootfs/tmp/ || exit 1
cp ${BASEDIR}/conf/squashfs.conf ${BASEDIR}/rootfs/tmp/ || exit 1
cp -r ${BASEDIR}/conf/user ${BASEDIR}/rootfs/tmp/user || exit 1
cp ${BASEDIR}/assets/background.png ${BASEDIR}/rootfs/tmp/ || exit 1

${BASEDIR}/scripts/prepare-chroot.sh || exit 1
chroot ${BASEDIR}/rootfs /tmp/build-image.sh "$MIRROR"
RET=$?
${BASEDIR}/scripts/cleanup-chroot.sh || exit 1
[ "$RET" == 0 ] || exit 1
