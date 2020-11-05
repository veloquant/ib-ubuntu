FROM ubuntu:focal

ARG IBC_VERSION=3.8.4-beta.2

RUN apt-get update -yqq && \
    apt-get install --no-install-recommends -yqq \
        unzip less wget ca-certificates xvfb xfonts-base x11vnc telnet iproute2 && \
    apt-get -y autoclean

WORKDIR /opt/ibc

RUN wget https://github.com/IbcAlpha/IBC/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip && \
    unzip -qq IBCLinux-${IBC_VERSION}.zip && \
    rm -f IBCLinux-${IBC_VERSION}.zip && \
    find . -type f -name '*.sh' | xargs chmod +x

WORKDIR /home/ib

RUN useradd -s /bin/bash -d /home/ib ib && \
    chown -R ib /home/ib && \
    mkdir -p /tmp/.X11-unix /var/log/ && \
    chmod 1777 /tmp/.X11-unix /var/log/

USER ib

RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh && \
    chmod a+x ibgateway-latest-standalone-linux-x64.sh && \
    yes | tr -d y | sh ibgateway-latest-standalone-linux-x64.sh -c && \
    rm -f ibgateway-latest-standalone-linux-x64.sh

COPY start.sh .

ENV IB_USER edemo
ENV IB_PW demouser
ENV DISPLAY :1
EXPOSE 5900
EXPOSE 4000-4002
ENTRYPOINT bash start.sh

LABEL com.interactivebrokers.ibcalpha.version $IBC_VERSION
