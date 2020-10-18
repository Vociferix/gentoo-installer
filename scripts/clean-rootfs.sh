#!/bin/bash

rm -rf \
    /root/.ccache/* \
    /tmp/* \
    /usr/portage/distfiles/* \
    /usr/src/* \
    /var/cache/* \
    /var/empty/* \
    /var/run/* \
    /var/state/* \
    /var/tmp/* \
    /etc/*- \
    /etc/*.old \
    /etc/ssh/ssh_host_* \
    /root/.*history \
    /root/.lesshst \
    /root/.ssh/known_hosts \
    /root/.viminfo \
    /usr/share/genkernel \
    /usr/lib64/python*/site-packages/gentoolkit/test/eclean/testdistfiles.tar.gz
