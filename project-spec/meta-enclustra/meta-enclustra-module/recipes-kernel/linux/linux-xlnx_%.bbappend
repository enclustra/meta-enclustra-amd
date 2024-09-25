FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS:prepend:zynqmp-generic := "${THISDIR}/${PN}/zynqmp:"
FILESEXTRAPATHS:prepend:zynq-generic := "${THISDIR}/${PN}/zynq:"

ENCLUSTRA_BOOTMODE := "sd"
ENCLUSTRA_BOOTMODE:enclustra-qspi := "qspi"
ENCLUSTRA_BOOTMODE:enclustra-emmc := "emmc"
#...

FILESEXTRAPATHS:prepend:zynqmp-generic := "${THISDIR}/${PN}/zynqmp/${ENCLUSTRA_BOOTMODE}:"
FILESEXTRAPATHS:prepend:zynq-generic := "${THISDIR}/${PN}/zynq/${ENCLUSTRA_BOOTMODE}:"

SRC_URI:append = " file://0010-RTL8211F.patch"

## patches
# TODO check for particular QSPI patches (opt)
#SRC_URI:enclustra-qspi = "..."

## (debugging) mark recipe as development version
#DEFAULT_PREFERENCE = "-1"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"

SRC_URI:append = " file://kernel.cfg"
KERNEL_FEATURES:append = " kernel.cfg"

## excludes this kernel explicitely from other MACHINE build targets
COMPATIBLE_MACHINE = "(zynq-generic|zynqmp-generic)"
