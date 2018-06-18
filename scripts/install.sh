#!/bin/bash -e

WGET_OPTIONS="--retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 --content-disposition"

TOOLCHAIN_URL="https://drive.google.com/uc?export=download&confirm=no_antivirus&id=1j1O31Lzl2uyl2n9Hn2iFg92bHQB_vN3R"
TOOLCHAIN_FILE="tool-chain-MinGW-x86_64-20180609.7z"

# Self log
exec &> >(tee -a "${0}.log")

set -e
set -x

cd
rm -r -f libyaul

pacman -S --noconfirm git make gcc wget unzip zip p7zip

sync
sync
sync

# Download genromfs.zip
/usr/bin/wget ${WGET_OPTIONS} "https://drive.google.com/uc?export=download&confirm=no_antivirus&id=1AEnUxJugEqYIb2Z7EjHF6C6yPsXOPrRP"

# Download ${TOOLCHAIN_FILE}
/usr/bin/wget ${WGET_OPTIONS} "${TOOLCHAIN_URL}"
rm -r -f /opt/tool-chains
mkdir -p /opt
/usr/bin/7z x -o/opt/ "${HOME}/${TOOLCHAIN_FILE}"
sync
rm -f "${HOME}/${TOOLCHAIN_FILE}"

/usr/bin/git clone https://github.com/ijacquez/libyaul.git
cd libyaul
/usr/bin/git submodule init
/usr/bin/git submodule update -f
cp yaul.env.in ~/.yaul.env
echo >> ~/.bashrc
echo 'source ~/.yaul.env' >> ~/.bashrc
source ~/.yaul.env
SILENT=1 make install-release
# Avoid building genromfs
sed -i '/genromfs/d' tools/Makefile # Kludge due to issues with genromfs.exe
SILENT=1 make install-tools
mkdir -p /opt/tool-chains/bin
/usr/bin/unzip -o ~/genromfs.zip -d /opt/tool-chains/bin/
rm -f ~/genromfs.zip
install -m 755 tools/genromfs/fsck.genromfs /opt/tool-chains/bin/
# Avoid calling make-iso, as it's not portable
sed -i '/make-iso/d' /opt/tool-chains/share/post.common.mk # Kludge due to make-iso not being portable
rm -f -- "${0}"

[ -f "${0}" ] && printf -- "${0} still exists\n"

printf -- "Success\n"
