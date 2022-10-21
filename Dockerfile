FROM cm2network/steamcmd:latest

USER root

RUN export DEBIAN_FRONTEND noninteractive && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y net-tools tar unzip curl xz-utils gnupg2 software-properties-common xvfb libc6:i386 locales && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen && \
    apt-get install -y wine wine32 wine64 libwine libwine:i386 fonts-wine && \
    ln -s '/home/steam/steamapps/common/Empyrion - Dedicated Server/' /server && \
    useradd -m user

USER steam
ENV HOME /home/steam
WORKDIR /home/steam
VOLUME /home/steam

# Get's killed at the end
RUN ./steamcmd.sh +login anonymous +quit || :
USER root
RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

EXPOSE 30000/udp
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
