FROM base/archlinux

RUN pacman -Syu --noconfirm firefox
RUN useradd -ms /bin/bash docker

USER docker
WORKDIR /home/docker

CMD /usr/bin/firefox
