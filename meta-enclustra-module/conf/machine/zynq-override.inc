require conf/machine/zynq-generic.conf

## NB: INIT_MANAGER_DEFAULT is the system fall back, if INIT_MANAGER is not set
INIT_MANAGER ?= "systemd"

KERNEL_CLASSES:append = " kernel-fitimage"
KERNEL_IMAGETYPES:append = " fitImage"

inherit image_types_enclustra
IMAGE_TYPES:append = " cpio_enclustra.xz"
INITRAMFS_FSTYPES = "cpio_enclustra.xz"
FIT_SUPPORTED_INITRAMFS_FSTYPES:append = " cpio_enclustra.xz"
