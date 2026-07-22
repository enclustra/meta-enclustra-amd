# Enclustra Linux Reference Design for AMD MPSoC and Zynq 7000

## Maintainer

Enclustra GmbH  [support@enclustra.com]

## License

See [License](LICENSE)

## Changelog

| Date       | Version | Comment                                                                         |
|------------|---------|---------------------------------------------------------------------------------|
| 22.08.2025 | 2024.2  | - Initial release of Enclustra yocto meta layers                                |

## Description

This repository contains yocto layers to generate Linux reference designs for the following Enclustra products:

### Andromeda
* [Enclustra Andromeda XZU65 product series](https://www.enclustra.com/en/products/system-on-chip-modules/andromeda-xzu65/)
* [Enclustra Andromeda XZU80 product series](https://www.enclustra.com/en/products/system-on-chip-modules/andromeda-xzu80/)
* [Enclustra Andromeda XZU90 product series](https://www.enclustra.com/en/products/system-on-chip-modules/andromeda-xzu90/)
### Mercury
* [Enclustra Mercury+ XU1 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu1/)
* [Enclustra Mercury XU5 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu5/)
* [Enclustra Mercury+ XU6 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu6/)
* [Enclustra Mercury+ XU61 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu61/)
* [Enclustra Mercury+ XU7 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu7/)
* [Enclustra Mercury+ XU8 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu8/)
* [Enclustra Mercury+ XU9 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu9/)
* [Enclustra Mercury ZX1 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-zx1/)
* [Enclustra Mercury ZX5 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-zx5/)
### Mars
* [Enclustra Mars XU3 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mars-xu3/)
* [Enclustra Mars ZX2 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mars-zx2/)
* [Enclustra Mars ZX3 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mars-zx3/)

The reference design is based on [meta-xilinx](https://github.com/Xilinx/meta-xilinx) and [meta-petalinux](https://github.com/Xilinx/meta-petalinux) release 2024.2, which uses the following versions:

* Yocto: scarthgap
* U-Boot: 2024.01
* Linux kernel: 6.6.0

## FPGA Reference Designs for AMD Vivado

The XSA needed to create the respective reference desgin linux images are provided by the reference design repositories release 2024.2:

### Andromeda
* [Andromeda_XZU65_PE5_Reference_Design](https://github.com/enclustra/Andromeda_XZU65_PE5_Reference_Design)
* [Andromeda_XZU80_PE5_Reference_Design](https://github.com/enclustra/Andromeda_XZU80_PE5_Reference_Design)
* [Andromeda_XZU90_PE5_Reference_Design](https://github.com/enclustra/Andromeda_XZU90_PE5_Reference_Design)
### Mars
* [Mars_XU3_ST3_Reference_Design](https://github.com/enclustra/Mars_XU3_ST3_Reference_Design)
* [Mars_ZX2_ST3_Reference_Design](https://github.com/enclustra/Mars_ZX2_ST3_Reference_Design)
* [Mars_ZX3_ST3_Reference_Design](https://github.com/enclustra/Mars_ZX3_ST3_Reference_Design)
### Mercury
* [Mercury_XU1_PE1_Reference_Design](https://github.com/enclustra/Mercury_XU1_PE1_Reference_Design)
* [Mercury_XU1_PE3_Reference_Design](https://github.com/enclustra/Mercury_XU1_PE3_Reference_Design)
* [Mercury_XU1_ST1_Reference_Design](https://github.com/enclustra/Mercury_XU1_ST1_Reference_Design)
* [Mercury_XU5_PE1_Reference_Design](https://github.com/enclustra/Mercury_XU5_PE1_Reference_Design)
* [Mercury_XU5_PE3_Reference_Design](https://github.com/enclustra/Mercury_XU5_PE3_Reference_Design)
* [Mercury_XU5_ST1_Reference_Design](https://github.com/enclustra/Mercury_XU5_ST1_Reference_Design)
* [Mercury_XU6_PE1_Reference_Design](https://github.com/enclustra/Mercury_XU6_PE1_Reference_Design)
* [Mercury_XU6_PE3_Reference_Design](https://github.com/enclustra/Mercury_XU6_PE3_Reference_Design)
* [Mercury_XU6_ST1_Reference_Design](https://github.com/enclustra/Mercury_XU6_ST1_Reference_Design)
* [Mercury_XU61_PE1_Reference_Design](https://github.com/enclustra/Mercury_XU61_PE1_Reference_Design)
* [Mercury_XU61_PE3_Reference_Design](https://github.com/enclustra/Mercury_XU61_PE3_Reference_Design)
* [Mercury_XU61_ST1_Reference_Design](https://github.com/enclustra/Mercury_XU61_ST1_Reference_Design)
* [Mercury_XU7_PE1_Reference_Design](https://github.com/enclustra/Mercury_XU7_PE1_Reference_Design)
* [Mercury_XU7_PE3_Reference_Design](https://github.com/enclustra/Mercury_XU7_PE3_Reference_Design)
* [Mercury_XU7_ST1_Reference_Design](https://github.com/enclustra/Mercury_XU7_ST1_Reference_Design)
* [Mercury_XU8_PE1_Reference_Design](https://github.com/enclustra/Mercury_XU8_PE1_Reference_Design)
* [Mercury_XU8_PE3_Reference_Design](https://github.com/enclustra/Mercury_XU8_PE3_Reference_Design)
* [Mercury_XU8_ST1_Reference_Design](https://github.com/enclustra/Mercury_XU8_ST1_Reference_Design)
* [Mercury_XU9_PE1_Reference_Design](https://github.com/enclustra/Mercury_XU9_PE1_Reference_Design)
* [Mercury_XU9_PE3_Reference_Design](https://github.com/enclustra/Mercury_XU9_PE3_Reference_Design)
* [Mercury_XU9_ST1_Reference_Design](https://github.com/enclustra/Mercury_XU9_ST1_Reference_Design)
* [Mercury_ZX1_PE1_Reference_Design](https://github.com/enclustra/Mercury_ZX1_PE1_Reference_Design)
* [Mercury_ZX1_PE3_Reference_Design](https://github.com/enclustra/Mercury_ZX1_PE3_Reference_Design)
* [Mercury_ZX1_ST1_Reference_Design](https://github.com/enclustra/Mercury_ZX1_ST1_Reference_Design)
* [Mercury_ZX5_PE1_Reference_Design](https://github.com/enclustra/Mercury_ZX5_PE1_Reference_Design)
* [Mercury_ZX5_PE3_Reference_Design](https://github.com/enclustra/Mercury_ZX5_PE3_Reference_Design)
* [Mercury_ZX5_ST1_Reference_Design](https://github.com/enclustra/Mercury_ZX5_ST1_Reference_Design)

> **_NOTE:_** **The XSA are found in the respective release of the reference design repositories, e.g.** [Mercury XU5 PE1 release 2024.2_v1.3.2](https://github.com/enclustra/Mercury_XU5_PE1_Reference_Design/releases/tag/2024.2_v1.3.2).

## Host Requirements

### Host Operating System

Refer to the official yocto documentation for the [build host preparation](https://docs.yoctoproject.org/singleindex.html#preparing-the-build-host) and the [system requirements](https://docs.yoctoproject.org/scarthgap/ref-manual/system-requirements.html#system-requirements).

The reference design build was tested on the following operating systems:

- Ubuntu 22.04

### Additional Required Packages

1. The [repo tool](https://gerrit.googlesource.com/git-repo/) is used to gather all required meta layers and repositories for building the reference design.

Follow the [install instructions](https://gerrit.googlesource.com/git-repo/#install) to install the repo tool.

2. The `xsct` tool used as part of the AMD tools requires the `libtinfo.so.5` library.
```bash
sudo apt-get install libtinfo5
```

## Build

### Project Setup
1. Use the repo tool to setup all required layers and repositories using the [AMD yocto manifests repository](https://github.com/Xilinx/yocto-manifests/) in your workspace:

```bash
repo init -u "https://github.com/Xilinx/yocto-manifests.git" -b "rel-v2024.2"
repo sync
```

2. Clone this repository:
```bash
git clone https://github.com/enclustra/meta-enclustra-amd.git -b "xlnx-2024.2"
```

The expected workspace folder structure is given below:
```bash
├── meta-enclustra-amd
│   ├── LICENSE
│   ├── meta-enclustra-baseboard
│   ├── meta-enclustra-module
│   ├── meta-enclustra-refdes
│   ├── meta-enclustra-lab
│   └── README.md
├── setupsdk
└── sources
    ├── manifest
    ├── meta-amd-adaptive-socs
    ├── meta-arm
    ├── meta-aws
    ├── meta-embedded-plus
    ├── meta-jupyter
    ├── meta-kria
    ├── meta-mingw
    ├── meta-openamp
    ├── meta-openembedded
    ├── meta-petalinux
    ├── meta-qt5
    ├── meta-rauc
    ├── meta-ros
    ├── meta-security
    ├── meta-system-controller
    ├── meta-virtualization
    ├── meta-vitis
    ├── meta-xilinx
    ├── meta-xilinx-tools
    ├── meta-xilinx-tsn
    ├── poky
    └── yocto-scripts
```

3. Source the `setupsdk` script to setup the yocto project build folder and build environment:
```bash
source ./setupsdk
```
This will create the build folder and change into the `build` folder in your workspace.

4. Add the Enclustra meta layers:
```bash
bitbake-layers add-layer ../meta-enclustra-amd/meta-enclustra-module
bitbake-layers add-layer ../meta-enclustra-amd/meta-enclustra-baseboard
bitbake-layers add-layer ../meta-enclustra-amd/meta-enclustra-refdes
```
The layers should be added to `conf/bblayers.conf`:
```bash
tail conf/bblayers.conf 
    /ws/sources/poky/../meta-jupyter \
    /ws/sources/poky/../meta-rauc \
    /ws/sources/poky/../meta-system-controller \
    /ws/sources/poky/../meta-ros/meta-ros-common \
    /ws/sources/poky/../meta-ros/meta-ros2 \
    /ws/sources/poky/../meta-ros/meta-ros2-jazzy \
    /ws/meta-enclustra-amd/meta-enclustra-baseboard \
    /ws/meta-enclustra-amd/meta-enclustra-module \
    /ws/meta-enclustra-amd/meta-enclustra-refdes \
    "
```

5. The reference design relies on the [gen-machineconf tool](https://github.com/Xilinx/gen-machine-conf/tree/xlnx-rel-v2024.2) provided by the [meta-xilinx repository](https://github.com/Xilinx/meta-xilinx/tree/xlnx-rel-v2024.2) to generate the machine config.

This tool takes an XSA exported from Vivado as input and generates a machine config that can be used in the yocto project as the target **MACHINE**.

The following parameters are needed to create the machine config for the reference design:
```bash
../sources/meta-xilinx/meta-xilinx-core/gen-machine-conf/gen-machineconf parse-xsa \
    --hw-description <path-to-xsa> \
    --require-machine <refdes-machine-conf> \
    --machine-overrides enclustra-<bootmode> \
    --machine-name <refdes-machine-conf>
```

The XSA can be obtained from the respective reference design repository release section, e. g. [Mercury XU5 PE1](https://github.com/enclustra/Mercury_XU5_PE1_Reference_Design/releases/download/2024.2_v1.3.2/ME-XU5-2CG-1E-D10H.zip).

Example:
```bash
../sources/meta-xilinx/meta-xilinx-core/gen-machine-conf/gen-machineconf parse-xsa \
    --hw-description /ws/xsa/Mercury_XU5_PE1.xsa \
    --require-machine refdes-xu5-pe1 \
    --machine-overrides enclustra-sd \
    --machine-name refdes-xu5-pe1
```

> **_NOTE:_** **The following warning can be ignored**:
`[WARNING] A machine refdes-xu5-pe1 was found in /ws/meta-enclustra-amd/meta-enclustra-baseboard/conf/machine/refdes-xu5-pe1.conf, this may conflict with the machine you specified.  It is recommended to use a different name for your machine.`
**In fact, this is required so that the `gen-machineconf` tool adds the SoC ID to the generated machine configuration. The meta-enclustra-module layer requires the SoC ID to add the correct machine include file**.

The output of the `gen-machineconf` command prints the newly generated **MACHINE**, e.g.:
```bash
# Use the newly generated MACHINE
MACHINE = "refdes-xu5-pe1-xczu2cg"
```

> **_NOTE:_** **Note the addition of the SoC ID to the generated MACHINE: xczu2cg**

6. Add the generated **MACHINE** to `conf/local.conf`:
```bash
tail conf/local.conf 
SKIP_META_XILINX_STANDALONE_SANITY_CHECK = "1"
SKIP_META_XILINX_STANDALONE_SDT_SANITY_CHECK = "1"
SKIP_META_XILINX_TOOLS_SANITY_CHECK = "1"
SKIP_META_VIRT_SANITY_CHECK = "1"
SKIP_META_SECURITY_SANITY_CHECK = "1"
SKIP_META_TPM_SANITY_CHECK = "1"
SKIP_META_GNOME_SANITY_CHECK = "1"
SKIP_META_RAUC_FEATURE_CHECK = "1"

MACHINE = "refdes-xu5-pe1-xczu2cg"
```

7. Build the image:
```bash
bitbake petalinux-image-minimal
```

### Supported Machine Targets

#### Andromeda
- refdes-xzu65-pe5
- refdes-xzu80-pe5
- refdes-xzu90-pe5

#### Mercury
- refdes-xu1-pe1
- refdes-xu1-pe3
- refdes-xu1-st1
- refdes-xu5-pe1
- refdes-xu5-pe3
- refdes-xu5-st1
- refdes-xu6-pe1
- refdes-xu6-pe3
- refdes-xu6-st1
- refdes-xu61-pe1
- refdes-xu61-pe3
- refdes-xu61-st1
- refdes-xu7-pe1
- refdes-xu7-pe3
- refdes-xu7-st1
- refdes-xu8-pe1
- refdes-xu8-pe3
- refdes-xu8-st1
- refdes-xu9-pe1
- refdes-xu9-pe3
- refdes-xu9-st1
- refdes-zx1-pe1
- refdes-zx1-pe3
- refdes-zx1-st1
- refdes-zx5-pe1
- refdes-zx5-pe3
- refdes-zx5-st1

#### Mars
- refdes-xu3-st3
- refdes-zx2-st3
- refdes-zx3-st3

### Supported Boot Modes
The MPSoC based products (all XU* and XZU*) support the following boot mode overrides:
- enclustra-sd
- enclustra-qspi
- enclustra-emmc

The Zynq 7000 based products (all ZX*) support the following boot mode overrides:
- enclustra-sd
- enclustra-qspi

### Accelerate Build

To reuse the downloaded files and built packages for further builds, the **DL_DIR** and **SSTATE_DIR** variabless can be set to a local directory. If this project is built for the first time, these directories must be created manually before the build is started. If the variables are not set, the default directories in the build directory are used.

For example:

```bash
export SSTATE_DIR="${HOME}/yocto-cache/aarch64-scarthgap/sstate-cache"
export DL_DIR="${HOME}/yocto-cache/aarch64-scarthgap/downloads"
export BB_ENV_PASSTHROUGH_ADDITIONS="DL_DIR SSTATE_DIR"
```

## Deployment

The OpenEmbedded Image Creator (wic) creates a partitioned image file for SD card/eMMC. The partitions are configured in the OpenEmbedded kickstart file ([mmc-image.wks](meta-enclustra-refdes/wic/mmc-image.wks)). The image file to be deployed on SD card/eMMC can be found in the `build/tmp/deploy/images/\<MACHINE\>` directory, e.g. **petalinux-image-minimal-\<MACHINE\>-\<timestamp\>.wic**.

### Creating a Bootable SD Card

Copy the image file to an SD card, e.g.

```bash
dd if=<sd-image>.wic of=<device> && sync
```

Note that the device of the SD card (\<device\>) needs to be replaced with the SD card device on your host (e.g. /dev/sdd).

Boot from the SD card as described in the respective reference design documentation (Section **"Booting from the SD Card"**).

### Programming the eMMC Flash
An SD card image is used to program the eMMC flash. If the `ext4` partition is too small to fit the eMMC image, the ext4 partition on the SD card can be extended with tools like `resize-part` or `gparted`.

Follow these steps to program the eMMC flash with the image generated in the previous section:
1. Copy the generated image to the SD card with `sudo cp <emmc-image>.wic <path-to-rootfs-on-SD-card>/home/petalinux/`.
2. Unmount the SD card.
3. Boot from the SD card as described in the respective reference design documentation (Section **"Booting from the SD Card"**).
5. The generated image should be in the `/home/petalinux/` directory. Write the image to eMMC with `dd if=<emmc-image>.wic of=/dev/mmcblk0`.
6. Wait for completion. This step can take some time.
7. After completion, you can use `shutdown now` to exit Linux.
8. Remove the SD card from the SD card slot.
9. Unpower the board and boot from eMMC as described in the respective reference design documentation (Section **Booting from the eMMC**).

### Programming the QSPI Flash
The QSPI flash size on Enclustra modules is 64 MBytes. The only exception are Andromeda modules with a size of 128 MBytes. The reference design uses the following QSPI flash layouts:

#### Mercury and Mars Modules

| partition name | partition offset | partition size  | partition size in MB |
|----------------|------------------|-----------------|----------------------|
| boot           | 0x0              | 0x1f00000       | 31                   |
| bootenv        | 0x1f00000        | 0x80000         | 0.5                  |
| bootscr        | 0x1f80000        | 0x80000         | 0.5                  |
| fitImage       | 0x2000000        | 0x2000000       | 32                   |

#### Andromeda Modules

| partition name | partition offset | partition size  | partition size in MB |
|----------------|------------------|-----------------|----------------------|
| boot           | 0x0              | 0x3f00000       | 63                   |
| bootenv        | 0x3f00000        | 0x80000         | 0.5                  |
| bootscr        | 0x3f80000        | 0x80000         | 0.5                  |
| fitImage       | 0x4000000        | 0x4000000       | 64                   |

The generated binaries for programming the QSPI flash are found in the `build/tmp/deploy/images/\<MACHINE\>/` folder:
- boot.bin
- boot.scr
- fitImage

Program the QSPI flash on the module as described in the respective reference design documentation provided on github (Section **"Programming the QSPI flash"**).

The following bash script provides an example using the `program_flash` utility provided by Vivado/Vitis (source the `settings64.sh` first to make the utility available):
```bash
#!/bin/bash -ex
default_parameter="-flash_type qspi-x4-single -fsbl zynqmp_fsbl.elf -cable type xilinx_tcf url TCP:127.0.0.1:3121"
program_flash -f boot.bin $default_parameter
program_flash -f boot.scr -offset 0x1f80000 $default_parameter
program_flash -f fitImage -offset 0x2000000 $default_parameter
```

Follow the steps described in the respective reference design documentation provided on github (Section **Booting from the QSPI Flash**) to set up the hardware to boot from QSPI.

### Programming the NAND Flash
The size of the NAND flash on Enclustra modules is 512 MBytes (only available on ZX* modules). The NAND partition layout is given below:

| partition name | partition offset | partition size  | partition size in MB |
|----------------|------------------|-----------------|----------------------|
| kernel         | 0x0              | 0x2000000       | 32                   |
| bootscr        | 0x2000000        | 0x100000        | 1                    |
| rootfs         | 0x2100000        | 0x1DF00000      | 479                  |

The meta layers are not supporting booting from the NAND flash memory directly. The initial boot has to be from either SD card or QSPI in order to load a `boot.bin` including the FSBL, bitstream (optional) and u-boot.

Follow these steps to program the `fitImage` containing the ramfs, the kernel and the kernel device tree into the NAND flash:
1. Boot from SD card or QSPI and interrupt the boot process in u-boot by pressing **SPACE**.
2. Setup a tftp-server and load the FIT image (`fitImage`) from the tftp server into RAM. An example is given in the excerpt below:

```shell
Zynq> setenv ipaddr 10.1.10.100
Zynq> setenv serverip 10.1.10.222
Zynq> ping 10.1.10.222
    Using ethernet@e000b000 device
    host 10.1.10.222 is alive

Zynq> tftpboot 0x3000000 fitImage
    Using ethernet@e000b000 device
    TFTP from server 10.1.10.222; our IP address is 10.1.10.100
    Filename 'fitImage'.
    Load address: 0x3000000
    Loading: #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #################################################################
             #######################
             4.2 MiB/s
    done
    Bytes transferred = 11783860 (b3ceb4 hex)
```

3. Switch the storage device to NAND and write the FIT image to NAND.

    > **_Note:_**  NAND flash needs to be erased before writing.

```shell
Zynq> zx_set_storage NAND
    Flash MIO pins configured to NAND mode

Zynq> nand device 0
Zynq> nand erase.part nand-linux
Zynq> nand write 0x3000000 nand-linux 0x2000000
    NAND write: device 0 offset 0x0, size 0x2000000
     33554432 bytes written: OK

```

4. If writing was successful, the NAND memory is persistent and the board can be powercycled. In this example we continue in the active u-boot shell and load the `fitImage` from NAND into RAM.

```shell
Zynq> nand read 0x3000000 nand-linux 0x2000000
    NAND read: device 0 offset 0x2000000, size 0x2000000
     33554432 bytes read: OK
```

5. Boot into the loaded image in RAM.  

```shell
Zynq> bootm 0x3000000
    ## Loading kernel from FIT Image at 03000000 ...
       Using 'conf-system-top.dtb' configuration
       Verifying Hash Integrity ... OK
       Trying 'kernel-1' kernel subimage
         Description:  Linux kernel
         Type:         Kernel Image
         Compression:  uncompressed
         Data Start:   0x030000fc
         Data Size:    3824992 Bytes = 3.6 MiB
         Architecture: ARM
         OS:           Linux
         Load Address: 0x00200000
         Entry Point:  0x00200000
         Hash algo:    sha256
         Hash value:   98a200fa083c2f7227244e50adf76172fddba30a9c11e00e5036bf90de87e0ee
       Verifying Hash Integrity ... sha256+ OK
    ## Loading ramdisk from FIT Image at 03000000 ...
       Using 'conf-system-top.dtb' configuration
    ...

```

> **_NOTE:_** Note that the Vivado Hardware Manager does not support the NAND flash type equipped on Enclustra modules.

## Login on Target

Login with **petalinux** as user name and follow the instructions to create a password.

## Patches

### U-Boot

The following U-Boot patches are added:
- [0008-Enclustra-MAC-address-readout-from-EEPROM.patch](./meta-enclustra-module/recipes-bsp/u-boot/files/common/0008-Enclustra-MAC-address-readout-from-EEPROM.patch)
- [0012-Atsha204a-upstream-fixes.patch](./meta-enclustra-module/recipes-bsp/u-boot/files/common/0012-Atsha204a-upstream-fixes.patch)
- [0050-update-ksz9131-driver.patch](./meta-enclustra-module/recipes-bsp/u-boot/files/common/0050-update-ksz9131-driver.patch)

#### MPSoC (XU* and XZU*)
- [0010-Enclustra-Zynqmp-Board-Patch.patch](./meta-enclustra-module/recipes-bsp/u-boot/files/zynqmp/0010-Enclustra-Zynqmp-Board-Patch.patch)

#### Zynq 7000 (ZX*)
- [0010-Enclustra-Zynq-Board-Patch.patch](./meta-enclustra-module/recipes-bsp/u-boot/files/zynq/0010-Enclustra-Zynq-Board-Patch.patch)

### Linux Kernel

The following Linux kernel patches are added:
- [0001-rtc-zynqmp-Ensure-correct-RTC-calibration.patch](./meta-enclustra-module/recipes-kernel/linux/linux-xlnx/0001-rtc-zynqmp-Ensure-correct-RTC-calibration.patch)
- [0010-atsha204a-read-from-otp.patch](./meta-enclustra-module/recipes-kernel/linux/linux-xlnx/0010-atsha204a-read-from-otp.patch)
- [0011-atsha204a-fixes.patch](./meta-enclustra-module/recipes-kernel/linux/linux-xlnx/0011-atsha204a-fixes.patch)
- [0020-hwmon-add-ir35215.patch](./meta-enclustra-module/recipes-kernel/linux/linux-xlnx/0020-hwmon-add-ir35215.patch)
- [0030-tpm-add-st33ktpm.patch](./meta-enclustra-module/recipes-kernel/linux/linux-xlnx/0030-tpm-add-st33ktpm.patch)

## Additional Information

### Ethernet MAC address configuration

Each Enclustra module is delivered with two unique MAC addresses stored in the EEPROM. During the boot process, these MAC addresses are automatically read by U-Boot and configured to be used by U-Boot and Linux.

### Rootfs Partition Size

The size of the rootfs partition is set to 400 Mbyte by default. To change the partition size, the OpenEmbedded kickstart file ([mmc-image.wks](meta-enclustra-refdes/wic/mmc-image.wks)) needs to be modified. The partition size is defined by the **--fixed-size** parameter as shown below.

```
part --source rootfs --fstype=ext4 --label root --align 4 --fixed-size 400M
```

## Known Issues:

### 1. USB host not working on PE1 base boards

#### Affected modules:
All variants and revisions of the following modules are affected:
- Mercury+ XU1
- Mercury XU5
- Mercury+ XU6
- Mercury+ XU61
- Mercury+ XU7
- Mercury+ XU8
- Mercury+ XU9

#### Description
USB PHY 0 is enabled by default in all reference designs and Linux BSPs but it can not be used in combination with PE1 base boards in host mode. The USB data signals are routed from the module to the USB hub device on the PE1 base board through multiplexers. The `USB_ID` signal controlling one of the multiplexer devices is routed to the USB PHY 1 which affects the signal.

#### Workaround
If USB host mode is required, the Vivado design and Linux devicetree need to be modified to enable USB PHY 1. On some modules USB PHY 1 and ETH 1 share the same MIO pins. Therefore, ETH 1 is not available when using USB 1.

### 2. USB initialization problems with Zynq 7000 modules

#### Affected modules:
All variants and revisions of the following modules are affected:
- Mercury ZX1
- Mercury ZX5
- Mars ZX2
- Mars ZX3

#### Description
There is no dedicated reset for the USB PHY. This can result in failures to initialize the USB interface.

#### Workaround
An FSBL patch can be added to the yocto project as described in this [forum thread](https://adaptivesupport.amd.com/s/question/0D52E00006hpYs7SAE/144-usb-not-working-any-more?language=en_US).