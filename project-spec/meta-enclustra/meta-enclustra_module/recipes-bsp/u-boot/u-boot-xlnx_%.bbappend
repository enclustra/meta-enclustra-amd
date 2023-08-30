FILESEXTRAPATHS:prepend := "${THISDIR}/files/common:"

FILESEXTRAPATHS:prepend:zynqmp-generic := "${THISDIR}/files/zynqmp:"
FILESEXTRAPATHS:prepend:zynq-generic := "${THISDIR}/files/zynq:"

ENCLUSTRA_BOOTMODE := "sd"
ENCLUSTRA_BOOTMODE:enclustra-qspi := "qspi"
#ENCLUSTRA_BOOTMODE:enclustra-emmc := "emmc"
#...

FILESEXTRAPATHS:prepend:zynqmp-generic := "${THISDIR}/files/zynqmp/${ENCLUSTRA_BOOTMODE}:"
FILESEXTRAPATHS:prepend:zynq-generic := "${THISDIR}/files/zynq/${ENCLUSTRA_BOOTMODE}:"

## common
## NB: 0001-ubifs patch messes up QSPI bootcmd line - thus don't take this patch
#SRC_URI:append = " file://0001-ubifs-distroboot-support.patch"
SRC_URI:append = " file://0008-Enclustra-MAC-address-readout-from-EEPROM.patch"

## specific
SRC_URI:append:zynqmp-generic = " file://0010-Enclustra-Zynqmp-Board-Patch.patch"
SRC_URI:append:zynq-generic = " file://0010-Enclustra-Zynq-Board-Patch.patch"

## common
## TODO: the atcha fixes seem to be upstream, verify
#SRC_URI:append:zynqmp-generic = " file://0012-Bugfix-for-atsha204a-driver.patch"
SRC_URI:append = " file://0020-Enclustra-ds28-eeprom-fix.patch"
SRC_URI:append = " file://0030-zynq-qspi.patch"
SRC_URI:append = " file://0040-emmc.patch"

SRC_URI:append = " file://u-boot.cfg"
