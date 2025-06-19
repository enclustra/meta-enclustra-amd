#!/usr/bin/bash -e
## e.g. $0 ~/workspace/0000__yocto/binaries_AM-XZU90-19EG-2I-D12E_PE5.zip sd refdes-xzu90-pe5
die() { echo $@ ; exit 1; }
usage() { printf "usage:\n$0 <path to binaries.zip> <bootmode: sd|emmc|qspi> <MACHINE>\n"; die "failed"; }
(( $# != 3 )) && usage

append2localconf() {
	VAR=$1
	CONTENT=$2
	SUFFIX=$3
	LOCALCONF="${BUILDDIR}/conf/local.conf"
	
	# Check if the entry is already present in local.conf
	if grep -qE "^${VAR}${SUFFIX}.*\".*${CONTENT}.*\"" "$LOCALCONF"; then
		echo "Entry for ${VAR}${SUFFIX} with content '${CONTENT}' already exists in local.conf"
		return
	fi

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
TOPDIR=$( cd $SCRIPTDIR; pwd )
cd $TOPDIR

BINARIES_ZIP="$( cd $(dirname $1); pwd )/$(basename $1)"
BOOTMODE="$2"
MACHINE="$3"
PRODUCTMODEL=$(basename "$1" .zip | awk -F'_' '{print $2}')
BASEBOARD=$(basename "$1" .zip | awk -F'_' '{print $3}')
BUILDDIR="${TOPDIR}/${PRODUCTMODEL}-${BASEBOARD}-${BOOTMODE}"

echo "TOPDIR: $TOPDIR"
echo "BUILDDIR: $BUILDDIR"
echo "BINARIES_ZIP: $BINARIES_ZIP"
echo "BOOTMODE: $BOOTMODE"
echo "MACHINE: $MACHINE"
echo "PRODUCTMODEL: $PRODUCTMODEL"
echo "BASEBOARD: $BASEBOARD"


## if not around, fetch basic layer setup
if [ ! -d "${TOPDIR}/sources" ]; then
	which repo | awk -v c=1 '/repo/{c=0}; END{exit c}' || die "FAILED! 'repo' tool is not installed (https://gerrit.googlesource.com/git-repo)!"
	repo init -u "https://github.com/Xilinx/yocto-manifests.git" -b "rel-v2024.2"
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
. ./setupsdk "${BUILDDIR}"

# add enclustra meta-layers
append2layers "$TOPDIR/meta-enclustra-module"
append2layers "$TOPDIR/meta-enclustra-baseboard"
append2layers "$TOPDIR/meta-enclustra-lab"

## run gen-machineconf
# setting require-machine and machine-name to the same value ensures that the FPGA device id (like xczu5ev) is included in the generated config
# this in turn allows the correct require machine conf to be deducted in the meta-enclustra-module layer
${TOPDIR}/sources/meta-xilinx/meta-xilinx-core/gen-machine-conf/gen-machineconf parse-xsa \
	--hw-description ${TOPDIR}/${BINARIES}/*.xsa \
	--require-machine "${MACHINE}" \
	--machine-overrides "enclustra-${BOOTMODE}" \
	--machine-name "${MACHINE}"\
	--debug

# Get the name of the generated machine from the machine conf file name
CONF_FILE=$(find "${BUILDDIR}/conf/machine/" -name "${MACHINE}*.conf" | head -n 1)
if [ -n "$CONF_FILE" ]; then
	MACHINE_FINAL=$(basename "${CONF_FILE}" .conf)
	echo "MACHINE_FINAL: $MACHINE_FINAL"
else
	echo "MACHINE_FINAL not found in ${BUILDDIR}/conf/machine/."
	die
fi

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
if [[ "$MACHINE_FINAL" == *"-xzu"* || "$MACHINE_FINAL" == *"-xu"* ]]; then
	append2localconf "IMAGE_INSTALL" "libdfx" ":append"
fi
append2localconf "IMAGE_INSTALL" "udev-extraconf" ":append"
append2localconf "IMAGE_INSTALL" "linux-xlnx-udev-rules" ":append"
append2localconf "IMAGE_INSTALL" "packagegroup-core-boot" ":append"
append2localconf "IMAGE_INSTALL" "tcf-agent" ":append"
append2localconf "IMAGE_INSTALL" "bridge-utils" ":append"
append2localconf "IMAGE_INSTALL" "dosfstools" ":append"
append2localconf "IMAGE_INSTALL" "resize-part" ":append"
append2localconf "IMAGE_INSTALL" "u-boot-tools" ":append"
append2localconf "IMAGE_INSTALL" "iperf3" ":append"
append2localconf "IMAGE_INSTALL" "memtester" ":append"
append2localconf "IMAGE_INSTALL" "phytool" ":append"
if [[ "$MACHINE_FINAL" == *"-zx"* ]]; then
	append2localconf "INIT_MANAGER_DEFAULT" "systemd"
fi

printf "now build:\n$ . ./sources/poky/oe-init-build-env ${BUILDDIR}\n$ bitbake petalinux-image-minimal\n"
echo "READY."
