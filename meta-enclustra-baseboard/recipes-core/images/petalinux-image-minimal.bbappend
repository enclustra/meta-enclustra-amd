## enclustra packages
IMAGE_INSTALL:append = " packagegroup-core-boot"
IMAGE_INSTALL:append = " kernel-modules"
IMAGE_INSTALL:append = " fpga-manager-script"
IMAGE_INSTALL:append = " run-postinsts"
IMAGE_INSTALL:append = " udev-extraconf"
IMAGE_INSTALL:append = " linux-xlnx-udev-rules"

IMAGE_INSTALL:append:zynqmp-generic = " libdfx"

## not needed packages / broken setup
IMAGE_INSTALL:remove = "nfs-utils"
IMAGE_INSTALL:remove = "nfs-utils-client"

## QSPI: size limited qspi variant
IMAGE_INSTALL:remove:enclustra-qspi = " meson"

IMAGE_FSTYPES:append:enclustra-sd = " wic wic.bmap"
WKS_FILES:enclustra-sd = "mmc-image.wks"
IMAGE_BOOT_FILES:remove:enclustra-sd = "fitImage u-boot.bin"
IMAGE_BOOT_FILES:remove:enclustra-sd = "system.dtb"

IMAGE_FSTYPES:append:enclustra-emmc = " wic wic.bmap"
WKS_FILES:enclustra-emmc = "mmc-image.wks"
IMAGE_BOOT_FILES:remove:enclustra-emmc = "fitImage u-boot.bin"
IMAGE_BOOT_FILES:remove:enclustra-emmc = "system.dtb"

## remove not needed image times (slightly faster)
IMAGE_FSTYPES:remove:enclustra-qspi = " tar.gz"
IMAGE_FSTYPES:remove:enclustra-qspi = " cpio.gz"
IMAGE_FSTYPES:remove:enclustra-qspi = " cpio.gz.u-boot"
IMAGE_FSTYPES:remove:enclustra-qspi = " ext4"
IMAGE_FSTYPES:remove:enclustra-qspi = " cpio"

## recipe: generate the new image
inherit image_types_enclustra
IMAGE_FSTYPES:append:enclustra-qspi = " cpio_enclustra.xz"
IMAGE_ROOTFS_SIZE:enclustra-qspi = "32768"
