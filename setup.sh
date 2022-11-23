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

sudo apt install libxtst-dev gtk2.0 libgtk2.0-dev libffi-dev libcap2-bin -y
mkdir ~/Simba

wget -O ~/Simba/Simba.ico https://raw.githubusercontent.com/Villavu/Simba/simba1400/Source/Simba/Simba.ico

case `dpkg --print-architecture` in
  aarch64)
    arch="AArch64";;
  arm64)
    arch="AArch64";;
  amd64)
    arch="Linux64";;
  x86_64)
    arch="Linux64";;
  *)
	echo "There's no binary for your architecture. You need to manually compile Simba.";
	Exit 1;;
esac

echo "Installing Simba-${arch}"  
wget -O ~/Simba/Simba https://github.com/Villavu/Simba/releases/download/simba1400-release/Simba-${arch}

chmod +x ~/Simba/Simba
sudo setcap cap_sys_ptrace=eip ~/Simba/Simba

if ! grep -Fxq "alias simba" ~/.bashrc; then
    echo 'alias simba="$HOME/Simba/Simba"' | sudo tee --append ~/.bashrc
	source ~/.bashrc
fi

if [ ! -f /usr/share/applications/simba.desktop ]; then
	echo '[Desktop Entry]' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Type=Application' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Name=Simba' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Comment=Simba 1400' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Exec=~/Simba/Simba' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Icon=/home/username/Simba/Simba.ico' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Categories=Game' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'MimeType=text/simba;text/graph;' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Terminal=false' | sudo tee --append /usr/share/applications/simba.desktop
	echo 'Keywords=Simba;RuneScape;OSRS;' | sudo tee --append /usr/share/applications/simba.desktop
fi