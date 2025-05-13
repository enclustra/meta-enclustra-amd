## WORKAROUND: This is a workaround to allow the use of the same machine configuration for different machine types.
# When using the gen-machineconf tool, the correct MACHINEOVERRIDE for cg, eg and ev should be automatically set, but is not.
SOC_VARIANT = "${@'ev' if 'ev' in d.getVar('MACHINE') else 'eg' if 'eg' in d.getVar('MACHINE') else 'cg'}"
require conf/machine/zynqmp-${SOC_VARIANT}-generic.conf