inherit extrausers

## not enough to change home dir, even with usermod -d ${ROOT_HOME}
#ROOT_HOME="/home/root"

# printf "%q" $(mkpasswd -m sha256crypt root)
PASSWD_ROOT="\$5\$FzLbQxzCUjq7cahw\$/baNeIE8qb4i6FnYFyS1itdgwW9N5Eu5AkAYnCGDKHA"

EXTRA_USERS_PARAMS = "\
usermod -p '${PASSWD_ROOT}' root; \
"

## debugging
ENCLUSTRA_LAB_MMC_IMAGE_INSTALL := " \
tcf-agent \
e2fsprogs-mke2fs \
bridge-utils \
resize-part \
can-utils \
pciutils \
strace \
"

ENCLUSTRA_LAB_IMAGE_INSTALL := " \
dosfstools \
u-boot-tools \
iperf3 \
memtester \
phytool \
haveged \
i2c-tools \
mtd-utils \
usbutils \
hdparm \
sysstat \
"

ENCLUSTRA_LAB_IMAGE_INSTALL_TPM := " \
tpm2-tools \
libtss2 \
libtss2-tcti-device \
"

## lab infrastructure needs bmaptool
ENCLUSTRA_LAB_NFS_IMAGE_INSTALL := " bmaptool"
IMAGE_INSTALL:append:enclustra-sd = "${ENCLUSTRA_LAB_NFS_IMAGE_INSTALL}"
IMAGE_INSTALL:append:enclustra-emmc = "${ENCLUSTRA_LAB_NFS_IMAGE_INSTALL}"

IMAGE_INSTALL:append:enclustra-sd = "${ENCLUSTRA_LAB_IMAGE_INSTALL}"
IMAGE_INSTALL:append:enclustra-sd = "${ENCLUSTRA_LAB_MMC_IMAGE_INSTALL}"

IMAGE_INSTALL:append:enclustra-emmc = "${ENCLUSTRA_LAB_IMAGE_INSTALL}"
IMAGE_INSTALL:append:enclustra-emmc = "${ENCLUSTRA_LAB_MMC_IMAGE_INSTALL}"

IMAGE_INSTALL:append:enclustra-qspi = "${ENCLUSTRA_LAB_IMAGE_INSTALL}"

## add tpm tools only to relevant modules
IMAGE_INSTALL:append:xu61-module = "${ENCLUSTRA_LAB_IMAGE_INSTALL_TPM}"
IMAGE_INSTALL:append:xzu65-module = "${ENCLUSTRA_LAB_IMAGE_INSTALL_TPM}"
IMAGE_INSTALL:append:xzu80-module = "${ENCLUSTRA_LAB_IMAGE_INSTALL_TPM}"
IMAGE_INSTALL:append:xzu90-module = "${ENCLUSTRA_LAB_IMAGE_INSTALL_TPM}"
