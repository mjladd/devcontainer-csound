# syntax=docker/dockerfile:1
# Use UV's official image with Python 3.13 on Debian Trixie
FROM ghcr.io/astral-sh/uv:python3.13-trixie-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/workspace/.venv \
    VIRTUAL_ENV=/workspace/.venv \
    PATH="/workspace/.venv/bin:$PATH" \
    DEVCONTAINER=true \
    DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    SSDIR=/scores/samples \
    SADIR=/scores/analysis \
    STARSHIP_CONFIG=/usr/local/etc/starship.toml

ARG CACHEBUST=1


# Install Csound build dependencies and build from source
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    fontconfig ca-certificates curl unzip git make zsh \
    git cmake g++ vim wget eza \
    libsndfile1-dev libjack-dev portaudio19-dev \
    libportmidi-dev libpulse-dev swig liblua5.1-0-dev default-jdk libfluidsynth-dev \
    liblo-dev fluid ladspa-sdk libpng-dev dssi-dev libgmm++-dev \
    libportsmf-dev libeigen3-dev libcunit1-dev gettext flex bison && \
  git clone https://github.com/csound/csound.git && \
  mkdir cs6make && \
  cd cs6make && cmake ../csound && make -j6 && make install && \
  ldconfig && \
  rm -rf /var/lib/apt/lists/*

RUN rm -fr csound cs6make

# Install Cascadia Code Nerd Font
RUN mkdir -p /usr/local/share/fonts/cascadiacode && \
    curl -fLo "/tmp/CascadiaCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip" && \
    unzip "/tmp/CascadiaCode.zip" -d /usr/local/share/fonts/cascadiacode && \
    rm "/tmp/CascadiaCode.zip" && \
    fc-cache -fv

# UV configuration
ENV UV_LINK_MODE=copy
ENV PATH="/root/.local/bin:$PATH"

# Install pre-commit
RUN uv tool install pre-commit

# Skip Python dependency install at build; handled post-create
RUN --mount=type=cache,target=/root/.cache/uv \
    sh -lc 'echo "Skipping uv sync at build; will run post-create."'

# Copy configs
COPY .devcontainer/starship.toml /usr/local/etc/starship.toml
COPY .devcontainer/zshrc /root/.zshrc

# use zsh as default shell in the container
ENV SHELL=/usr/bin/zsh

# Install Starship and configure zsh
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y && \
    TARGET_USER="root" && \
    if id -u vscode >/dev/null 2>&1; then TARGET_USER="vscode"; fi && \
    TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)" && \
    # Clone zsh plugins
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${TARGET_HOME}/.zsh/zsh-syntax-highlighting" && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${TARGET_HOME}/.zsh/zsh-autosuggestions" && \
    # Ensure execute permissions on plugin files
    chmod +x "${TARGET_HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && \
    chmod +x "${TARGET_HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" && \
    # Configure zsh to load plugins and starship
    echo 'source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$TARGET_HOME/.zshrc" && \
    echo 'source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$TARGET_HOME/.zshrc" && \
    echo 'eval "$(starship init zsh)"' >> "$TARGET_HOME/.zshrc" && \
    # Fix ownership and set zsh as default shell
    chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zsh" && \
    usermod -s /usr/bin/zsh "$TARGET_USER"

WORKDIR /scores
