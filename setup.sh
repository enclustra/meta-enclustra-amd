#!/bin/bash -e
## setup script for petalinux 2023.1
## apply provided .cfg config fragments to project
## apply provided .cfg config fragments to rootfs

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

	test -z "$OPT_RAW" && return
	test -z "$OPT_SET" && return

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
		sed -i "\|${OPT_CONFIG}|s|.*|${OPT_SET}|"  "$CONFIG_FILE" &> /dev/null
		grep $OPT_CONFIG -HIrn --color $CONFIG_FILE
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
		*-xu6-*) ;&
		*-xu61-*) ;&
		*-xu6cg-*) ;&
		*-xu8-*) ;&
		*-xu9-*) MACHINE_PARENT_TYPE="zynqMP" ;;
		*) die "setup.sh: MACHINE_PARENT_TYPE: MACHINE '$MACHINE' cannot be parsed" ;;
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

## petalinux-config - basics, project name and yocto MACHINE...
CONFIG_PETALINUX=(
    "CONFIG_SUBSYSTEM_HOSTNAME=\"${PETALINUX_PROJECT_NAME}\""
    "CONFIG_SUBSYSTEM_PRODUCT=\"${PETALINUX_PROJECT_NAME}\""
	# Changes derived MACHINE name
    "CONFIG_YOCTO_MACHINE_NAME=\"${MACHINE}\""
	# Adds MACHINE name to overrides
    "CONFIG_YOCTO_INCLUDE_MACHINE_NAME=\"${MACHINE}\""
	"CONFIG_YOCTO_ADD_OVERRIDES=\"enclustra-${BOOTMODE}\""
    'CONFIG_USER_LAYER_0="${PROOT}/project-spec/meta-enclustra/meta-enclustra-baseboard"'
    'CONFIG_USER_LAYER_1="${PROOT}/project-spec/meta-enclustra/meta-enclustra-module"'
	# Add bootarg so that Linux does not disable clocks exported from PS to PL
	'CONFIG_SUBSYSTEM_EXTRA_BOOTARGS="clk_ignore_unused"'
)

## identify MACHINE_PARENT_TYPE: zynq or zynqMP
identify_machine_parent

## petalinux-config - read and append config fragments according to boot mode
## NB: for the read-approach the .cfg file must have a final empty line/EOF, if not the last option will be omitted (fix this?)
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
echo "======================================= Apply petalinux project configs ========================================"
for ((idx = 0; idx < ${#CONFIG_PETALINUX[@]}; idx++)); do
	apply_cfg_fragment "${CONFIG_PETALINUX[$idx]}" "./project-spec/configs/config"
done

## rootfs-config - basics go here
CONFIG_ROOTFS=(
)

## rootfs-config - read and append config fragments according to boot mode
echo "======================================= Apply petalinux rootfs configs ========================================"
cd "${PETALINUXDIR}"
if [ -e "./enclustra/${MACHINE_PARENT_TYPE}/rootfs.cfg" ]; then
	OLDIFS="$IFS"
	IFS=$'\n'
	while read line; do
		CONFIG_ROOTFS=( ${CONFIG_ROOTFS[*]} "$line" )
	done < ./enclustra/${MACHINE_PARENT_TYPE}/rootfs.cfg ## NEVER use quotes here!
	IFS="$OLDIFS"
fi

## rootfs-config - apply configs
for ((idx = 0; idx < ${#CONFIG_ROOTFS[@]}; idx++)); do
	apply_cfg_fragment "${CONFIG_ROOTFS[$idx]}" "./project-spec/configs/rootfs_config"
done

cd "${PETALINUXDIR}"
petalinux-config --silentconfig

rm -v ./setup.sh
echo "READY."
