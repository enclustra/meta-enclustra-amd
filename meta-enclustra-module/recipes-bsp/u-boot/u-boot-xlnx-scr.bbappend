# Handle bootargs
SDBOOTDEV:zynqmp-generic:enclustra-sd = "1"
SDBOOTDEV:zynqmp-generic:enclustra-emmc = "0"
SDBOOTDEV:zynq-generic:enclustra-sd = "0"
KERNEL_ROOT_SD:enclustra-sd = "root=/dev/\${bootdev}${PARTNUM} rw rootwait"
KERNEL_ROOT_SD:enclustra-emmc = "root=/dev/\${bootdev}${PARTNUM} rw rootwait"

QSPI_FIT_IMAGE_OFFSET:enclustra-qspi:qspi-64-mbytes = "0x2000000"
QSPI_FIT_IMAGE_OFFSET:enclustra-qspi:qspi-128-mbytes = "0x4000000"
QSPI_FIT_IMAGE_SIZE:enclustra-qspi:qspi-64-mbytes = "0x2000000"
QSPI_FIT_IMAGE_SIZE:enclustra-qspi:qspi-128-mbytes = "0x4000000"
