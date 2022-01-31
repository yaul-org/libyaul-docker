FROM archlinux:latest

MAINTAINER Israel Jacquez <mrkotfw@gmail.com>

ENV HOME /home/yaul

ENV YAUL_INSTALL_ROOT=/opt/tool-chains/sh2eb-elf
ENV YAUL_PROG_SH_PREFIX=
ENV YAUL_ARCH_SH_PREFIX=sh2eb-elf
ENV YAUL_ARCH_M68K_PREFIX=m68keb-elf
ENV YAUL_BUILD_ROOT=${HOME}/libyaul
ENV YAUL_BUILD=build
ENV YAUL_CDB=1
ENV YAUL_OPTION_DEV_CARTRIDGE=0
ENV YAUL_OPTION_MALLOC_IMPL="tlsf"
ENV YAUL_OPTION_SPIN_ON_ABORT=1
ENV YAUL_OPTION_BUILD_GDB=0
ENV YAUL_OPTION_BUILD_ASSERT=0
ENV SILENT=1
ENV MAKE_ISO_XORRISO=/usr/bin/xorriso
ENV CDB_GCC=/usr/bin/gcc
ENV CDB_CPP=/usr/bin/g++

RUN useradd -m yaul

WORKDIR /work

# WORKAROUND for glibc 2.33 and old Docker
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/${patched_glibc}" && \
    bsdtar -C / -xvf "${patched_glibc}" && \
    rm -f "${patched_glibc}"

RUN /usr/bin/pacman -Sy --noconfirm \
        archlinux-keyring && \
    /usr/bin/pacman -Syyu --noconfirm && \
    /usr/bin/pacman -S --noconfirm \
        base-devel \
        git \
        archlinux-keyring

RUN echo "yaul ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/yaul

USER yaul

RUN sudo -E /bin/sh -c 'printf -- "\n\
[yaul-linux]\n\
SigLevel = Optional TrustAll\n\
Server = http://packages.yaul.org/linux/x86_64\n" >> /etc/pacman.conf'

RUN sudo -E /usr/bin/pacman -Syy --noconfirm && \
    sudo -E /usr/bin/pacman -S --noconfirm \
        yaul-tool-chain-git \
        yaul-git \
        yaul-examples-git

CMD ["/bin/bash"]
