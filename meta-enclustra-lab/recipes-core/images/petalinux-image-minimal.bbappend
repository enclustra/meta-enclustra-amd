inherit extrausers

## not enough to change home dir, even with usermod -d ${ROOT_HOME}
#ROOT_HOME="/home/root"

# printf "%q" $(mkpasswd -m sha256crypt root)
PASSWD_ROOT="\$5\$FzLbQxzCUjq7cahw\$/baNeIE8qb4i6FnYFyS1itdgwW9N5Eu5AkAYnCGDKHA"

EXTRA_USERS_PARAMS = "\
usermod -p '${PASSWD_ROOT}' root; \
"
