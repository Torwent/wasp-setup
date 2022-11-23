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

sudo apt install default-jre msitools -y
mkdir ~/osrs
mkdir ~/osrs/cache
mkdir ~/osrs/tmp

cd ~/osrs/tmp

wget -O OldSchool.msi http://www.runescape.com/downloads/OldSchool.msi
msiextract OldSchool.msi
sudo cp ~/osrs/tmp/jagexlauncher/jagexlauncher/bin/jagexappletviewer.jar ~/osrs/osrs.jar
sudo cp ~/osrs/tmp/jagexlauncher/jagexlauncher/oldschool/jagexappletviewer.png ~/osrs/osrs.png
sudo chmod 755 ~/osrs/osrs.jar
rm -rf ~/osrs/tmp

launchCMD="\"java -Djava.class.path=$HOME/osrs/osrs.jar -Dsun.java2d.noddraw=true -Dcom.jagex.config=http://oldschool.runescape.com/jav_config.ws -Duser.home=$HOME/osrs -Dhttps.protocols=TLSv1.2 -Xss2m -Xmx512m -Xms512m -XX:+DisableExplicitGC -XX:+UseAdaptiveGCBoundary -XX:MaxGCPauseMillis=500 -XX:SurvivorRatio=16 -XX:+UseParallelGC -XX:+UnlockExperimentalVMOptions -XX:+TieredCompilation jagexappletviewer $HOME/osrs\""

if ! grep -Fxq "alias osrs" ~/.bashrc; then
	echo "alias osrs=${launchCMD}" | sudo tee --append ~/.bashrc
	source ~/.bashrc
fi

if [ ! -f /usr/share/applications/osrs.desktop ]; then
	echo "[Desktop Entry]" | sudo tee --append /usr/share/applications/osrs.desktop
	echo "Type=Application" | sudo tee --append /usr/share/applications/osrs.desktop
	echo "Exec=${launchCMD}" | sudo tee --append /usr/share/applications/osrs.desktop
	echo "Name=OSRS" | sudo tee --append /usr/share/applications/osrs.desktop
	echo "Comment=Official OSRS Client launcher" | sudo tee --append /usr/share/applications/osrs.desktop
	echo "Icon=$HOME/osrs/osrs.png" | sudo tee --append /usr/share/applications/osrs.desktop
	echo "Categories=Game" | sudo tee --append /usr/share/applications/osrs.desktop	
	echo "Keywords=RuneScape;OSRS;OldSchool;" | sudo tee --append /usr/share/applications/osrs.desktop
fi
