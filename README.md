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
For Windows, download the [setup.cmd](https://raw.githubusercontent.com/Torwent/wasp-setup/master/setup.cmd) file, save it, and run it.

## Linux Installation Scripts

### Simba
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/simba-setup.sh
chmod +x simba-setup.sh
./simba-setup.sh
```

### RuneLite
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/runelite-setup.sh
chmod +x runelite-setup.sh
./runelite-setup.sh
```

### Bolt Launcher (includes RuneLite)
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/bolt-setup.sh
chmod +x bolt-setup.sh
./bolt-setup.sh
```

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

#### RuneLite
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/runelite-uninstall.sh
chmod +x runelite-uninstall.sh
./runelite-uninstall.sh
```

#### Bolt Launcher
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/bolt-uninstall.sh
chmod +x bolt-uninstall.sh
./bolt-uninstall.sh
```

## Requirements
- Windows: Windows 7 or higher
- Linux: Debian 10+ or Ubuntu-based distribution

## Note
After installation, you may need to log out and log back in for all changes to take effect.
