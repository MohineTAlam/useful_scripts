#!/usr/bin/env bash

# exit if any command fails
set -euo pipefail

echo "=== update system and install dependencies ==="
sudo apt update
sudo apt install -y \
        curl \
        wget \
        git \
        ca-certificates \
        gnupg \
        lsb-release \
        openjdk-17-jre

echo "=== install and enable docker ==="
sudo apt install docker.io
sudo systemctl enable docker
sudo systemctl start docker
echo "=== add user to docker ==="
sudo usermod -aG docker ubuntu



echo "=== installing nextlow ==="
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin



echo "=== installing miniconda ==="
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh
source ~/.bashrc

echo "=== install oci - follow prompts ==="
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"


echo "=== done ==="
echo "log out and back in for docker user changes to apply"
