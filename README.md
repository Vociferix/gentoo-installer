# Gentoo Desktop Installer

This is an **unofficial** automated installer creator for Gentoo Linux. This will create a bootable ISO file that contains a live Gentoo image with the installer software. Gentoo is owned by the Gentoo Foundation, and the Gentoo logo artwork is licensed under CC-BY-SA/2.5.

## Status
Currently this repo only supports generating a custom bootable Gentoo Live CD ISO for amd64 (both BIOS and UEFI). The next step is the actual installer. To build the ISO, simply run the `build.sh` script. Required dpendencies include `grub-mkrescue` and `xorriso` for creating the bootable image, and `wget` for retrieving distribution files. Otherwise, the only required tools include standard linux utilities, such as tar, chroot, mount, etc.
