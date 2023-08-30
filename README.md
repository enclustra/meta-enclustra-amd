# enclustra-petalinux-configs

## Getting started

Prepare an empty petalinux project (according to zynq or zynqMP). Then execute setup with some parameters. Then use petalinux as usual.  

Provide the following arguments for `setup.sh`:  
 - The path to .xsa file, e.g. `/home/..../reference_design/Vivado/ME-XU5-2EG-1I-D11E/Mercury_XU5_ST1.xsa`  
 - The petalinux project name, e.g. `petalinux__ME-XU5-2EG-1I-D11E_ST1__SD`  
 - The yocto machine, e.g. `refdes-xu5-st1` (always starts with "refdes-", followed by `xu#` or `zx#` for the module, then the baseboard family `st1`, `st3`, `pe1`, ...)  
 - The boot mode, e.g. "sd", "qspi", "emmc",...  

```
$ petalinux-create -t project --template "zynqMP" -n "petalinux__ME-XU5-2EG-1I-D11E_ST1__SD"
$ cd ./petalinux__ME-XU5-2EG-1I-D11E_ST1__SD
$ ./setup.sh  /home/.../0000__reference-design/Mercury_XU5_ST1.xsa  petalinux__ME-XU5-2EG-1I-D11E_ST1__SD  refdes-xu5-st1  sd
```

## Convert Petalinux Project into a Xilinx Yocto Project
```
$ ./petalinux-convert.sh
```
Build the yocto image with bitbake  
```
$ source ./enclustra-init-build-env
$ bitbake enclustra-image-minimal
```
NB: This is only a starting point for yocto based projects. Please, refer to the official yocto documentation for how to customize or build up your yocto project.  

## Export Petalinux Project into Xilinx Yocto Project (ported AMD approach)
```
## fetch orig yocto layering via repo (I'm doing yocto.orig as backup for safety)
$ mkdir yocto.orig
$ cd yocto.orig
$ repo init -u https://github.com/Xilinx/yocto-manifests.git -b rel-v2023.1
$ repo sync
$ chmod a+wx setupsdk
$ cd ..

## move the script outside the folder and export (separate) petalinux project as follows
$ cp ./petalinux__ME-XU5-2EG-1I-D11E_ST1__SD/export-petalinux.sh .
$ ./export-petalinux.sh ./petalinux__ME-XU5-2EG-1I-D11E_ST1__SD

## prepare a yocto/sources folder (copy it from somewhere or clone via 'repo')
$ cp -arf ./yocto.orig ./yocto
$ chmod a+wx ./yocto/setupsdk

## import petalinux.run package
$ ./plnx-yocto-migrate.run ./yocto

## source setup sdk
$ cd ./yocto
$ PLNX_SETUP=1 source setupsdk

## build use bitbake to build enclustra images
$ bitbake enclustra-image-sd

## or build the xilinx default image
$ bitbake petalinux-image-minimal
```
