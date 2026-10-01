#!/usr/bin/env bash
# Installs Java 17, Jenkins LTS, Git and Docker CLI/engine on Ubuntu WSL2.
set -euo pipefail

[ "$(ps -p 1 -o comm=)" = "systemd" ] || { echo "Run 00-enable-systemd.sh first."; exit 1; }

sudo apt-get update
sudo apt-get install -y fontconfig openjdk-17-jre git curl ca-certificates gnupg docker.io

# Jenkins LTS apt repo (2023 signing key)
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  -o /etc/apt/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null

sudo apt-get update
sudo apt-get install -y jenkins

# Let Jenkins (and you) use Docker
sudo usermod -aG docker jenkins
sudo usermod -aG docker "$USER"

sudo systemctl enable --now docker
sudo systemctl enable --now jenkins

echo
echo "Jenkins is starting on http://localhost:8080"
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
