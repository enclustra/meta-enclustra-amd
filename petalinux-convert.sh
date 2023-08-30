#!/bin/sh -e
##
## The script implements a conversion of petalinux setup into a
## bitbake driven yocto setup.
##
## author: Lothar Rubusch <lothar.rubusch@enclustra.com>

die()
{
	echo "ABORTED! $@"
	exit 255
}

## MAIN
PROOT="$( readlink -f $( dirname ${0} ) )" || die "link '$0' is not accessible"
test ! -d $PROOT/.petalinux && die "specified Petalinux project path not proper/corrupted"

## create directory structure
cd $PROOT

## folder: sources
mv components/yocto/layers sources
mkdir -p sources/yocto-scripts
cp -a ./enclustra/enclustra-init-build-env ./

## folder: sources/meta-enclustra
PROJECT_DATA="$PROOT/sources/meta-enclustra"
mkdir -p $PROJECT_DATA/project-spec
cp -arf $PROOT/project-spec/configs $PROJECT_DATA/project-spec/
cp -arf $PROOT/project-spec/meta-* ${PROOT}/sources/

## system.bit
mkdir -p $PROJECT_DATA/project-spec/hw-description
find $PROOT/project-spec/hw-description/ -regex '.*\.\(pdi\|bit\|xsa\)$' -exec cp -af {} $PROJECT_DATA/project-spec/hw-description/ \;

## machines
if [ -d ${PROOT}/build/conf/machine ]; then
	cp -arf ${PROOT}/build/conf/machine ${PROJECT_DATA}/project-spec/

        ## fix HDF_PATH in machines
        sed -i "\|^HDF_PATH = |s|.*|HDF_PATH = \"\${ENCLUSTRA_SOURCE_DIR}/project-spec/hw-description/system.xsa\"|" ${PROJECT_DATA}/project-spec/machine/*
fi

## plnxtool.conf
cp -a ${PROOT}/build/conf/plnxtool.conf $PROJECT_DATA/project-spec/plnxtool.conf.sample
sed -i  -e '/TMPDIR/d' \
	-e '/XILINX_SDK_TOOLCHAIN/d' \
	-e '/UNINATIVE_URL/d' \
	-e '/USE_XSCT_TARBALL/d' \
	-e '/XSCTH_WS_pn-device-tree/d'  $PROJECT_DATA/project-spec/plnxtool.conf.sample

BITSTREAM_FILE="$(ls -1 $PROJECT_DATA/project-spec/hw-description/ | grep "\.bit$")"
sed -i "\|^EXTRA_FILESLIST:append = |s|.*|EXTRA_FILESLIST:append = \" \${ENCLUSTRA_SOURCE_DIR}/project-spec/configs/config:config \${ENCLUSTRA_SOURCE_DIR}/project-spec/hw-description/${BITSTREAM_FILE}:system.bit\"|" ${PROJECT_DATA}/project-spec/plnxtool.conf.sample
sed -i "\|^SYSCONFIG_DIR =|s|.*|SYSCONFIG_DIR = \"\${ENCLUSTRA_SOURCE_DIR}/project-spec/configs\"|" $PROJECT_DATA/project-spec/plnxtool.conf.sample
echo "'${PROJECT_DATA}/project-spec/plnxtool.conf.sample' adjusted"

## bblayers.conf
cp -af $PROOT/build/conf/bblayers.conf $PROJECT_DATA/project-spec/bblayers.conf.sample
sed -i "s|.*/project-spec|  \${SDKBASEMETAPATH}/sources|g" $PROJECT_DATA/project-spec/bblayers.conf.sample
sed -i "\|^SDKBASEMETAPATH = \"|s|.*|SDKBASEMETAPATH := \"\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '/../..')}\"|"  $PROJECT_DATA/project-spec/bblayers.conf.sample
sed -i "\|components/yocto/workspace|d"  $PROJECT_DATA/project-spec/bblayers.conf.sample
sed -i "s|/layers/|/sources/|g" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
sed -i "s|/core/|/poky/|g" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
sed -i "\|meta-clang|d" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
sed -i "\|meta-chromium|d" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
sed -i "\|meta-xilinx-pynq|d" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
sed -i "\|meta-vitis|d" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
sed -i "\|meta-python2|d" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
sed -i "\|meta-som|d" ${PROJECT_DATA}/project-spec/bblayers.conf.sample
echo "'${PROJECT_DATA}/project-spec/bblayers.conf.sample' adjusted"

## enclustra.inc
SCRIPT_ROOT="../../"
cp -af $PROOT/build/conf/enclustra.inc $PROJECT_DATA/project-spec/
echo "PROOT := \"\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '$SCRIPT_ROOT/sources/meta-enclustra')}\"" >> $PROJECT_DATA/project-spec/enclustra.inc
echo "'$PROJECT_DATA/project-spec/enclustra.inc' adjusted"

## init-build-env script
sed -i "\|export ENCLUSTRA_SOURCE_DIR=|s|@@TODO@@|$PROOT/sources/meta-enclustra|" $PROOT/enclustra-init-build-env

## remove artifact of petalinux setup
rm -rf $PROOT/build
rm -rf $PROOT/components
rm -rf $PROOT/enclustra
rm -rf $PROOT/project-spec
echo "petalinux artifacts removed"

echo
echo "now, enter the bitbake environment:"
echo "$ source ./enclustra-init-build-env"
echo "READY."
