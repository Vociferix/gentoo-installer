#!/bin/bash

source /etc/profile
NPROC=`nproc`
export MAKEOPTS="-j$(($NPROC + 1)) -l$NPROC"
export EMERGE_DEFAULT_OPTS="--jobs=$NPROC --load-average=$NPROC"
export GENTOO_MIRRORS="$1"

emerge-webrsync || exit 1

PROFILE=`eselect profile list | grep -o "default/linux/amd64/.*/desktop/gnome/systemd (stable)" | grep -o ".*systemd" | sort | tail -n 1`
eselect profile set ${PROFILE} || exit 1

sed -i '/USE=.*/d' /etc/portage/make.conf
echo >> /etc/portage/make.conf
echo "USE=\"bindist -gnome -gnome-online-accounts -wayland -nautilus\"" >> /etc/portage/make.conf

emerge --update --deep --newuse @world || exit 1t

emerge sys-kernel/linux-firmware || exit 1
emerge gentoo-kernel || exit 1

emerge --depclean || exit 1
echo "x11-libs/libdrm libkms" >> /etc/portage/package.use/plymouth
emerge \
    app-admin/hddtemp \
    app-admin/sudo \
    app-arch/p7zip \
    app-arch/zip \
    app-cdr/xfburn \
    app-editors/emacs \
    app-editors/mousepad \
    app-editors/nano \
    app-editors/vim \
    app-misc/screen \
    app-misc/tmux \
    app-office/libreoffice-bin \
    app-office/orage \
    app-portage/cpuid2cpuflags \
    app-portage/gentoolkit \
    app-portage/mirrorselect \
    app-text/wgetpaste \
    gnome-extra/nm-applet \
    mail-client/thuderbird-bin \
    media-gfx/fbgrab \
    media-sound/alsa-utils \
    media-sound/pavucontrol \
    net-analyzer/traceroute \
    net-dialup/ppp \
    net-dialup/pptpclient \
    net-dialup/rp-pppoe \
    net-fs/cifs-utils \
    net-fs/nfs-utils \
    net-irc/irssi \
    net-misc/ndisc6 \
    net-misc/ntp \
    net-misc/rdate \
    net-misc/vconfig \
    net-proxy/dante \
    net-proxy/tsocks \
    net-wireless/b43-fwcutter \
    net-wireless/wireless-tools \
    sys-apps/dmidecode \
    sys-apps/ethtool \
    sys-apps/fxload \
    sys-apps/gptfdisk \
    sys-apps/hdparm \
    sys-apps/hwsetup \
    sys-apps/memtester \
    sys-apps/mlocate \
    sys-apps/netplug \
    sys-apps/nvme-cli \
    sys-apps/pciutils \
    sys-apps/pcmciautils \
    sys-apps/sdparm \
    sys-apps/usbutils \
    sys-block/parted \
    sys-block/partimage \
    sys-boot/plymouth \
    sys-fs/btrfs-progs \
    sys-fs/cryptsetup \
    sys-fs/dmraid \
    sys-fs/dosfstools \
    sys-fs/e2fsprogs \
    sys-fs/f2fs-tools \
    sys-fs/jfsutils \
    sys-fs/lsscsi \
    sys-fs/lvm2 \
    sys-fs/mac-fdisk \
    sys-fs/mdadm \
    sys-fs/multipath-tools \
    sys-fs/reiserfsprogs \
    sys-fs/squashfs-tools \
    sys-fs/xfsprogs \
    sys-power/acpid \
    sys-process/cronie \
    www-client/firefox-bin \
    www-client/links \
    x11-misc/alacarte \
    x11-misc/lightdm \
    x11-terms/xfce4-terminal \
    x11-themes/xfwm4-themes \
    xfce-base/thunar \
    xfce-base/xfce4-appfinder \
    xfce-base/xfce4-meta \
    xfce-extra/thunar-archive-plugin \
    xfce-extra/thunar-volman \
    xfce-extra/tumbler \
    xfce-extra/xfce4-battery-plugin \
    xfce-extra/xfce4-mount-plugin \
    xfce-extra/xfce4-notifyd \
    xfce-extra/xfce4-power-manager \
    xfce-extra/xfce4-pulseaudio-plugin \
    xfce-extra/xfce4-sensors-plugin \
    xfce-extra/xfce4-verve-plugin \
    app-emulation/virtualbox-guest-additions \
    || exit 1
emerge --deselect=y xfce-extra/xfce4-notifyd || exit 1
emerge --depclean || exit 1

sed -i \
    's/#user-session=.*/user-session=xfce/g' \
    /etc/lightdm/lightdm.conf || exit 1
sed -i \
    's/#autologin-user=/autologin-user=user/g' \
    /etc/lightdm/lightdm.conf || exit 1
sed -i \
    's/#autologin-user-timeout=.*/autologin-user-timeout=0/g' \
    /etc/lightdm/lightdm.conf || exit 1

mv /tmp/squashfs.conf /etc/dracut.conf.d/ || exit 1
plymouth-set-default-theme spinfinity
dracut --force

echo "gentoo-live" > /etc/hostname

systemctl preset-all

mv /tmp/50-dhcp.network /etc/systemd/network/ || exit 1
systemctl enable systemd-networkd.service || exit 1

systemctl enable cronie || exit 1
systemctl enable NetworkManager || exit 1
systemctl enable lightdm || exit 1

rm -f /etc/resolv.conf
ln -snf /run/systemd/resolve/resolv.conf /etc/resolv.conf || exit 1
systemctl enable systemd-resolved.service || exit 1

useradd -G users,wheel,audio,cdrom,usb,video,plugdev,vboxguest -s /bin/bash user
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
mv /tmp/user/.config /home/user/.config && chown -R user:user /home/user/.config
mv /tmp/user/.mozilla /home/user/.mozilla && chown -R user:user /home/user/.mozilla
mv /tmp/user/Desktop /home/user/Desktop && chown -R user:user /home/user/Desktop
mv /tmp/background.png /usr/share/backgrounds/gentoo.png


