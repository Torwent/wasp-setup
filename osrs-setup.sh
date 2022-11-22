#!/bin/bash
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

echo 'alias osrs="java -Djava.class.path=$HOME/osrs/osrs.jar -Dsun.java2d.noddraw=true -Dcom.jagex.config=http://oldschool.runescape.com/jav_config.ws -Duser.home=$HOME/osrs -Dhttps.protocols=TLSv1.2 -Xss2m -Xmx512m -Xms512m -XX:+DisableExplicitGC -XX:+UseAdaptiveGCBoundary -XX:MaxGCPauseMillis=500 -XX:SurvivorRatio=16 -XX:+UseParallelGC -XX:+UnlockExperimentalVMOptions -XX:+TieredCompilation jagexappletviewer $HOME/osrs/"' | sudo tee --append ~/.bashrc
source ~/.bashrc

if [ ! -f /usr/share/applications/osrs.desktop ]; then
	echo '[Desktop Entry]' | sudo tee --append /usr/share/applications/osrs.desktop
	echo 'Type=Application' | sudo tee --append /usr/share/applications/osrs.desktop
	echo 'Exec="java -Djava.class.path=$HOME/osrs/osrs.jar -Dsun.java2d.noddraw=true -Dcom.jagex.config=http://oldschool.runescape.com/jav_config.ws -Duser.home=$HOME/osrs -Dhttps.protocols=TLSv1.2 -Xss2m -Xmx512m -Xms512m -XX:+DisableExplicitGC -XX:+UseAdaptiveGCBoundary -XX:MaxGCPauseMillis=500 -XX:SurvivorRatio=16 -XX:+UseParallelGC -XX:+UnlockExperimentalVMOptions -XX:+TieredCompilation jagexappletviewer $HOME/osrs/"' | sudo tee --append /usr/share/applications/osrs.desktop
	echo 'Name=OSRS' | sudo tee --append /usr/share/applications/osrs.desktop
	echo 'Comment=Official OSRS Client launcher' | sudo tee --append /usr/share/applications/osrs.desktop
	echo 'Icon=$HOME/osrs/osrs.png' | sudo tee --append /usr/share/applications/osrs.desktop
	echo 'Categories=Game' | sudo tee --append /usr/share/applications/osrs.desktop	
	echo 'Keywords=RuneScape;OSRS;OldSchool;' | sudo tee --append /usr/share/applications/osrs.desktop
fi
