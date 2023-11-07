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

## Deployment

### Image: SD card

Create two partitions on the SD Card (zynqmp)  
 - The first partition should be at least 500 MB in size and formatted as a FAT32 file system
 - The second EXT4

```
$ sudo fdisk /dev/sdc
  -> d <ENTER> (delete existing partitions, in case repeat)
  -> n <ENTER>, <ENTER>, <ENTER>, <ENTER>, +500M <ENTER>
  -> t <ENTER>, c <ENTER>
  -> n <ENTER>, <ENTER>, <ENTER>, <ENTER>, <ENTER>
  -> w <ENTER>
```
NB: in case of being asked to remove existing `windows signatures`, confirm with 'y'  

```
$ sudo mkdosfs -n "BOOT" -F 32 -I /dev/sda1
$ sudo mkfs.ext4 -L "ROOTFS" /dev/sda2
```

Copy the files BOOT.BIN, boot.scr and Image to the first (FAT32) partition   
 - given: we're in ./tmp/deploy/images/refdes-xu6cg-st1-xczu4cg
 - given: the sd card is mounted on /dev/sda1 and will be mounted on /media/pi/BOOT
 - given: a `refdes-xu6cg-st1-xczu4cg` device
```
$ udisksctl mount -b /dev/sda1
$ cd ./build/tmp/deploy/images/refdes-xu6cg-st1-xczu4cg
$ cp -L ./Image/BOOT-*.bin /media/pi/BOOT/BOOT.bin
$ cp -L ./Image /media/pi/BOOT/
$ cp -L ./boot.scr /media/pi/BOOT/
$ udisksctl unmount -b /dev/sda1
```
Extract the file rootfs.tar.gz to the second partition  
 - given: the sd card partition is on /dev/sda2 and will be mounted on /media/pi/ROOTFS
```
$ udisksctl mount -b /dev/sda2
$ sudo tar xzf ./images/linux/rootfs.tar.gz -C /media/pi/ROOTFS/
$ udisksctl unmount -b /dev/sda2
```

plug the SD card, set dip switches to boot from SD card  
```
OFF - OFF - ON - ON
```  
...and boot  
