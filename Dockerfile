# syntax=docker/dockerfile:1

FROM archlinux:base-devel-20230312.0.133040 AS extractor
WORKDIR /opt
RUN /bin/sh -c 'printf -- "\n\n\
[yaul]\n\
SigLevel = Optional TrustAll\n\
Server = http://packages.yaul.org/pacman/x86_64\n" >> /etc/pacman.conf' && \
    /usr/bin/pacman -Syu --noconfirm && \
    /usr/bin/pacman -S -d --noconfirm \
        yaul-tool-chain-git \
        yaul \
        yaul-examples-git && \
    /usr/bin/pacman -Q yaul | sed -E 's/^yaul\s+//g' >> /opt/yaul.version && \
    /usr/bin/pacman -Q yaul-tool-chain-git | sed -E 's/^yaul-tool-chain-git\s+//g' >> /opt/yaul-tool-chain-git.version && \
    /usr/bin/pacman -Q yaul-examples-git | sed -E 's/^yaul-examples-git\s+//g' >> /opt/yaul-examples-git.version

# debian:unstable is required: glibc >=2.34
FROM debian:unstable-20230227-slim

ENV HOME /work

ENV YAUL_INSTALL_ROOT=/opt/tool-chains/sh2eb-elf
ENV YAUL_PROG_SH_PREFIX=
ENV YAUL_ARCH_SH_PREFIX=sh2eb-elf
ENV YAUL_ARCH_M68K_PREFIX=m68keb-elf
ENV YAUL_BUILD_ROOT=${HOME}
ENV YAUL_BUILD=build
ENV YAUL_CDB=0
ENV YAUL_OPTION_MALLOC_IMPL="tlsf"
ENV SILENT=1
ENV MAKE_ISO_XORRISOFS=/usr/bin/xorrisofs
ENV CDB_GCC=/usr/bin/gcc
ENV CDB_CPP=/usr/bin/g++

RUN /usr/bin/apt update && \
    /usr/bin/apt install -y --no-install-recommends xorriso make && \
    /usr/bin/apt autoremove -y --purge && \
    /bin/rm -f /var/lib/apt/lists/*.deb

COPY --from=extractor /opt /opt

WORKDIR /work

CMD ["/bin/bash"]
