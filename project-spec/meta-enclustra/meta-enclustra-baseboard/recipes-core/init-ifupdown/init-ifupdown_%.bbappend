## TODO: note - this is probably not used by default when systemd is active -> use mp1 layer approach
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ENCLUSTRA_ETH_INTERFACES := "dual"

SRC_URI += " \
        file://interfaces_${ENCLUSTRA_ETH_INTERFACES}_eth \
        "
do_install:append() {
     install -m 0644 ${WORKDIR}/interfaces_${ENCLUSTRA_ETH_INTERFACES}_eth ${D}${sysconfdir}/network/interfaces
}
