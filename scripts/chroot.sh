#!/bin/bash

source `dirname $0`/utils.sh
source /etc/portage/make.conf

check_root

${BASEDIR}/scripts/prepare-chroot.sh

NPROC=`nproc`

echo "source /etc/profile" > ${BASEDIR}/rootfs/root/.chroot_bashrc
echo "export PS1=\"(chroot) \$PS1\"" >> ${BASEDIR}/rootfs/root/.chroot_bashrc
echo "export MAKEOPTS=\"-j$(($(nproc)+1)) -l$(nproc)\"" >> ${BASEDIR}/rootfs/root/.chroot_bashrc
echo "export EMERGE_DEFAULT_OPTS=\"--jobs=$(nproc) --load-average=$(nproc)\"" >> ${BASEDIR}/rootfs/root/.chroot_bashrc
rm ${BASEDIR}/rootfs/etc/resolv.conf
cp --dereference /etc/resolv.conf ${BASEDIR}/rootfs/etc/
chroot ${BASEDIR}/rootfs /bin/bash --init-file /root/.chroot_bashrc
rm ${BASEDIR}/rootfs/root/.chroot_bashrc
rm ${BASEDIR}/rootfs/etc/resolv.conf
ln -snf /run/systemd/resolve/resolv.conf ${BASEDIR}/rootfs/etc/resolv.conf

${BASEDIR}/scripts/cleanup-chroot.sh
