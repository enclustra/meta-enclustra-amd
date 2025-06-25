## When using the gen-machineconf tool, the correct MACHINEOVERRIDE for cg, eg
## and ev should be automatically set, but is not.
SOC_VARIANT = "${@'ev' if 'ev' in d.getVar('MACHINE') else 'eg' if 'eg' in d.getVar('MACHINE') else 'cg'}"

## Note: This is expected to implicitly depend on zynqmp-generic.conf.
## If it no longer does, please audit the recipes and apply the necessary
## updates.
require conf/machine/zynqmp-${SOC_VARIANT}-generic.conf

KERNEL_CLASSES:append = " kernel-fitimage"
KERNEL_IMAGETYPES:append = " fitImage"

inherit image_types_enclustra
IMAGE_TYPES:append = " cpio_enclustra.xz"
INITRAMFS_FSTYPES = "cpio_enclustra.xz"
FIT_SUPPORTED_INITRAMFS_FSTYPES:append = " cpio_enclustra.xz"

INITRAMFS_IMAGE = "petalinux-image-minimal"
