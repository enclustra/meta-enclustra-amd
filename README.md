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
``
