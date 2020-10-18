#!/bin/bash

if [ "${BASEDIR}" == "" ]; then
    BASEDIR=$(dirname $(realpath $0))
    if [[ "${BASEDIR}" =~ ^.*/scripts$ ]]; then
        BASEDIR=$(dirname $BASEDIR)
    fi
fi

check_root () {
    if [ "${EUID}" != 0 ]; then
        echo "Please run as root."
	exit 1
    fi
}
