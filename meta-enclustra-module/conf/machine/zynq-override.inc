require conf/machine/zynq-generic.conf

## NB: INIT_MANAGER_DEFAULT is the system fall back, if INIT_MANAGER is not set
INIT_MANAGER ?= "systemd"
INIT_MANAGER_DEFAULT ?= "systemd"

## NB: actually zynq-generic platforms provide (older) uImage, we will go with
## fitImage, though. It is the more recent format and follows the yocto
## approach.
KERNEL_CLASSES:append = " kernel-fitimage"
KERNEL_IMAGETYPES:append = " fitImage"

inherit image_types_enclustra
IMAGE_TYPES:append = " cpio_enclustra.xz"
INITRAMFS_FSTYPES:enclustra-qspi = "cpio_enclustra.xz"
FIT_SUPPORTED_INITRAMFS_FSTYPES:append = " cpio_enclustra.xz"

INITRAMFS_IMAGE:enclustra-qspi = "petalinux-image-minimal"
