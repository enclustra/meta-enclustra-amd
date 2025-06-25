require conf/machine/zynq-generic.conf

## NB: INIT_MANAGER_DEFAULT is the system fall back, if INIT_MANAGER is not set
INIT_MANAGER ?= "systemd"
