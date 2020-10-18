#!/bin/bash

source `dirname $0`/utils.sh

check_root

rm -rf ${BASEDIR}/cdroot
rm -rf ${BASEDIR}/rootfs
