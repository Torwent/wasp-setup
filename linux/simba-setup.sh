#!/bin/bash

cat << "EOF"
						 __          __             _____           _
 $g,_                               w$		 \ \        / /            / ____|         (_)
 $$$$&w,      _, _   _ ,_    __,,g$$$$		  \ \  /\  / /_ _ ___ _ __| (___   ___ _ __ _ _ __  ___
 _&$$$$$$$&,  _"*$r ,$P" __,g$$$$$$$$_		   \ \/  \/ / _` / __| '_ \\___ \ / __| '__| | '_ \/ __|
  _'*&$&$$$$$,   _*_"_   ,$$$$$$&&P"_		    \  /\  / (_| \__ \ |_) |___) | (__| |  | | |_) \__ \
         _"&$&r  j$$$E  _$&&*  _		     \/  \/ \__,_|___/ .__/_____/ \___|_|  |_| .__/|___/
             1$ $g'*"g& $&_				       _____ | |  _                  | |
              ] _&$$$$' L				      / ____||_| | |                 |_|
         _,g&&&rg&,",gg &$$&w,				     | (___   ___| |_ _   _ _ __
       ,$$$$$F__$$$$$$$ _"$$$$$g			      \___ \ / _ \ __| | | | '_ \
      g$$$$$F   "&$$$&"   _$$$$$&			      ____) |  __/ |_| |_| | |_) |
    _$$$$$&F    _,g*,,      $$$$$$r			     |_____/ \___|\__|\__,_| .__/
     _"*&*_      "$&$"      _"**"__			                           | |
                   $   						                   |_|			   
EOF

# Install necessary packages
sudo apt-get install curl tar libxtst-dev gtk2.0 libgtk2.0-dev libffi-dev libcap2-bin -y

# Create required directories
SIMBA_DIR=~/Simba
mkdir -p $SIMBA_DIR/Data/packages $SIMBA_DIR/Includes $SIMBA_DIR/Scripts

# Download and install Simba
wget -O $SIMBA_DIR/Simba.ico https://raw.githubusercontent.com/Villavu/Simba/simba1400/Source/Simba/Simba.ico

case $(dpkg --print-architecture) in
  aarch64|arm64) arch="AArch64";;
  amd64|x86_64) arch="Linux64";;
  *)
    echo "No binary available for your architecture. You need to manually compile Simba."
    exit 1;;
esac

echo "Installing Simba-${arch}"
wget -O $SIMBA_DIR/Simba https://github.com/Villavu/Simba/releases/download/simba1400-release/Simba-${arch}

chmod +x $SIMBA_DIR/Simba
sudo setcap cap_sys_ptrace=eip $SIMBA_DIR/Simba

# Add alias to .bashrc if not present
if ! grep -Fxq "alias simba=" ~/.bashrc; then
    echo 'alias simba="$HOME/Simba/Simba"' >> ~/.bashrc
    source ~/.bashrc
fi

# Create .desktop entry for Simba using echo
DESKTOP_FILE=~/.local/share/applications/simba.desktop
if [ ! -f $DESKTOP_FILE ]; then
    mkdir -p ~/.local/share/applications
    echo '[Desktop Entry]' > $DESKTOP_FILE
    echo 'Type=Application' >> $DESKTOP_FILE
    echo 'Name=Simba' >> $DESKTOP_FILE
    echo 'Comment=Simba 1400' >> $DESKTOP_FILE
    echo "Exec=$SIMBA_DIR/Simba" >> $DESKTOP_FILE
    echo "Icon=$SIMBA_DIR/Simba.ico" >> $DESKTOP_FILE
    echo 'Categories=Game' >> $DESKTOP_FILE
    echo 'MimeType=text/simba;text/graph;' >> $DESKTOP_FILE
    echo 'Terminal=false' >> $DESKTOP_FILE
    echo 'Keywords=Simba;RuneScape;OSRS;' >> $DESKTOP_FILE
fi

# Install SRL-T
echo "Installing SRL-T..."
echo '[Torwent/SRL-T]' >> $SIMBA_DIR/Data/packages/packages.ini
echo 'Name=SRL-T' >> $SIMBA_DIR/Data/packages/packages.ini
curl -L https://github.com/Torwent/SRL-T/archive/refs/heads/master.zip > srl-t.zip
unzip srl-t.zip
rm srl-t.zip
mv SRL-T* $SIMBA_DIR/Includes/SRL-T

# Install WaspLib
echo "Installing WaspLib..."
echo '[Torwent/WaspLib]' >> $SIMBA_DIR/Data/packages/packages.ini
echo 'Name=WaspLib' >> $SIMBA_DIR/Data/packages/packages.ini
curl -L https://github.com/Torwent/WaspLib/archive/refs/heads/master.zip > wl.zip
unzip wl.zip
rm wl.zip
mv WaspLib-master $SIMBA_DIR/Includes/WaspLib

# Install Wasp Free Scripts
echo "Installing Wasp Free Scripts..."
echo '[Torwent/wasp-free]' >> $SIMBA_DIR/Data/packages/packages.ini
echo 'Name=wasp-free' >> $SIMBA_DIR/Data/packages/packages.ini
curl -L https://github.com/Torwent/wasp-free/archive/refs/heads/master.zip > wf.zip
unzip wf.zip
rm wf.zip
mv wasp-free-master $SIMBA_DIR/Scripts/wasp-free

# Create directory for premium scripts
mkdir -p $SIMBA_DIR/Scripts/wasp-premium

echo "Installation complete. You may need to restart your session to apply changes."
