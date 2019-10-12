{
BASE_PATH="/opt"
TOOLCHAIN_PREFIX="${BASE_PATH}/x-tools"

PACMAN_PACKAGES=(git \
    make \
    gcc \
    wget \
    unzip \
    zip \
    p7zip \
    diffutils \
    dos2unix \
    patch \
    tar \
    python3 \
    python3-pip)

change_env_value() {
    local _file="${1}"
    local _variable="${2}"
    local _value="${3}"

    local _tmp_file="/tmp/yaul.env.tmp"

    /usr/bin/awk -F '=' '/^export '"${_variable}"'=.+/ {
                             print $1 "='"${_value}"'";
                             getline;
                         } { print; }' "${_file}" > "${_tmp_file}" || /usr/bin/rm -r -f "${_tmp_file}"
    /usr/bin/mv "${_tmp_file}" "${_file}"
}

# printf -- '*%.0s' `seq 1 \`tput cols\``; printf -- "\\n"
# printf -- "* POST-INSTALLATION IN PROGRESS.\\n"
# printf -- '*%.0s' `seq 1 \`tput cols\``; printf -- "\\n"
#
# sleep 3

# Install dependencies
/usr/bin/pacman -Qi ${PACMAN_PACKAGES[@]} >/dev/null 2>&1 || {
    /usr/bin/pacman -S --quiet --noconfirm --needed ${PACMAN_PACKAGES[@]}
}

# XXX: Dependency for libyaul/common/update-cdb
if ! /usr/bin/pip3 show "click" >/dev/null 2>&1; then
    /usr/bin/pip3 install click
fi

# Clone repository (if it doesn't already exist)
if ! [ -d "${BASE_PATH}/libyaul" ]; then
    pushd . >/dev/null 2>&1
    mkdir -p "${BASE_PATH}"
    cd "${BASE_PATH}"
    /usr/bin/git clone "https://github.com/ijacquez/libyaul.git"

    cd "${BASE_PATH}/libyaul"
    /usr/bin/git submodule init
    /usr/bin/git submodule update -f
    popd >/dev/null 2>&1
fi

# Set up environment
if ! [ -f "${HOME}/.yaul.env" ] &&
   ! [ -L "${HOME}/.yaul.env" ]; then
    /usr/bin/rm -r -f /tmp/yaul.env

    /usr/bin/cp "${BASE_PATH}/libyaul/yaul.env.in" /tmp/yaul.env

    change_env_value /tmp/yaul.env "YAUL_INSTALL_ROOT" "${TOOLCHAIN_PREFIX}/sh2eb-elf"
    change_env_value /tmp/yaul.env "YAUL_BUILD_ROOT" "${BASE_PATH}/libyaul"
    change_env_value /tmp/yaul.env "YAUL_BUILD" "build"
    change_env_value /tmp/yaul.env "YAUL_CDB" "1"
    change_env_value /tmp/yaul.env "YAUL_OPTION_DEV_CARTRIDGE" "0"

    /usr/bin/mv /tmp/yaul.env "${HOME}/.yaul.env"

    if ! grep -E '\s*source.*\.yaul\.env$' "${HOME}/.bashrc" 2>/dev/null; then
        printf -- "\\nsource \"%s\"\\n" "${HOME}/.yaul.env" >> "${HOME}/.bashrc"
    fi
fi

# Build
if ! [ -f "${HOME}/.yaul.built" ] &&
   ! [ -L "${HOME}/.yaul.built" ]; then
    pushd . >/dev/null 2>&1
    cd "${BASE_PATH}/libyaul"

    /usr/bin/mkdir -p "build"
    # shellcheck source=/dev/null    
    source "${HOME}/.yaul.env"

    NOCOLOR=1 SILENT=1 /usr/bin/make install-release
    NOCOLOR=1 SILENT=1 /usr/bin/make install-tools

    touch "${HOME}/.yaul.built"

    popd >/dev/null 2>&1
fi

# Apply temporary fixes
# Avoid calling make-iso, as it's not portable
/usr/bin/sed -i '/make-iso/d' "${TOOLCHAIN_PREFIX}/sh2eb-elf/share/post.common.mk"

/usr/bin/sync
/usr/bin/sync
/usr/bin/sync

unset BASE_PATH
unset TOOLCHAIN_PREFIX
unset PACMAN_PACKAGES

unset change_env_value
}
