## WORKAROUND: This is a workaround to allow the use of the same machine configuration for different machine types.
# When using the gen-machineconf tool, the correct MACHINEOVERRIDE for cg, eg and ev should be automatically set, but is not.
SOC_VARIANT = "${@'ev' if 'ev' in d.getVar('MACHINE') else 'eg' if 'eg' in d.getVar('MACHINE') else 'cg'}"
require conf/machine/zynqmp-${SOC_VARIANT}-generic.conf

KERNEL_CLASSES:append = " kernel-fitimage"
KERNEL_IMAGETYPES:append = " fitImage"

## config: declare IMAGE_TYPES (make them selectable)
IMAGE_TYPES:append = " cpio_enclustra.xz"

## config: use the generated image for INITRAMFS (must be declared here)
inherit image_types_enclustra

INITRAMFS_FSTYPES = "cpio_enclustra.xz"
FIT_SUPPORTED_INITRAMFS_FSTYPES:append = " cpio_enclustra.xz"

INITRAMFS_IMAGE = "petalinux-image-minimal"
