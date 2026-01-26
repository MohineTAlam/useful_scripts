#!/usr/bin/env bash

# exit if any command fails
set -euo pipefail

echo "=== update system ==="
sudo apt update
sudo apt install -y \
        curl \
        wget \
        git \
        ca-certificates \ # secure https connection
        gnupg \ # cryptographic verification tool - veryify package signitatues e.g. docker
        lsb-release \ # identifies linux distribution and version
        openjdk-17-jre \
        docker.io

echo "=== enable docker ==="
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
