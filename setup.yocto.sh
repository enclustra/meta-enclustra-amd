#!/usr/bin/bash -e
## e.g. $0 ~/workspace/0000__yocto/binaries_AM-XZU90-19EG-2I-D12E_PE5.zip sd refdes-xzu90-pe5
die() { echo $@ ; exit 1; }
usage() { printf "usage:\n$0 <path to binaries.zip> <bootmode: sd|emmc|qspi> <MACHINE>\n"; die "failed"; }
(( $# != 3 )) && usage

append2localconf() {
	VAR=$1
	CONTENT=$2
	SUFFIX=$3
	LOCALCONF="$TOPDIR/build/conf/local.conf"
	
	RES=$( bitbake-getvar ${VAR} | grep -v "^\(#\|NOTE\)" ) || true
	if [ -z "$( echo $RES | awk '/("|\s)$CONTENT("|\s)/{print}' )" ]; then
		if [ -n "$SUFFIX" ]; then
			echo "$VAR$SUFFIX = \" $CONTENT\"" >> "$LOCALCONF"
		else
			echo "$VAR" = \"$CONTENT\" >> "$LOCALCONF"
		fi
	fi
}

append2layers()
{
	LAYERPATH="$1"
	LAYER=$(basename $LAYERPATH)
	if [ -z "$( bitbake-layers show-layers | grep "$LAYER" )" ]; then
		bitbake-layers add-layer "$LAYERPATH"
	fi
}

SCRIPTDIR=$( dirname $0 )
TOPDIR=$( readlink -e $SCRIPTDIR/.. )
cd $TOPDIR

BINARIES_ZIP=$1
BOOTMODE="$2"
MACHINE="$3"
MACHINE_FINAL="${MACHINE}-final"
ENCLUSTRA_LAYERS="$TOPDIR/meta-enclustra-configs/project-spec/meta-enclustra"

which xsct | awk -v c=1 '/xsct/{c=0}; END{exit c}' || die "FAILED! 'xsct' not in env!"

## if not around, fetch basic layer setup
if [ ! -d "$TOPDIR/sources" ]; then
	which repo | awk -v c=1 '/repo/{c=0}; END{exit c}' || die "FAILED! 'repo' tool is not installed (https://gerrit.googlesource.com/git-repo)!"
	repo init -u "https://github.com/Xilinx/yocto-manifests.git" -b "rel-v2024.1"
	repo sync
fi

## import XSA
BINARIES=$(echo $BINARIES_ZIP | awk -F/ '{gsub(".(zip|ZIP)$","",$NF); print $NF}')
if [ ! -d "$TOPDIR/$BINARIES" ]; then
	test -f "$BINARIES_ZIP" || die "path to binaries zip: '$BINARIES_ZIP' is invalid"
	mkdir $TOPDIR/$BINARIES
	cd $TOPDIR/$BINARIES
	unzip $BINARIES_ZIP
	cd $TOPDIR
fi

## this changes into ./build
. ./setupsdk ""

## is setup XSA capable?
test -f $ENCLUSTRA_LAYERS/meta-enclustra-baseboard/recipes-bsp/hdf/external-hdf.bbappend || die "FAILED! no external-hdf recipe (XSA)"
test -f $ENCLUSTRA_LAYERS/meta-enclustra-baseboard/recipes-bsp/platform-init/platform-init.bbappend || die "FAILED! no platform init (XSA)"

## add enclustra meta-layers
append2layers "$TOPDIR/meta-enclustra-configs/project-spec/meta-enclustra/meta-enclustra-module"
append2layers "$TOPDIR/meta-enclustra-configs/project-spec/meta-enclustra/meta-enclustra-baseboard"

## run gen-machineconf
$TOPDIR/sources/meta-xilinx/meta-xilinx-core/gen-machine-conf/gen-machineconf \
	--hw-description $TOPDIR/$BINARIES/*.xsa \
	--xsct-tool "$TOPDIR/sources/meta-xilinx-tools/recipes-utils/xsct" \
	--require-machine "$MACHINE" \
	--add-rootfsconfig "$TOPDIR/meta-enclustra-configs/enclustra/common/rootfs.cfg" \
	--add-config "$TOPDIR/meta-enclustra-configs/enclustra/zynqMP/petalinux-sd.cfg" \
	--machine-overrides "\":enclustra-${BOOTMODE}\"" \
	--machine-name "$MACHINE_FINAL"

## adjust generated machine
append2localconf "MACHINE" "$MACHINE_FINAL"
append2localconf "IMAGE_FSTYPES" "wic" ":append"
append2localconf "IMAGE_FSTYPES" "wic.bmap" ":append"
append2localconf "KERNEL_CLASSES" "kernel-fitimage" ":append"
append2localconf "KERNEL_IMAGETYPES" "fitImage" ":append"
append2localconf "IMAGE_INSTALL" "kernel-modules" ":append"
append2localconf "IMAGE_INSTALL" "e2fsprogs-mke2fs" ":append"
append2localconf "IMAGE_INSTALL" "fpga-manager-script" ":append"
append2localconf "IMAGE_INSTALL" "haveged" ":append"
append2localconf "IMAGE_INSTALL" "i2c-tools" ":append"
append2localconf "IMAGE_INSTALL" "mtd-utils" ":append"
append2localconf "IMAGE_INSTALL" "usbutils" ":append"
append2localconf "IMAGE_INSTALL" "can-utils" ":append"
append2localconf "IMAGE_INSTALL" "hdparm" ":append"
append2localconf "IMAGE_INSTALL" "pciutils" ":append"
append2localconf "IMAGE_INSTALL" "strace" ":append"
append2localconf "IMAGE_INSTALL" "sysstat" ":append"
append2localconf "IMAGE_INSTALL" "run-postinsts" ":append"
append2localconf "IMAGE_INSTALL" "libdfx" ":append"
append2localconf "IMAGE_INSTALL" "udev-extraconf" ":append"
append2localconf "IMAGE_INSTALL" "linux-xlnx-udev-rules" ":append"
append2localconf "IMAGE_INSTALL" "packagegroup-core-boot" ":append"
append2localconf "IMAGE_INSTALL" "tcf-agent" ":append"
append2localconf "IMAGE_INSTALL" "bridge-utils" ":append"
append2localconf "IMAGE_INSTALL" "hellopm" ":append"
append2localconf "IMAGE_INSTALL" "dosfstools" ":append"
append2localconf "IMAGE_INSTALL" "resize-part" ":append"
append2localconf "IMAGE_INSTALL" "u-boot-tools" ":append"
append2localconf "IMAGE_INSTALL" "packagegroup-petalinux-display-debug"  ":append"
append2localconf "IMAGE_INSTALL" "iperf3" ":append"
append2localconf "IMAGE_INSTALL" "memtester" ":append"
append2localconf "IMAGE_INSTALL" "phytool" ":append"

printf "now build:\n$ . ./sources/poky/oe-init-build-env\n$ bitbake petalinux-image-minimal\n"
echo "READY."
