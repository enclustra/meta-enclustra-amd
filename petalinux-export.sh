#!/bin/bash -e
##
##* © Copyright (C) 2016-2020 Xilinx, Inc
##*
##* Licensed under the Apache License, Version 2.0 (the "License"). You may
##* not use this file except in compliance with the License. A copy of the
##* License is located at
##*
##*     http://www.apache.org/licenses/LICENSE-2.0
##*
##* Unless required by applicable law or agreed to in writing, software
##* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
##* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
##* License for the specific language governing permissions and limitations
##* under the License.
##
## Extended Migration Script
##
## creates a .run file, i.e. a generated shell script with a concatenated tar.gz
## containing the metalayers and configs (all text files) of the original
## petalinux setup
##
## the generated script will add the metalayers to the yocto project
##
## Author: Lothar Rubusch <lothar.rubusch@enclustra.com>
##*/

#**************************************************************
die()
{
	echo "ABORTED! $@"
	exit 255
}

create_runfile()
{
	local tarfile="${1}"
	local runfile="${2}"

	cat > ${runfile} <<EOF
#!/bin/bash -e

CLEANUP_FILES=""
trap do_cleanup INT TERM ABRT KILL HUP QUIT SEGV EXIT

die()
{
	echo "ABORTED! \$@"
	exit 1
}

add_file_cleanup ()
{
        CLEANUP_FILES="\${CLEANUP_FILES} \$*"
}

do_cleanup ()
{
        if [ -n "\${CLEANUP_FILES}" ]; then
                rm -rf \${CLEANUP_FILES} > /dev/null 2>&1
        fi
}

#[ -z \${1} ] && echo "Specify the Yocto SDK directory path: \${0} <YOCTO SDK>" && exit 255
test -z \${1} && die "Specify the Yocto SDK directory path: \${0} <YOCTO SDK>"

YOCTO_SDK=\$(readlink -f \${1})
RUNFILE=\$(readlink -f \${0})
if [ ! -d "\${YOCTO_SDK}/sources" ] || [ ! -f "\${YOCTO_SDK}/setupsdk" ]; then
   die "Specified Yocto SDK was not proper/corrupted"
fi

SKIP=\$(awk '/^##__PLNX_SDK__/ { print NR + 1; exit 0; }' "\${RUNFILE}")
tail -n +\$SKIP "\${RUNFILE}" > /tmp/yocto-migrate
add_file_cleanup /tmp/yocto-migrate

tar -xzf /tmp/yocto-migrate -C "\${YOCTO_SDK}/sources/" || die "untar failed"

sed -i "s|@@PROOT@@|\${YOCTO_SDK}/sources/petalinux|g" "\${YOCTO_SDK}/sources/petalinux/plnxtool.conf"

## DEBUG
#cp "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample.orig"
#sed -i "s|\\\${PROOT}|\\\${SDKBASEMETAPATH}/sources/petalinux|g" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"
sed -i "s|/layers/|/sources/|g" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"
sed -i "s|/core/|/poky/|g" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"

sed -i "/meta-clang/d" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"
sed -i "/meta-chromium/d" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"
sed -i "/meta-xilinx-pynq/d" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"
sed -i "/meta-vitis/d" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"
sed -i "/meta-python2/d" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"
sed -i "/meta-som/d" "\${YOCTO_SDK}/sources/petalinux/bblayers.conf.sample"

result=\$(grep "PLNX_SETUP" "\${YOCTO_SDK}/setupsdk") || true
if [ -z "\$result" ]; then echo -en 'if [ -n "\$PLNX_SETUP" ]; then \$ROOT/sources/petalinux/plnx-setupsdk.sh ; export PETALINUX=\$ROOT/sources/petalinux ; export BB_ENV_PASSTHROUGH_ADDITIONS="\$BB_ENV_PASSTHROUGH_ADDITIONS PETALINUX PROOT" ; fi' >> "\${YOCTO_SDK}/setupsdk"
fi

echo "READY."
exit 0
##__PLNX_SDK__
EOF

	cat ${tarfile} >> ${runfile}
	chmod a+x ${runfile}
}

create_setupfile()
{
	local dir=${1}
	cat > ${dir}/plnx-setupsdk.sh << EOF
rsync -a \$ROOT/sources/petalinux/plnxtool.conf conf/

if [ -d \$ROOT/sources/petalinux/machine ]; then
	rsync -a \$ROOT/sources/petalinux/machine conf/
fi

rsync -a \$ROOT/sources/petalinux/bblayers.conf.sample conf/bblayers.conf
if [ -f \$ROOT/sources/petalinux/enclustra.inc ]; then
   rsync -a \$ROOT/sources/petalinux/enclustra.inc conf/
fi

result=\$(grep -x "include conf/plnxtool.conf" "conf/local.conf")
[ -z "\$result" ] && echo "include conf/plnxtool.conf" >> conf/local.conf

result=\$(grep -x "include conf/petalinuxbsp.conf" "conf/local.conf")
[ -z "\$result" ] && echo "include conf/petalinuxbsp.conf" >> conf/local.conf
[ -z "\$result" ] && echo "require conf/enclustra.inc" >> conf/local.conf
[ -z "\$result" ] && echo "PROOT := \"\\\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '/../../sources/petalinux')}\"" >> conf/enclustra.inc

echo "READY."
EOF
	chmod a+x ${dir}/plnx-setupsdk.sh
}

add_file_cleanup ()
{
	CLEANUP_FILES="${CLEANUP_FILES} $*"
}

do_cleanup ()
{
	if [ -n "${CLEANUP_FILES}" ]; then
		rm -rf ${CLEANUP_FILES} > /dev/null 2>&1
	fi
}



## MAIN

## signal trap
CLEANUP_FILES=""
trap do_cleanup INT TERM ABRT KILL HUP QUIT SEGV EXIT

## check: rsync is installed
test -n "$(which rsync)" || die "please install rsync"

## check: folder contains .petalinux
test -z "${1}" && die "usage: ${0} <plnx-project>"
PROOT="$(readlink -f ${1})" || die "link '$1' is not accessible"
test ! -d ${PROOT}/.petalinux && die "specified Petalinux project path not proper/corrupted"

## check: var PETALINUX is set
test -z ${PETALINUX} && die "Source the petalinux tool to exicute the script"

OUTDIR_SUFFIX="petalinux"
SCRIPT_DIR="$( dirname $(readlink -f ${0}) )" ## TODO 'readlink -f' really needed?
PLNX_DATA="${SCRIPT_DIR}/${OUTDIR_SUFFIX}"

## Create directory structure
mkdir -p ${PLNX_DATA}/project-spec/hw-description

add_file_cleanup ${PLNX_DATA}

## copy plnx data
rsync -a ${PROOT}/build/conf/bblayers.conf ${PROOT}/build/conf/bblayers.conf.sample
sed -i "s|.*/project-spec|  \${SDKBASEMETAPATH}/project-spec|g" ${PROOT}/build/conf/bblayers.conf.sample
rsync -a ${PROOT}/build/conf/bblayers.conf.sample ${PLNX_DATA}/
if [ -f ${PROOT}/build/conf/enclustra.inc ]; then
    rsync -a ${PROOT}/build/conf/enclustra.inc ${PLNX_DATA}/
fi
sed -i "/^SDKBASEMETAPATH = \"/s/.*/SDKBASEMETAPATH := \"\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '\/..\/..')}\"/"  ${PLNX_DATA}/bblayers.conf.sample
sed -i "/components\/yocto\/workspace/d" ${PLNX_DATA}/bblayers.conf.sample
rsync -a ${PROOT}/build/conf/plnxtool.conf ${PLNX_DATA}/
if [ -d ${PROOT}/build/conf/machine ]; then
	rsync -a ${PROOT}/build/conf/machine ${PLNX_DATA}/
fi
rsync -a `find ${PROOT}/project-spec/hw-description/ \( -name "*.pdi" -o -name "*.bit" -o -name "*.xsa" \)` ${PLNX_DATA}/project-spec/hw-description/
rsync -a ${PROOT}/project-spec/meta-* ${PLNX_DATA}/project-spec/
rsync -a ${PROOT}/project-spec/configs ${PLNX_DATA}/project-spec/

echo "copied"

## debug
#cp ${PLNX_DATA}/plnxtool.conf ${PLNX_DATA}/plnxtool.conf.orig

## update plnxtool.conf
sed -i  -e '/TMPDIR/d' \
	-e '/XILINX_SDK_TOOLCHAIN/d' \
	-e '/UNINATIVE_URL/d' \
	-e '/USE_XSCT_TARBALL/d' \
	-e '/XSCTH_WS_pn-device-tree/d' \
	-e "s|${PROOT}|@@PROOT@@|g" ${PLNX_DATA}/plnxtool.conf

echo "${PLNX_DATA}/plnxtool.conf adjusted"

create_setupfile "${PLNX_DATA}"
echo "setupfile"

## create tarball and concat to .run script
tar -czf "${SCRIPT_DIR}/${OUTDIR_SUFFIX}.tar.gz" -C ${SCRIPT_DIR}/ ${OUTDIR_SUFFIX}/
add_file_cleanup "${SCRIPT_DIR}/${OUTDIR_SUFFIX}.tar.gz"

create_runfile "${SCRIPT_DIR}/${OUTDIR_SUFFIX}.tar.gz" "${SCRIPT_DIR}/plnx-yocto-migrate.run"

echo "READY."
