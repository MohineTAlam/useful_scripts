#!/usr/bin/env bash

set -euo pipefail

echo "=== system update and base dependencies ==="
sudo apt update
sudo apt install -y \
    curl \
    wget \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    openjdk-17-jre \
    build-essential

echo "=== install and enable docker ==="
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

echo "=== install nextflow ==="
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/

echo "=== install miniconda ==="
MINICONDA=Miniconda3-latest-Linux-x86_64.sh
wget https://repo.anaconda.com/miniconda/${MINICONDA}
bash ${MINICONDA} -b -p $HOME/miniconda
rm ${MINICONDA}

# activate conda
source "$HOME/miniconda/etc/profile.d/conda.sh"

echo "=== installation complete ==="
echo "Log out and back in for docker group changes to apply"

