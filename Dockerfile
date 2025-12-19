# CUDA 12.4.1 with cuDNN (VALID TAG)
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# System deps
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    wget \
    vim \
    build-essential \
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

# Heavy ML deps
RUN pip install \
    transformers==4.51.0 \
    accelerate==0.25.0 \
    bitsandbytes==0.45.4 \
    peft==0.7.0 \
    datasets==2.18.0 \
    wandb==0.15.0 \
    vllm==0.8.2

WORKDIR /workspace
CMD ["/bin/bash"]
