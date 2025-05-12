FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt update -y && apt install --no-install-recommends -y \
    xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify sudo xterm \
    init systemd snapd vim net-tools curl wget git tzdata dbus-x11 \
    x11-utils x11-xserver-utils x11-apps software-properties-common

# Install Opera browser
RUN wget -qO- https://deb.opera.com/archive.key | gpg --dearmor > /usr/share/keyrings/opera.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera.list \
    && apt update -y && apt install -y opera-stable

# Install optional icon theme
RUN apt install -y xubuntu-icon-theme

# Fix X11 auth
RUN touch /root/.Xauthority

# Expose VNC and noVNC ports
EXPOSE 5901
EXPOSE 6080

# Start VNC, generate SSL cert, and launch noVNC
CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj \"/C=JP\" -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && tail -f /dev/null"
