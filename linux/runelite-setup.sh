#!/bin/bash

echo "Installing RuneLite and setting up the environment..."

# Install necessary packages
sudo apt-get install wget openjdk-17-jre -y

# Download the latest RuneLite.jar to /usr/local/bin
sudo wget -O /usr/local/bin/RuneLite.jar https://github.com/runelite/launcher/releases/latest/download/RuneLite.jar

# Verify download success
if [ $? -eq 0 ]; then
  echo "RuneLite.jar has been successfully downloaded and placed in /usr/local/bin."
else
  echo "Failed to download RuneLite.jar. Please check your connection and try again."
  exit 1
fi

# Set executable permissions
sudo chmod 755 /usr/local/bin/RuneLite.jar

# Add alias to /etc/bash.bashrc if not present
if ! grep -Fxq "alias runelite=" /etc/bash.bashrc; then
  echo 'alias runelite="java -jar /usr/local/bin/RuneLite.jar"' | sudo tee --append /etc/bash.bashrc
  source /etc/bash.bashrc
fi

# Download and set up the RuneLite icon
sudo wget -O /usr/local/share/RuneLite.png https://github.com/runelite/runelite/raw/master/runelite-client/src/main/resources/net/runelite/client/ui/runelite_128.png

# Create .desktop entry for RuneLite
DESKTOP_FILE=/usr/share/applications/runelite.desktop
if [ ! -f $DESKTOP_FILE ]; then
  sudo bash -c 'echo "[Desktop Entry]" > /usr/share/applications/runelite.desktop'
  sudo bash -c 'echo "Encoding=UTF-8" >> /usr/share/applications/runelite.desktop'
  sudo bash -c 'echo "Type=Application" >> /usr/share/applications/runelite.desktop'
  sudo bash -c 'echo "Exec=java -jar /usr/local/bin/RuneLite.jar" >> /usr/share/applications/runelite.desktop'
  sudo bash -c 'echo "Name=RuneLite" >> /usr/share/applications/runelite.desktop'
  sudo bash -c 'echo "Comment=RuneLite launcher" >> /usr/share/applications/runelite.desktop'
  sudo bash -c 'echo "Icon=/usr/local/share/RuneLite.png" >> /usr/share/applications/runelite.desktop'
  sudo bash -c 'echo "Categories=Game;" >> /usr/share/applications/runelite.desktop'
fi

# Inform user that installation is complete
echo "Installation complete. You may need to restart your session to apply changes."
