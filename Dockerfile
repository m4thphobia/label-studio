ARG PYTORCH="2.1.1"
ARG CUDA="12.1"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ARG DEBIAN_FRONTEND=noninteractive
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    FORCE_CUDA="1"

# To fix GPG key error when running apt-get update
# RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
# RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    tmux \
    tree \
    zip \
    unzip \
    swig\
    xclip \
    ffmpeg \
    python3 \
    python3-pip \
    libsm6 \
    libxext6 \
    git \
    ninja-build \
    libglib2.0-0 \
    libsm6 \
    libxrender-dev \
    libxext6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /usr/local/src/* /tmp/*

# Install MMCV
RUN pip install openmim && \
    mim install mmengine mmcv mmdet

# Install MMDetection
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection

# Allow user to run with matched UID and GID
ARG USER
ARG UID
ARG GID
RUN groupadd --gid ${GID} ${USER} && \
    useradd \
    --no-log-init \
    --create-home \
    --uid ${UID} \
    --gid ${GID} \
    -s /bin/sh ${USER} && \
    usermod -aG sudo ${USER} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy the requirements.txt to the working directory
COPY requirements.txt /

# Set PYTHONPATH for the container
ENV PYTHONPATH=/home/${USER}/workdir
ENV PATH=${PATH}:/home/${USER}/.local/bin

# Upgrade pip and install requirements in a single RUN command
RUN python3 -m pip install --upgrade pip && \
    pip install -r /requirements.txt && \
    pip install --upgrade attrs

# Set working directory before copying requirements.txt
WORKDIR /home/${USER}/workdir

CMD ["bash"]