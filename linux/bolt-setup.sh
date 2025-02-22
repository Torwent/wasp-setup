#!/bin/bash
# setup-bolt.sh - Build script for Bolt on Ubuntu 24.04
set -e
trap 'echo "An error occurred. Exiting." >&2' ERR
TARGET_DIR="$HOME/Bolt"

# Update system packages
sudo apt update -y && sudo apt upgrade -y

# Install dependencies
sudo apt-get install -y git wget cmake build-essential \
  libx11-dev libxcb1-dev libarchive-dev libluajit-5.1-dev openjdk-17-jdk

# Set Java 17 as default (always force set)
sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

# Clone or update the Bolt repository
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR"
  git pull
  git submodule update --init --recursive
else
  git clone --recurse-submodules https://github.com/Adamcake/Bolt.git "$TARGET_DIR"
  cd "$TARGET_DIR"
fi

# Download and extract CEF if not already present
if [ ! -d "cef/dist" ]; then
  mkdir -p cef
  cd cef
  wget -q --show-progress -O cef_linux.tar.gz \
    "https://adamcake.com/cef/cef-126.0.6478.183-linux-x86_64-minimal-ungoogled.tar.gz"
  
  # Extract and rename top-level directory
  TOP_DIR=$(tar -tzf cef_linux.tar.gz | head -n 1 | cut -d'/' -f1)
  tar -xzf cef_linux.tar.gz && mv "$TOP_DIR" dist && rm cef_linux.tar.gz
  cd ..
fi

# Configure and build
mkdir -p build
cmake -S . -B build -D CMAKE_BUILD_TYPE=Release -D BOLT_SKIP_LIBRARIES=1
cmake --build build

# Install to default location (/usr/local)
sudo cmake --install build

# Fix the sandbox permissions
if [ -f "/opt/bolt-launcher/chrome-sandbox" ]; then
  sudo chown root:root /opt/bolt-launcher/chrome-sandbox
  sudo chmod 4755 /opt/bolt-launcher/chrome-sandbox
fi

# Set JAVA_HOME to Java 17
JAVA_PATH="/usr/lib/jvm/java-17-openjdk-amd64"
echo "export JAVA_HOME=\"$JAVA_PATH\"" >> ~/.bashrc

# Create profiles directory if it doesn't exist
PROFILES_DIR="/home/$USER/.local/share/bolt-launcher/.runelite/profiles2"
mkdir -p "$PROFILES_DIR"

# Download the profile
wget -q --show-progress -O "$PROFILES_DIR/myprofile.properties" \
  "https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/myprofile.properties"

echo "Installation complete! You can run Bolt from your application menu or with the 'bolt' command."
echo "Profile has been downloaded and placed in $PROFILES_DIR"
echo "Please log out and log back in to apply all JAVA_HOME changes"
