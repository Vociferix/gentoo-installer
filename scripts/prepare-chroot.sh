#!/bin/bash

source `dirname $0`/utils.sh

check_root

mount --types proc /proc ${BASEDIR}/rootfs/proc || exit 1
mount --rbind /sys ${BASEDIR}/rootfs/sys || exit 1
mount --make-rslave ${BASEDIR}/rootfs/sys || exit 1
mount --rbind /dev ${BASEDIR}/rootfs/dev || exit 1
mount --make-rslave ${BASEDIR}/rootfs/dev || exit 1
mount --rbind ${BASEDIR}/cdroot ${BASEDIR}/rootfs/boot || exit 1
mount --make-rslave ${BASEDIR}/rootfs/boot || exit 1

