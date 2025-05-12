FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install --no-install-recommends -y \
    tigervnc-standalone-server \
    novnc \
    websockify \
    sudo \
    xterm \
    init \
    systemd \
    snapd \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata

RUN apt update -y && apt install -y \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    x11-apps

RUN apt install software-properties-common -y

RUN apt update -y && apt install -y \
    ubuntu-desktop \
    ubuntu-desktop-minimal \
    gdm3 \
    gnome-terminal \
    gnome-shell \
    gnome-session

RUN apt update -y && apt install -y \
    gnupg2 \
    lsb-release

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN apt update -y && apt install -y google-chrome-stable

RUN touch /root/.Xauthority

RUN mkdir -p /root/.vnc
RUN echo '#!/bin/sh' > /root/.vnc/xstartup
RUN echo 'unset SESSION_MANAGER' >> /root/.vnc/xstartup
RUN echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /root/.vnc/xstartup
RUN echo 'exec /usr/bin/gnome-session' >> /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

EXPOSE 5901
EXPOSE 6080

CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && tail -f /dev/null"