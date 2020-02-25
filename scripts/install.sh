{
PACMAN_PACKAGES=(
    diffutils
    dos2unix
    gcc
    git
    make
    mingw-w64-x86_64-libftdi
    p7zip
    patch
    pkg-config
    python3
    python3-pip
    tar
    unzip
    wget
    xorriso
    zip
)

# Install dependencies
/usr/bin/pacman -Qi ${PACMAN_PACKAGES[@]} >/dev/null 2>&1 || {
    /usr/bin/pacman -S --quiet --noconfirm --needed ${PACMAN_PACKAGES[@]}
}

# Install pip dependencies
/usr/bin/pip3 install /etc/post-install/dependencies/pip3/*.whl >/dev/null 2>&1 || true

unset PACMAN_PACKAGES
}
