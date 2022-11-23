```
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
```

Automated WaspScripts setup script

For windows download the [.cmd version](https://raw.githubusercontent.com/Torwent/wasp-setup/master/setup.cmd), save it and run it.

For Linux, assuming you are using Debian 10+ and Bash for your shell, you should only need to copy paste this command:

Official OSRS Client:
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/osrs-setup.sh && bash osrs-setup.sh && rm -rf osrs-setup.sh
```

Simba:
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/setup.sh && bash setup.sh && rm -rf setup.sh
```

If you don't have wget installed:
```bash
sudo apt install wget -y
```


Single command for a brand new server/computer that installs both osrs and Simba:
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/osrs-setup.sh && \
bash osrs-setup.sh && rm -rf osrs-setup.sh && \
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/setup.sh && \
bash setup.sh && rm -rf setup.sh
```