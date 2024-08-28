#!/bin/bash

echo "Uninstalling RuneLite and removing all associated files..."

# Remove RuneLite.jar from /usr/local/bin
RUNELITE_JAR=/usr/local/bin/RuneLite.jar
if [ -f "$RUNELITE_JAR" ]; then
  echo "Removing RuneLite.jar..."
  sudo rm -f "$RUNELITE_JAR"
else
  echo "RuneLite.jar not found. Skipping removal."
fi

# Remove RuneLite alias from /etc/bash.bashrc
if grep -q "alias runelite=" /etc/bash.bashrc; then
  echo "Removing RuneLite alias from /etc/bash.bashrc..."
  sudo sed -i '/alias runelite=/d' /etc/bash.bashrc
  echo "RuneLite alias removed."
else
  echo "RuneLite alias not found in /etc/bash.bashrc. Skipping removal."
fi

# Remove RuneLite icon from /usr/local/share
RUNELITE_ICON=/usr/local/share/RuneLite.png
if [ -f "$RUNELITE_ICON" ]; then
  echo "Removing RuneLite icon..."
  sudo rm -f "$RUNELITE_ICON"
else
  echo "RuneLite icon not found. Skipping removal."
fi

# Remove the RuneLite desktop entry
DESKTOP_FILE=/usr/share/applications/runelite.desktop
if [ -f "$DESKTOP_FILE" ]; then
  echo "Removing RuneLite desktop entry..."
  sudo rm -f "$DESKTOP_FILE"
else
  echo "RuneLite desktop entry not found. Skipping removal."
fi

# Inform user that uninstallation is complete
echo "Uninstallation complete. You may need to restart your session to apply changes."
