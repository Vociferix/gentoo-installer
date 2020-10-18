#!/bin/bash

source `dirname $0`/utils.sh

check_root

${BASEDIR}/scripts/prepare-chroot.sh

echo "source /etc/profile" > ${BASEDIR}/rootfs/root/.chroot_bashrc
echo "export PS1=\"(chroot) \$PS1\"" >> ${BASEDIR}/rootfs/root/.chroot_bashrc
chroot ${BASEDIR}/rootfs /bin/bash --init-file /root/.chroot_bashrc
rm ${BASEDIR}/rootfs/root/.chroot_bashrc

${BASEDIR}/scripts/cleanup-chroot.sh
