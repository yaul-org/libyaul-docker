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
ENV YAUL_OPTION_MALLOC_IMPL="tlsf"
ENV SILENT=1
ENV MAKE_ISO_XORRISO=/usr/bin/xorriso
ENV CDB_GCC=/usr/bin/gcc
ENV CDB_CPP=/usr/bin/g++

RUN useradd -m yaul

WORKDIR /work

ADD VERSION .

RUN /usr/bin/pacman -Sy --noconfirm \
        archlinux-keyring && \
\
    /usr/bin/pacman -Syyu --noconfirm && \
\
    /usr/bin/pacman -S --noconfirm \
        base-devel \
        git \
        archlinux-keyring && \
\
    echo "yaul ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/yaul && \
\
    /bin/sh -c 'printf -- "\n\
[yaul-linux]\n\
SigLevel = Optional TrustAll\n\
Server = http://packages.yaul.org/linux/x86_64\n" >> /etc/pacman.conf'

ARG UPDATE_PACKAGES
RUN /usr/bin/pacman -Syy --noconfirm && \
    /usr/bin/pacman -S --noconfirm \
        yaul-tool-chain-git \
        yaul \
        yaul-examples-git

USER yaul

CMD ["/bin/bash"]
