#!/bin/bash -e

WGET_OPTIONS="--retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 --content-disposition"

GIT_URL="https://github.com/ijacquez/libyaul.git"

TOOLCHAIN_URL="https://drive.google.com/uc?export=download&confirm=no_antivirus&id=1j1O31Lzl2uyl2n9Hn2iFg92bHQB_vN3R"
TOOLCHAIN_FILE="tool-chain-MinGW-x86_64-20180609.7z"

change_env_value() {
    local _variable="${1}"
    local _value="${2}"

    /usr/bin/awk -F '=' '/^export '"${_variable}"'=.+/ { print $1 "='"${_value}"'"; getline; } { print; }' yaul.env > yaul.env.tmp
    /usr/bin/mv yaul.env.tmp yaul.env
}

# Self log
exec &> >(/usr/bin/tee -a "${0}.log")

set -e
set -x

/usr/bin/mkdir -p /opt

cd /opt

/usr/bin/rm -r -f libyaul

/usr/bin/pacman -S --noconfirm git make gcc wget unzip zip p7zip diffutils dos2unix patch tar

/usr/bin/sync
/usr/bin/sync
/usr/bin/sync

# Download ${TOOLCHAIN_FILE}
/usr/bin/wget ${WGET_OPTIONS} "${TOOLCHAIN_URL}"
/usr/bin/rm -r -f /opt/tool-chains
/usr/bin/7z x -o/opt/ "/opt/${TOOLCHAIN_FILE}"
/usr/bin/sync
/usr/bin/rm -f "/opt/${TOOLCHAIN_FILE}"

/usr/bin/git clone "${GIT_URL}"
cd libyaul
/usr/bin/git submodule init
/usr/bin/git submodule update -f
/usr/bin/cp yaul.env.in yaul.env
change_env_value "YAUL_INSTALL_ROOT" "/opt/tool-chains"
change_env_value "YAUL_BUILD_ROOT" "/opt/libyaul/build"
change_env_value "YAUL_BUILD" "build"
change_env_value "YAUL_RTAGS" "false"
change_env_value "YAUL_OPTION_DEV_CARTRIDGE" "0"
mv yaul.env "${HOME}/.yaul.env"
echo >> "${HOME}/.bashrc"
echo 'source "${HOME}/.yaul.env"' >> "${HOME}/.bashrc"
source "${HOME}/.yaul.env"
SILENT=1 /usr/bin/make install-release
SILENT=1 /usr/bin/make install-tools
# Avoid calling make-iso, as it's not portable
/usr/bin/sed -i '/make-iso/d' /opt/tool-chains/share/post.common.mk # Kludge due to make-iso not being portable
/usr/bin/rm -f -- "${0}"

[ -f "${0}" ] && /usr/bin/printf -- "${0} still exists\n"

/usr/bin/printf -- "Success\n"
