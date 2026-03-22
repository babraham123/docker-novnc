FROM debian:bullseye

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      fluxbox \
      git \
      net-tools \
      novnc \
      supervisor \
      x11vnc \
      xterm \
      xvfb

# Setup demo environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes \
    RUN_NOVNC=yes

# Replace apt-installed noVNC frontend with v1.6.0
RUN git clone --depth 1 --branch v1.6.0 https://github.com/novnc/noVNC.git /tmp/novnc && \
    rm -rf /usr/share/novnc/app /usr/share/novnc/core /usr/share/novnc/vendor /usr/share/novnc/*.html && \
    cp -R /tmp/novnc/app /usr/share/novnc/ && \
    cp -R /tmp/novnc/core /usr/share/novnc/ && \
    cp -R /tmp/novnc/vendor /usr/share/novnc/ && \
    cp /tmp/novnc/vnc.html /usr/share/novnc/ && \
    cp /tmp/novnc/vnc_lite.html /usr/share/novnc/ && \
    ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
    rm -rf /tmp/novnc

COPY . /app
CMD ["/app/entrypoint.sh"]
EXPOSE 8080
