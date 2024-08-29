# Wasp-Linux-Setup
Linux installation setup for Simba, RuneLite, and associated libraries.

### Simba Installation

1. **Make the Script Executable:**
   If the script is not executable, set the appropriate permissions:

   `chmod +x simba-setup.sh`

2. **Run the Installation Script:**
   Execute the script to install Simba and all its dependencies:
   
   `./simba-setup.sh`

   The script will:
   - Install required dependencies.
   - Set up the necessary directories and download the required files.
   - Add a `simba` alias to your `.bashrc`.
   - Create a `.desktop` entry for easy access.

### Simba Uninstallation

1. **Make the Script Executable:**
   If the script is not executable, set the appropriate permissions:
   
   `chmod +x simba-uninstall.sh`

2. **Run the Uninstallation Script:**
   Execute the script to remove Simba and all associated files:
   
   `./simba-uninstall.sh`

   The script will:
   - Backup directory `~/Simba/Scripts` to `/home/$USER`
   - Remove the Simba directory and its contents.
   - Remove the `simba` alias from your `.bashrc`.
   - Delete the `.desktop` entry from local and system-wide directories.

### RuneLite Installation

1. **Make the Script Executable:**
   If the script is not executable, set the appropriate permissions:
   
   `chmod +x runelite-setup.sh`

2. **Run the Installation Script:**
   Execute the script to install RuneLite:
   
   `./runelite-setup.sh`

   The script will:
   - Install required dependencies.
   - Download the latest `RuneLite.jar` and place it in `/usr/local/bin`.
   - Set the necessary permissions for the `RuneLite.jar` file.
   - Add a `runelite` alias to `/etc/bash.bashrc` for easy terminal access.
   - Download and set up the RuneLite icon.
   - Create a `.desktop` entry for RuneLite.
   - Copy `myprofile.properties` to the RuneLite profiles directory.

### RuneLite Uninstallation

1. **Make the Script Executable:**
   If the script is not executable, set the appropriate permissions:
   
   `chmod +x runelite-uninstall.sh`

2. **Run the Uninstallation Script:**
   Execute the script to remove RuneLite and all associated files:
   
   `./runelite-uninstall.sh`

   The script will:
   - Remove the `RuneLite.jar` file from `/usr/local/bin`.
   - Remove the `runelite` alias from `/etc/bash.bashrc`.
   - Delete the RuneLite icon from `/usr/local/share`.
   - Remove the RuneLite `.desktop` entry from `/usr/share/applications`.

## Note

After running the installation or uninstallation scripts for either Simba or RuneLite, you may need to restart your session or log out and back in for all changes to take effect. This ensures that environment variables and desktop entries are properly reloaded.
