# Use a suitable base image with Python 3.12
FROM python:3.12-slim

# Set up the working directory
WORKDIR /ftl_quantum

# Install necessary system packages (adjust according to needs)
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
   --mount=target=/var/cache/apt,type=cache,sharing=locked \
   rm -f /etc/apt/apt.conf.d/docker-clean \
   && apt-get update \
   && apt-get install -y git \
   zsh \
   wget \
   curl \
   unzip \
   build-essential

# Pretty zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell

# Install neovim
RUN wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz && tar xf nvim-linux64.tar.gz && mv nvim-linux64 /root/nvim && rm  nvim-linux64.tar.gz && echo 'PATH=$PATH:$HOME/nvim/bin/' >> /root/.zshrc

# Clone my vim config
RUN git clone https://github.com/0xEDU/nvim.git
RUN mkdir -p /root/.config && mv nvim /root/.config

# Install some nvim stuff
RUN /root/nvim/bin/nvim --headless +TSInstall python +MasonInstall pylyzer +MasonInstall debugpy +qa

# Copy your requirements.txt file
COPY requirements.txt ./

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose a port for potential debugging or web applications 
EXPOSE 8000
