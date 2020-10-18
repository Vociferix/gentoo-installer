#!/bin/bash

if [ "$MIRROR" == "" ]; then
    MIRROR=https://bouncer.gentoo.org/fetch/root/all/
fi

TARBALL=`wget -O - ${MIRROR}/releases/amd64/autobuilds/current-stage3-amd64-systemd/ 2>/dev/null | grep -o ">stage3-amd64-systemd-.*.tar.xz<" | cut -c2- | rev | cut -c2- | rev`

if [ "${TARBALL}" == "" ]; then
    echo "Failed to query latest stage 3 tarball"
    exit 1
fi

OUTDIR="."
if [ "$1" != "" ]; then
    OUTDIR="$1"
fi

if [ -e ${OUTDIR}/${TARBALL} ]; then
    echo "Stage 3 tarball up to date"
else
    rm -f ${OUTDIR}/stage3-amd64-systemd-*.tar.xz
    if wget -O ${OUTDIR}/${TARBALL} ${MIRROR}/releases/amd64/autobuilds/current-stage3-amd64-systemd/${TARBALL}; then
        echo "Downloaded ${TARBALL} successfully"
    else
        echo "Failed to download ${TARBALL}!"
	echo "Calculated URL was: ${MIRROR}/releases/amd64/autobuilds/current-stage3-amd64-systemd/${TARBALL}"
	exit 1
    fi
fi
