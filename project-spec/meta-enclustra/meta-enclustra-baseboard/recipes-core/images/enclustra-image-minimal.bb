# Copyright (C) 2023 Enclustra, author Lothar Rubusch <lothar.rubusch@enclustra.com>
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-core/images/petalinux-image-minimal.bb

SUMMARY = "Enclustra SD image"
DESCRIPTION = "The Enclustra SD boot medium image is based on petalinux-image-minimal"

LICENSE = "MIT"

## template below:
##
#inherit core-image
#
##start of the resulting deployable tarball name
#export IMAGE_BASENAME = "Custom-Console-Image"
#MACHINE_NAME ?= "${MACHINE}"
#IMAGE_NAME = "${MACHINE_NAME}_${IMAGE_BASENAME}"
#
#SYSTEMD_DEFAULT_TARGET = "graphical.target"
#
#IMAGE_LINGUAS = "en-us"
#
#ROOTFS_PKGMANAGE_PKGS ?= '${@oe.utils.conditional("ONLINE_PACKAGE_MANAGEMENT", "none", "", "${ROOTFS_PKGMANAGE}", d)}'
#
#IMAGE_INSTALL:append = " \
#    packagegroup-boot \
#    packagegroup-basic \
#    udev-extra-rules \
#    ${ROOTFS_PKGMANAGE_PKGS} \
#    weston weston-init wayland-terminal-launch \
#    hello-world \
#"
#
#IMAGE_DEV_MANAGER   = "udev"
#IMAGE_INIT_MANAGER  = "systemd"
#IMAGE_INITSCRIPTS   = " "
#IMAGE_LOGIN_MANAGER = "busybox shadow"
