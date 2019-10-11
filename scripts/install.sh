#!/bin/bash -e
{
BASE_PATH="/opt"
TOOLCHAIN_PREFIX="${BASE_PATH}/x-tools"

change_env_value() {
    local _variable="${1}"
    local _value="${2}"

    /usr/bin/awk -F '=' '/^export '"${_variable}"'=.+/ { print $1 "='"${_value}"'"; getline; } { print; }' yaul.env > yaul.env.tmp
    /usr/bin/mv yaul.env.tmp yaul.env
}

# Self log (if possible)
exec &> >(/usr/bin/tee -a "${BASE_PATH}/${0}.log") || true

set -e
set -x

# Install dependencies
/usr/bin/pacman -S --noconfirm --needed git make gcc wget unzip zip p7zip diffutils dos2unix patch tar python3 python3-pip

pip3 install click

/usr/bin/sync
/usr/bin/sync
/usr/bin/sync

cd "${BASE_PATH}"

# Clone repository (if it doesn't already exist)
[ -d "libyaul" ] || /usr/bin/git clone "https://github.com/ijacquez/libyaul.git"
cd libyaul
/usr/bin/git submodule init
/usr/bin/git submodule update -f

# Set up environment
/usr/bin/rm -r -f yaul.env
/usr/bin/cp yaul.env.in yaul.env
change_env_value "YAUL_INSTALL_ROOT" "${TOOLCHAIN_PREFIX}/sh2eb-elf"
change_env_value "YAUL_BUILD_ROOT" "${BASE_PATH}/libyaul/build"
change_env_value "YAUL_BUILD" "build"
change_env_value "YAUL_CDB" "0"
change_env_value "YAUL_OPTION_DEV_CARTRIDGE" "0"
/usr/bin/rm -r -f "${HOME}/.yaul.env"
/usr/bin/mv yaul.env "${HOME}/.yaul.env"
if ! grep -E '\s*source.*\.yaul\.env$' "${HOME}/.bashrc" 2>/dev/null; then
    echo >> "${HOME}/.bashrc"
    echo 'source "${HOME}/.yaul.env"' >> "${HOME}/.bashrc"
fi

# Build
/usr/bin/mkdir -p "${BASE_PATH}/libyaul/build"
source "${HOME}/.yaul.env"
NOCOLOR=1 SILENT=1 /usr/bin/make install-release
NOCOLOR=1 SILENT=1 /usr/bin/make install-tools

# Apply temporary fixes
# Avoid calling make-iso, as it's not portable
/usr/bin/sed -i '/make-iso/d' "${TOOLCHAIN_PREFIX}/sh2eb-elf/share/post.common.mk" # Kludge due to make-iso not being portable

# Delete yo' self
/usr/bin/rm -f -- "${0}"
[ -f "${0}" ] && /usr/bin/printf -- "${0} still exists\\n"

# Done
/usr/bin/printf -- "Success\\n"
}
