FILESEXTRAPATHS:prepend:zynqmp-generic := "${THISDIR}/files/zynqmp:${SYSCONFIG_PATH}:"
FILESEXTRAPATHS:prepend:zynq-generic := "${THISDIR}/files/zynq:${SYSCONFIG_PATH}:"

SRC_URI:append = " file://system-user.dtsi"
SRC_URI:append:pe1-generic = " file://enclustra_mercury_pe1.dtsi"
SRC_URI:append:pe3-generic = " file://enclustra_mercury_pe3.dtsi"
SRC_URI:append:pe5-generic = " file://enclustra_andromeda_pe5.dtsi"
SRC_URI:append:st1-generic = " file://enclustra_mercury_st1.dtsi"
SRC_URI:append:st3-generic = " file://enclustra_mars_st3.dtsi"

## fix DT flags for petalinux tool
## (required with explicit override ONLY!)
YAML_DT_BOARD_FLAGS = "{BOARD template}"
PROC_TUNE = "${@'cortexa53' if d.getVar('SYSTEM_DTFILE') != '' else ''}"

ENCLUSTRA_BOOTMODE := "sd"
ENCLUSTRA_BOOTMODE:enclustra-qspi := "qspi"
ENCLUSTRA_BOOTMODE:enclustra-emmc := "emmc"

## append SOM dtsi
do_configure:prepend:xu1-module() {
    echo "#include \"zynqmp_enclustra_mercury_xu1.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xu3-module() {
    echo "#include \"zynqmp_enclustra_mars_xu3.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xu5-module() {
    echo "#include \"zynqmp_enclustra_mercury_xu5.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xu6-module() {
    echo "#include \"zynqmp_enclustra_mercury_xu6.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xu61-module() {
    echo "#include \"zynqmp_enclustra_mercury_xu61.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xu7-module() {
    echo "#include \"zynqmp_enclustra_mercury_xu7.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xu8-module() {
    echo "#include \"zynqmp_enclustra_mercury_xu8.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xu9-module() {
    echo "#include \"zynqmp_enclustra_mercury_xu9.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xzu65-module() {
    echo "#include \"zynqmp_enclustra_andromeda_xzu65.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xzu80-module() {
    echo "#include \"zynqmp_enclustra_andromeda_xzu80.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:xzu90-module() {
    echo "#include \"zynqmp_enclustra_andromeda_xzu90.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:zx1-module() {
    echo "#include \"zynq_enclustra_mercury_zx1.dtsi\"" >> ../system-user.dtsi
    echo "#include \"zynq_enclustra_nand_parts.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:zx2-module() {
    echo "#include \"zynq_enclustra_mars_zx2.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:zx3-module() {
    echo "#include \"zynq_enclustra_mars_zx3.dtsi\"" >> ../system-user.dtsi
    echo "#include \"zynq_enclustra_nand_parts.dtsi\"" >> ../system-user.dtsi
}
do_configure:prepend:zx5-module() {
    echo "#include \"zynq_enclustra_mercury_zx5.dtsi\"" >> ../system-user.dtsi
    echo "#include \"zynq_enclustra_nand_parts.dtsi\"" >> ../system-user.dtsi
}

## baseboard
do_configure:append:pe1-generic() {
    echo "#include \"enclustra_mercury_pe1.dtsi\"" >> ../system-user.dtsi
}
do_configure:append:pe3-generic() {
    echo "#include \"enclustra_mercury_pe3.dtsi\"" >> ../system-user.dtsi
}
do_configure:append:pe5-generic() {
    echo "#include \"enclustra_andromeda_pe5.dtsi\"" >> ../system-user.dtsi
}
do_configure:append:st1-generic() {
    echo "#include \"enclustra_mercury_st1.dtsi\"" >> ../system-user.dtsi
}
do_configure:append:st3-generic() {
    echo "#include \"enclustra_mars_st3.dtsi\"" >> ../system-user.dtsi
}

## bootargs
devicetree_do_compile:prepend:zynqmp-generic() {
    if d.getVar('ENCLUSTRA_BOOTMODE', 'FAILED') == "sd":
        os.system("sed -ie '\|bootargs =|s|.*|             bootargs = \"earlycon console=ttyPS0,115200 clk_ignore_unused uio_pdrv_genirq.of_id=generic-uio root=/dev/mmcblk1p2 rw rootwait\";|' device-tree/system-top.dts")
    elif d.getVar('ENCLUSTRA_BOOTMODE', 'FAILED') == "emmc":
        os.system("sed -ie '\|bootargs =|s|.*|             bootargs = \"earlycon console=ttyPS0,115200 clk_ignore_unused uio_pdrv_genirq.of_id=generic-uio root=/dev/mmcblk0p2 rw rootwait\";|' device-tree/system-top.dts")
    elif d.getVar('ENCLUSTRA_BOOTMODE', 'FAILED') == "qspi":
        os.system("sed -ie '\|bootargs =|s|.*|             bootargs = \"earlycon console=ttyPS0,115200 clk_ignore_unused uio_pdrv_genirq.of_id=generic-uio root=/dev/ram0 rw\";|' device-tree/system-top.dts")
    else:
        os.system("touch 'FIX_BOOTARGS_OR_FALLBACK_TO_DEFAULT'")

    os.system("sed -rie 's@(/include/.*)@// \1@' ../system-user.dtsi")

    f = open('device-tree/system-top.dts', 'a')
    f.write('#include "system-user.dtsi"')
    f.close()
}

devicetree_do_compile:prepend:zynq-generic() {
    if d.getVar('ENCLUSTRA_BOOTMODE', 'FAILED') == "sd":
        os.system("sed -ie '\|bootargs =|s|.*|             bootargs = \"earlycon console=ttyPS0,115200 clk_ignore_unused uio_pdrv_genirq.of_id=generic-uio root=/dev/mmcblk0p2 rw rootwait\";|' device-tree/system-top.dts")
    elif d.getVar('ENCLUSTRA_BOOTMODE', 'FAILED') == "qspi":
        os.system("sed -ie '\|bootargs =|s|.*|             bootargs = \"earlycon console=ttyPS0,115200 clk_ignore_unused uio_pdrv_genirq.of_id=generic-uio root=/dev/ram0 rw rootwait\";|' device-tree/system-top.dts")
    else:
        os.system("touch 'FIX_BOOTARGS_OR_FALLBACK_TO_DEFAULT'")

    os.system("sed -rie 's@(/include/.*)@// \1@' ../system-user.dtsi")

    f = open('device-tree/system-top.dts', 'a')
    f.write('#include "system-user.dtsi"')
    f.close()
}
