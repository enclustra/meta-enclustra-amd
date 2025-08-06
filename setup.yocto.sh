#!/usr/bin/bash -e
## e.g. $0 ~/workspace/0000__yocto/binaries_AM-XZU90-19EG-2I-D12E_PE5.zip sd refdes-xzu90-pe5
##      or: $0 ~/workspace/0000__yocto/AM-XZU90-19EG-2I-D12E_PE5.xsa sd refdes-xzu90-pe5
die() { echo "$@" ; exit 1; }
usage() { printf "usage:\n%s <path to binaries.zip or .xsa> <bootmode: sd|emmc|qspi> <MACHINE>\n" "$0"; die "failed"; }
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

	RES=$( bitbake-getvar "${VAR}" | grep -v "^\(#\|NOTE\)" ) || true
	if [ -z "$( echo "${RES}" | awk '/("|\s)$CONTENT("|\s)/{print}' )" ]; then
		if [ -n "${SUFFIX}" ]; then
			echo "${VAR}${SUFFIX} = \" ${CONTENT}\"" >> "${LOCALCONF}"
		else
			echo "${VAR} = \"${CONTENT}\"" >> "${LOCALCONF}"
		fi
	fi
}

append2layers()
{
	LAYERPATH="$1"
	LAYER=$(basename "${LAYERPATH}")
	if [ -z "$(bitbake-layers show-layers | grep "${LAYER}" )" ]; then
		bitbake-layers add-layer "${LAYERPATH}"
	fi
}

SCRIPTDIR=$( dirname "$0" )
TOPDIR=$( cd "${SCRIPTDIR}"; pwd )
cd "${TOPDIR}"

# Handle .zip or .xsa input
INPUT="$( cd "$(dirname "$1")"; pwd )/$(basename "$1")"
BOOTMODE="$2"
MACHINE="$3"

case "${INPUT,,}" in
	*.zip)
		MODE=zip
		PRODUCTMODEL=$(basename "${INPUT}" .zip | awk -F'_' '{print $2}')
		BASEBOARD=$(basename "${INPUT}" .zip | awk -F'_' '{print $3}')
		BINARIES=$(echo "${INPUT}" | awk -F/ '{gsub(".(zip|ZIP)$","",$NF); print $NF}')
		echo "BINARIES: ${BINARIES}"
		;;
	*.xsa)
		MODE=xsa
		PRODUCTMODEL=$(basename "${INPUT}" .xsa | awk -F'_' '{print $2}')
		BASEBOARD=$(basename "${INPUT}" .xsa | awk -F'_' '{print $3}')
		;;
	*)
		usage
		;;
esac

BUILDDIR="${TOPDIR}/${PRODUCTMODEL}-${BASEBOARD}-${BOOTMODE}"

echo "TOPDIR: ${TOPDIR}"
echo "BUILDDIR: ${BUILDDIR}"
echo "INPUT: ${INPUT}"
echo "BOOTMODE: ${BOOTMODE}"
echo "MACHINE: ${MACHINE}"
echo "PRODUCTMODEL: ${PRODUCTMODEL}"
echo "BASEBOARD: ${BASEBOARD}"

## if not around, fetch basic layer setup
if [ ! -d "${TOPDIR}/sources" ]; then
	which repo | awk -v c=1 '/repo/{c=0}; END{exit c}' || die "FAILED! 'repo' tool is not installed (https://gerrit.googlesource.com/git-repo)!"
	repo init -u "https://github.com/Xilinx/yocto-manifests.git" -b "rel-v2024.2"
	repo sync
fi

## import XSA
if [ "${MODE}" = zip ]; then
	BINARIES_ZIP="${INPUT}"
	if [ ! -d "${TOPDIR}/${BINARIES}" ]; then
		test -f "${BINARIES_ZIP}" || die "path to binaries zip: '${BINARIES_ZIP}' is invalid"
		mkdir "${TOPDIR}/${BINARIES}"
		cd "${TOPDIR}/${BINARIES}"
		unzip "${BINARIES_ZIP}"
		cd "${TOPDIR}"
	fi
	HW_DESCRIPTION=$(find "${TOPDIR}/${BINARIES}/" -type f -name "*.xsa")
else
	HW_DESCRIPTION="${INPUT}"
fi

echo "HW_DESCRIPTION: ${HW_DESCRIPTION}"

## this changes into ./build
. ./setupsdk "${BUILDDIR}"

# add enclustra meta-layers
append2layers "${TOPDIR}/meta-enclustra-module"
append2layers "${TOPDIR}/meta-enclustra-baseboard"
if [ -d "${TOPDIR}/meta-enclustra-lab" ]; then
	append2layers "${TOPDIR}/meta-enclustra-lab"
fi

## run gen-machineconf
# setting require-machine and machine-name to the same value ensures that the FPGA device id (like xczu5ev) is included in the generated config
# this in turn allows the correct require machine conf to be deducted in the meta-enclustra-module layer using the SOC_VARIANT variable
"${TOPDIR}"/sources/meta-xilinx/meta-xilinx-core/gen-machine-conf/gen-machineconf parse-xsa \
	--hw-description "${HW_DESCRIPTION}" \
	--require-machine "${MACHINE}" \
	--machine-overrides "enclustra-${BOOTMODE}" \
	--machine-name "${MACHINE}"

# Get the name of the generated machine from the machine conf file name
CONF_FILE=$(find "${BUILDDIR}/conf/machine/" -name "${MACHINE}*.conf" | head -n 1)
if [ -n "${CONF_FILE}" ]; then
	MACHINE_FINAL=$(basename "${CONF_FILE}" .conf)
	echo "MACHINE_FINAL: ${MACHINE_FINAL}"
else
	echo "MACHINE_FINAL not found in ${BUILDDIR}/conf/machine/."
	die
fi

## adjust generated machine
append2localconf "MACHINE" "${MACHINE_FINAL}"

printf "now build:\n$ . ./sources/poky/oe-init-build-env %s\n$ bitbake petalinux-image-minimal\n" "${BUILDDIR}"
echo "READY."
