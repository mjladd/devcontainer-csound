#specify the base OS
FROM ubuntu:latest

WORKDIR /scores
ENV SSDIR=/scores/samples
ENV SADIR=/scores/analysis

ARG CACHEBUST=1

#Running apt updates on OS
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install git cmake g++ vim wget libsndfile1-dev libjack-dev portaudio19-dev \
   libportmidi-dev libpulse-dev swig liblua5.1-0-dev default-jdk libfluidsynth-dev \
   liblo-dev fluid ladspa-sdk libpng-dev dssi-dev libgmm++-dev \
   libportsmf-dev  libeigen3-dev libcunit1-dev gettext flex bison -y  && \
  git clone https://github.com/csound/csound.git && \
  mkdir cs6make && \
  cd cs6make && cmake ../csound && make -j6 && make install && \
  ldconfig

RUN rm -fr csound cs6make

ENV DEVCONTAINER=true

# Install zsh and set up Oh My Zsh with plugins
RUN apt-get update -y && apt-get install -y zsh curl && \
  usermod -s /usr/bin/zsh root && \
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh && \
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
  echo 'export ZSH="$HOME/.oh-my-zsh"' > /root/.zshrc && \
  echo 'ZSH_THEME="robbyrussell"' >> /root/.zshrc && \
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> /root/.zshrc && \
  echo 'autoload -U compinit && compinit' >> /root/.zshrc && \
  echo 'source $ZSH/oh-my-zsh.sh' >> /root/.zshrc && \
  echo 'ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"' >> /root/.zshrc && \
  echo "# Improve completion UI" >> /root/.zshrc && \
  echo "zstyle ':completion:*' menu select" >> /root/.zshrc && \
  echo "export SHELL=/usr/bin/zsh" >> /root/.zshrc

ENV SHELL=/usr/bin/zsh
