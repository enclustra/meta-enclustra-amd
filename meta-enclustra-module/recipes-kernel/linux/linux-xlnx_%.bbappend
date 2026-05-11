FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS:prepend:zynqmp-generic := "${THISDIR}/${PN}/zynqmp:"
FILESEXTRAPATHS:prepend:zynq-generic := "${THISDIR}/${PN}/zynq:"

ENCLUSTRA_BOOTMODE := "sd"
ENCLUSTRA_BOOTMODE:enclustra-qspi := "qspi"
ENCLUSTRA_BOOTMODE:enclustra-emmc := "emmc"

FILESEXTRAPATHS:prepend:zynqmp-generic := "${THISDIR}/${PN}/zynqmp/${ENCLUSTRA_BOOTMODE}:"
FILESEXTRAPATHS:prepend:zynq-generic := "${THISDIR}/${PN}/zynq/${ENCLUSTRA_BOOTMODE}:"

SRC_URI:append = " file://0001-rtc-zynqmp-Ensure-correct-RTC-calibration.patch"
SRC_URI:append = " file://0010-atsha204a-read-from-otp.patch"
SRC_URI:append = " file://0011-atsha204a-fixes.patch"
SRC_URI:append = " file://0020-hwmon-add-ir35215.patch"

## (debugging) mark recipe as development version
#DEFAULT_PREFERENCE = "-1"

SRC_URI:append = " file://kernel.cfg"
KERNEL_FEATURES:append = " kernel.cfg"

SRC_URI:append:xu61-module:enclustra-qspi = " file://limit_cma.cfg"
KERNEL_FEATURES:append:xu61-module:enclustra-qspi = " limit_cma.cfg"

SRC_URI:append:xzu80-module = " file://tpm_i2c.cfg"
KERNEL_FEATURES:append:xzu80-module = " tpm_i2c.cfg"

SRC_URI:append:xzu90-module = " \
	file://hwmon_ir35215.cfg \
	file://tpm_i2c.cfg \
"
KERNEL_FEATURES:append:xzu90-module = " \
	hwmon_ir35215.cfg \
	tpm_i2c.cfg \
"

kernel_do_deploy:append:enclustra-qspi() {
	ln -snf fitImage-${INITRAMFS_IMAGE_NAME}-${KERNEL_FIT_NAME}${KERNEL_FIT_BIN_EXT} $deployDir/fitImage
}

## excludes this kernel explicitely from other MACHINE build targets
COMPATIBLE_MACHINE = "(zynq-generic|zynqmp-generic)"
