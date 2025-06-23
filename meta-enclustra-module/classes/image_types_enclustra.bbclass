## Generate a CPIO image that can be compressed with xz and used as an
## initramfs. This function removes the contents of the boot folder during the
## CPIO packaging process and should be used in place of the do_image_cpio()
## function from image_types.bbclass, which does not exclude boot artifacts.
IMAGE_CMD:cpio_enclustra() {
	mkdir -p ${WORKDIR}/cpio_append
        (cd ${IMAGE_ROOTFS} && find . | grep -v '/boot/' | sort | cpio --reproducible -o -H newc >${IMGDEPLOYDIR}/${IMAGE_NAME}.cpio_enclustra)
        if [ "${IMAGE_BUILDING_DEBUGFS}" != "true" ]; then
                if [ ! -L ${IMAGE_ROOTFS}/init ] && [ ! -e ${IMAGE_ROOTFS}/init ]; then
                        if [ -L ${IMAGE_ROOTFS}/sbin/init ] || [ -e ${IMAGE_ROOTFS}/sbin/init ]; then
                                ln -sf /sbin/init ${WORKDIR}/cpio_append/init
                                touch -h -r ${IMAGE_ROOTFS}/sbin/init ${WORKDIR}/cpio_append/init
                        else
                                touch -r ${IMAGE_ROOTFS} ${WORKDIR}/cpio_append/init
                        fi
                        (cd  ${WORKDIR}/cpio_append && echo ./init | cpio --reproducible -oA -H newc -F ${IMGDEPLOYDIR}/${IMAGE_NAME}.cpio_enclustra)
                fi
        fi
}
