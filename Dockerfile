# Use NVIDIA CUDA base image with Python 3.12
# Using CUDA 12.4 for compatibility with PyTorch 2.6.0+
FROM nvidia/cuda:12.4.0-cudnn-devel-ubuntu22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    curl \
    git \
    wget \
    vim \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Make python3.12 the default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Install pip for Python 3.12 and upgrade it
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 \
    && python3.12 -m pip install --upgrade pip setuptools wheel


# Pre-install PyTorch with CUDA support (speeds up subsequent installs)
RUN pip install torch==2.6.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Pre-install some heavy dependencies to speed up project setup
RUN pip install \
    transformers==4.51.0 \
    accelerate==0.25.0 \
    bitsandbytes==0.45.4 \
    peft==0.7.0 \
    datasets==2.18.0 \
    wandb==0.15.0 \
    vllm==0.8.2

# Set working directory (RunPod mounts persistent storage here)
WORKDIR /workspace

# Default command - just start bash
CMD ["/bin/bash"]
