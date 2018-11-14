FROM ubuntu:16.04

# enable i386 packages
RUN dpkg --add-architecture i386

# install some packages
RUN apt-get update -y \
 && apt-get install -y tofrodos iproute gawk gcc git-core make net-tools \
        ncurses-dev tftpd zlib1g-dev flex bison lib32ncursesw5 \
        libncurses5-dev lib32z1 lib32stdc++6 libselinux1 xz-utils \
        wget diffstat xvfb chrpath socat xterm autoconf libtool libtool-bin \
        libssl-dev python  gnupg tar unzip texinfo locales lsb-release \
        zlib1g:i386 build-essential libsdl1.2-dev libglib2.0-dev \
        gcc-multilib cpio

# use bash as /bin/sh
RUN yes n | dpkg-reconfigure dash

# create a non-root user
RUN groupadd --gid 1000 docker
RUN useradd --uid 1000 --gid 1000 -ms "/bin/bash" docker

# add en_US.UTF-8 locale
RUN echo "en_US.UTF-8 UTF-8" >> "/etc/locale.gen"
RUN locale-gen

ENV LANG        "en_US.UTF-8"
ENV LC_CTYPE    "en_US.UTF-8"
ENV LC_MESSAGES "en_US.UTF-8"
ENV LC_COLLATE  "en_US.UTF-8"

# install bash 4.3.30
WORKDIR /bash
RUN wget "https://ftp.gnu.org/gnu/bash/bash-4.3.30.tar.gz"
RUN tar -xvf "bash-4.3.30.tar.gz" \
 && cd "bash-4.3.30" \
 && ./configure \
 && make

# run bash 4.3.30
USER docker
ENTRYPOINT ["bash-4.3.30/bash"]
