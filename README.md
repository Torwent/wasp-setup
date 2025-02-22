```
 $g,_                               w$	
 $$$$&w,      *, *   * ,*    __,,g$$$$
 *&$$$$$$$&,  *"*$r ,$P" __,g$$$$$$$$_		**          **             _____           *       *   		
  *'*&$&$$$$$,   **_"_   ,$$$$$$&&P"_		\ \        / /            / ____|         (_)     | |     
         *"&$&r  j$$$E  *$&&*  *      		 \ \  /\  / *_ *_*_ *_*| (___   ___ *_* * *__ | |_ ___ 
             1$ $g'*"g& $&_           		  \ \/  \/ / *` / *_| '_ \\___ \ / **| '**| | '_ \| **/ **|
              ] *&$$$$' L             		   \  /\  | (*| \__ | |_) ____) | (__| |  | | |_) | |_\__ \
         *,g&&&rg&,",gg &$$&w,        		    \/  \/ \*_,_|___| .__|_____/ \___|_|  |_| .__/ \__|___/
       ,$$$$$F__$$$$$$$ _"$$$$$g      				    | |                     | | 
      g$$$$$F   "&$$$&"   *$$$$$&				    |*|                     |_| 
    *$$$$$&F    *,g*,,      $$$$$$r   
     *"*&**      "$&$"      *"**"*_   
                   $ 
```

# Wasp-Setup
Automated setup scripts for Simba, RuneLite, and Bolt Launcher on Windows and Linux.

## Windows Installation
For Windows, download the [simba-setup.cmd](./windows/simba-setup.cmd) file, save it, and run it.

## Linux Installation Scripts

### Simba
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/simba-setup.sh
chmod +x simba-setup.sh
./simba-setup.sh
```

The script will:
- Install required dependencies
- Set up necessary directories and download required files
- Add a `simba` alias to your `.bashrc`
- Create a `.desktop` entry for easy access

### RuneLite
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/runelite-setup.sh
chmod +x runelite-setup.sh
./runelite-setup.sh
```

The script will:
- Install required dependencies
- Download the latest `RuneLite.jar` and place it in `/usr/local/bin`
- Set necessary permissions for the `RuneLite.jar` file
- Add a `runelite` alias to `/etc/bash.bashrc` for easy terminal access
- Download and set up the RuneLite icon
- Create a `.desktop` entry for RuneLite
- Copy `myprofile.properties` to the RuneLite profiles directory

### Bolt Launcher (includes RuneLite)
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/bolt-setup.sh
chmod +x bolt-setup.sh
./bolt-setup.sh
```

The script will:
- Install required dependencies
- Build Bolt Launcher from source
- Configure Java environment
- Set up RuneLite profiles automatically
- Create desktop entries and commands

### All-in-One Commands

#### RuneLite + Simba
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/runelite-setup.sh && \
chmod +x runelite-setup.sh && ./runelite-setup.sh && \
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/simba-setup.sh && \
chmod +x simba-setup.sh && ./simba-setup.sh
```

#### Bolt Launcher + Simba
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/bolt-setup.sh && \
chmod +x bolt-setup.sh && ./bolt-setup.sh && \
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/simba-setup.sh && \
chmod +x simba-setup.sh && ./simba-setup.sh
```

## Uninstallation Scripts

### Windows
For Windows, uninstall through Windows Control Panel.

### Linux

#### Simba
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/simba-uninstall.sh
chmod +x simba-uninstall.sh
./simba-uninstall.sh
```

The script will:
- Backup directory `~/Simba/Scripts` to `/home/$USER`
- Remove the Simba directory and its contents
- Remove the `simba` alias from your `.bashrc`
- Delete the `.desktop` entry from local and system-wide directories

#### RuneLite
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/runelite-uninstall.sh
chmod +x runelite-uninstall.sh
./runelite-uninstall.sh
```

The script will:
- Remove the `RuneLite.jar` file from `/usr/local/bin`
- Remove the `runelite` alias from `/etc/bash.bashrc`
- Delete the RuneLite icon from `/usr/local/share`
- Remove the RuneLite `.desktop` entry from `/usr/share/applications`

#### Bolt Launcher
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/bolt-uninstall.sh
chmod +x bolt-uninstall.sh
./bolt-uninstall.sh
```

The script will:
- Remove Bolt executable and libraries
- Remove configuration files
- Clean up environment variables
- Remove desktop entries

## Requirements
- Windows: Windows 7 or higher
- Linux: Debian 10+ or Ubuntu-based distribution

## Note
After installation, you may need to log out and log back in for all changes to take effect. This ensures that environment variables and desktop entries are properly reloaded.
