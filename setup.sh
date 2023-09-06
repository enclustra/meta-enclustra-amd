#!/bin/bash -xe
## setup script for petalinux 2023.1
##
## expects an existing pre-configured petalinux project

die()
{
	echo "ABORTED! $@"
	exit 0
}

apply_cfg_fragment()
{
    OPT_RAW="${1}"      ## arg1: config option
    OPT_SET="$OPT_RAW"
    CONFIG_FILE="${2}"  ## arg2: config file

    ## option set or disabled?
    DO_DISABLED="$( echo ${OPT_RAW} | grep "^# " )" || true
    if [ -n "$DO_DISABLED" ]; then
        OPT_CONFIG="$( echo $OPT_RAW | awk '{print $2}' )"
    else
        OPT_CONFIG="$( echo $OPT_RAW | awk -F'=' '{print $1}' )"
    fi

    ## replace or append option?
    DO_REPLACE="$( grep "$OPT_CONFIG" -r $CONFIG_FILE )" || true
    if [ -n "$DO_REPLACE" ]; then
        sed -i "\|${OPT_CONFIG}|s|.*|${OPT_SET}|"  "$CONFIG_FILE"
    else
        echo "$OPT_SET" >> "$CONFIG_FILE"
    fi
}

identify_machine_parent()
{
    ## MACHINE base type, needed for initial petalinux setup
    case ${MACHINE} in
	*-zx1-*) ;&
	*-zx2-*) ;&
	*-zx3-*)  MACHINE_PARENT_TYPE="zynq" ;;

	*-xu1-*) ;&
	*-xu3-*) ;&
	*-xu5-*) ;&
	*-xu8-*) ;&
	*-xu9-*) MACHINE_PARENT_TYPE="zynqMP" ;;

        *) die "MACHINE_PARENT_TYPE: MACHINE '$MACHINE' cannot be parsed" ;;
    esac
}

## MAIN

test $# -ne 4 && die "usage: ${0} <RESOURCEDIR_XSA=> <PETALINUX_PROJECT_NAME> <MACHINE>"
RESOURCEDIR_XSA="$( readlink -f ${1} )" || die "path to .xsa not found!"
PETALINUX_PROJECT_NAME="${2}"
MACHINE="${3}"
BOOTMODE="${4}"

## data
PETALINUXDIR="$( readlink -f $( dirname ${0} ) )"

cd "${PETALINUXDIR}"
petalinux-config --get-hw-description="${RESOURCEDIR_XSA}" --silentconfig

## TODO rm - personal setting for development, rm for productive usage        
RESOURCEDIR=~/"workspace/0000__petalinux"
if [ -e "${RESOURCEDIR}/sstate-cache" ]; then
	cd "${PETALINUXDIR}/build/"
	ln -sf "${RESOURCEDIR}/sstate-cache" .
fi
if [ -e "${RESOURCEDIR}/downloads" ]; then
	cd "${PETALINUXDIR}/build/"
	ln -sf "${RESOURCEDIR}/downloads" .
fi

## petalinux-config - basics, project name and yocto MACHINE...
CONFIG_PETALINUX=(
    "CONFIG_SUBSYSTEM_HOSTNAME=\"${PETALINUX_PROJECT_NAME}\""
    "CONFIG_SUBSYSTEM_PRODUCT=\"${PETALINUX_PROJECT_NAME}\""
    "CONFIG_YOCTO_MACHINE_NAME=\"${MACHINE}\""
    'CONFIG_USER_LAYER_0="${PROOT}/project-spec/meta-enclustra/meta-enclustra_baseboard"'
    'CONFIG_USER_LAYER_1="${PROOT}/project-spec/meta-enclustra/meta-enclustra_module"'
)

## identify MACHINE_PARENT_TYPE: zynq or zynqMP
identify_machine_parent

## petalinux-config - read and append config fragments according to boot mode
cd "${PETALINUXDIR}"
if [ -e "./enclustra/${MACHINE_PARENT_TYPE}/petalinux-${BOOTMODE}.cfg" ]; then
    OLDIFS="$IFS"
    IFS=$'\n'
    while read line; do
        CONFIG_PETALINUX=( ${CONFIG_PETALINUX[*]} "$line" )
    done < ./enclustra/${MACHINE_PARENT_TYPE}/petalinux-${BOOTMODE}.cfg ## NEVER use quotes here!
    IFS="$OLDIFS"
fi

## petalinux-config - apply configs
for ((idx = 0; idx < ${#CONFIG_PETALINUX[@]}; idx++)); do
    apply_cfg_fragment "${CONFIG_PETALINUX[$idx]}" "./project-spec/configs/config"
done

## rootfs-config - basics go here
CONFIG_ROOTFS=(
)

## rootfs-config - read and append config fragments according to boot mode
cd "${PETALINUXDIR}"
if [ -e "./enclustra/${MACHINE_PARENT_TYPE}/rootfs-${BOOTMODE}.cfg" ]; then
    OLDIFS="$IFS"
    IFS=$'\n'
    while read line; do
        CONFIG_ROOTFS=( ${CONFIG_ROOTFS[*]} "$line" )
    done < ./enclustra/${MACHINE_PARENT_TYPE}/petalinux-${BOOTMODE}.cfg ## NEVER use quotes here!
    IFS="$OLDIFS"
fi

## rootfs-config - apply configs
for ((idx = 0; idx < ${#CONFIG_ROOTFS[@]}; idx++)); do
    apply_cfg_fragment "${CONFIG_ROOTFS[$idx]}" "./project-spec/configs/rootfs_config"
done

## fix: provide MACHINE for petalinux setup (has to be in .conf file
## and not in a .bb such as e.g. the image.bb)
cd "${PETALINUXDIR}"
MACHINEOVERRIDE="enclustra-${BOOTMODE}"
echo "MACHINEOVERRIDES =. \"${MACHINEOVERRIDE}:\"" > ./build/conf/enclustra.inc

if [ -z "$(grep "require conf/enclustra.inc" -r ./build/conf/local.conf)" ]; then
    echo "require conf/enclustra.inc" >> ./build/conf/local.conf
fi

## fix: remove petalinux warning about locked signatures,
## this is handled by peta TCL code, thus can't be overloaded in meta layers
cd "${PETALINUXDIR}"
echo 'SIGGEN_UNLOCKED_RECIPES += "qemu-xilinx-system-native"' >> ./project-spec/meta-user/conf/petalinuxbsp.conf
echo 'SIGGEN_UNLOCKED_RECIPES += "busybox"' >> ./project-spec/meta-user/conf/petalinuxbsp.conf

cd "${PETALINUXDIR}"
petalinux-config --silentconfig

if [ -z "$( grep "include conf/petalinuxbsp.conf" -r ./build/conf/local.conf )" ]; then
    echo "include conf/petalinuxbsp.conf" >> ./build/conf/local.conf
fi

rm -v ./setup.sh
echo "READY."
