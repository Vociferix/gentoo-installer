#!/bin/bash

source `dirname $0`/utils.sh

check_root

umount -l ${BASEDIR}/rootfs/dev{/shm,/pts,} || exit 1
umount -R ${BASEDIR}/rootfs/sys || exit 1
umount -R ${BASEDIR}/rootfs/boot || exit 1
umount -R ${BASEDIR}/rootfs/proc || exit 1

rm -rf ${BASEDIR}/rootfs/tmp/*
rm -rf ${BASEDIR}/rootfs/run/*
