#!/bin/bash
# uninstall-bolt.sh - Uninstall script for Bolt on Ubuntu
set -e
trap 'echo "An error occurred. Exiting." >&2' ERR

echo "Starting Bolt uninstallation..."

# Remove installed binaries and libraries
if [ -f "/usr/local/bin/bolt" ]; then
  echo "Removing Bolt executable..."
  sudo rm -f /usr/local/bin/bolt
fi

if [ -d "/opt/bolt-launcher" ]; then
  echo "Removing Bolt launcher directory..."
  sudo rm -rf /opt/bolt-launcher
fi

# Remove Bolt source and build directories
if [ -d "$HOME/Bolt" ]; then
  echo "Removing Bolt source directory..."
  rm -rf "$HOME/Bolt"
fi

# Remove application desktop entries
if [ -f "/usr/local/share/applications/bolt-launcher.desktop" ]; then
  echo "Removing desktop entry..."
  sudo rm -f /usr/local/share/applications/bolt-launcher.desktop
fi

# Remove configuration and profile data
echo "Removing Bolt configuration and profiles..."
rm -rf "$HOME/.local/share/bolt-launcher"
rm -rf "$HOME/.config/bolt-launcher"

# Remove JAVA_HOME export from .bashrc
echo "Cleaning up JAVA_HOME setting from .bashrc..."
sed -i '/export JAVA_HOME="\/usr\/lib\/jvm\/java-17-openjdk-amd64"/d' "$HOME/.bashrc"

echo "Bolt has been uninstalled successfully."
echo "Note: Dependencies installed for Bolt (git, cmake, etc.) have not been removed."
echo "Note: Java 17 installation has not been removed. You may need to reset your default Java version if needed."
