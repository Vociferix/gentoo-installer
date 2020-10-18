#!/bin/bash

source `dirname $0`/scripts/utils.sh

check_root

mkdir -p ${BASEDIR}/cdroot

if [ ! -e ${BASEDIR}/rootfs ]; then
    ${BASEDIR}/scripts/build-rootfs.sh
fi

${BASEDIR}/scripts/prepare-chroot.sh || exit 1
cp ${BASEDIR}/scripts/clean-rootfs.sh ${BASEDIR}/rootfs/tmp/
chroot ${BASEDIR}/rootfs /tmp/clean-rootfs.sh
RET=$?
${BASEDIR}/scripts/cleanup-chroot.sh || exit 1
[ "$RET" == 0 ] || exit 1

${BASEDIR}/scripts/mkiso.sh

