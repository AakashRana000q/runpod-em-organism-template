# CUDA 12.4.1 with cuDNN (VALID TAG)
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# System deps (add openssh-server for optional SSH support)
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    wget \
    vim \
    build-essential \
    openssh-server \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    && rm -rf /var/lib/apt/lists/*

# Make Python 3.12 default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Install pip
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 \
    && python3.12 -m pip install --upgrade pip setuptools wheel

# PyTorch (CUDA 12.4 wheels)
RUN pip install torch==2.6.0 torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu124

# Install Jupyter Lab
RUN pip install jupyterlab ipywidgets

# Copy and make startup script executable
COPY start.sh /
RUN chmod +x /start.sh

WORKDIR /workspace
CMD ["/start.sh"]
