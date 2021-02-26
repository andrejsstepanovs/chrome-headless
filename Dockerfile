FROM debian:buster-slim

ENV DISPLAY=:99 \
    DBUS_SESSION_BUS_ADDRESS=/dev/null \
    VNC_SCREEN_SIZE=1920x1080 \
    ENV_CHROME_WINDOW_SIZE=1920,1080

RUN apt-get update -qqy \
  && apt-get -qqy \
     install \
     supervisor \
     wget \
     ca-certificates \
     apt-transport-https \
     ttf-wqy-zenhei \
     unzip \
     git \
     x11vnc \
     xfonts-100dpi \
     xfonts-75dpi \
     xfonts-cyrillic \
     xfonts-scalable \
     xvfb \
     libpng-dev \
     libjpeg-dev \
     gnupg \
     curl \
     vim \
     htop \
     less \
     # dbus-x11 \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN useradd headless --shell /bin/bash --create-home \
  && usermod -a -G sudo headless \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'headless:nopassword' | chpasswd

RUN mkdir /data

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 9222

CMD ["supervisord"]
