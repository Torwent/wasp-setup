```
 $g,_                               w$	
 $$$$&w,      _, _   _ ,_    __,,g$$$$
 _&$$$$$$$&,  _"*$r ,$P" __,g$$$$$$$$_		__          __             _____           _       _   		
  _'*&$&$$$$$,   _*_"_   ,$$$$$$&&P"_		\ \        / /            / ____|         (_)     | |     
         _"&$&r  j$$$E  _$&&*  _      		 \ \  /\  / __ _ ___ _ __| (___   ___ _ __ _ _ __ | |_ ___ 
             1$ $g'*"g& $&_           		  \ \/  \/ / _` / __| '_ \\___ \ / __| '__| | '_ \| __/ __|
              ] _&$$$$' L             		   \  /\  | (_| \__ | |_) ____) | (__| |  | | |_) | |_\__ \
         _,g&&&rg&,",gg &$$&w,        		    \/  \/ \__,_|___| .__|_____/ \___|_|  |_| .__/ \__|___/
       ,$$$$$F__$$$$$$$ _"$$$$$g      				    | |                     | | 
      g$$$$$F   "&$$$&"   _$$$$$&				    |_|                     |_| 
    _$$$$$&F    _,g*,,      $$$$$$r   
     _"*&*_      "$&$"      _"**"__   
                   $ 
```

Automated WaspScripts setup script

For windows download the [.cmd version](https://raw.githubusercontent.com/Torwent/wasp-setup/master/setup.cmd), save it and run it.

For Linux, assuming you are using Debian 10+ and Bash for your shell, you should only need to copy paste this command:

Official OSRS Client:
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/osrs-setup.sh && bash osrs-setup.sh && rm -rf osrs-setup.sh
```

Simba:
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/setup.sh && bash setup.sh && rm -rf setup.sh
```

If you don't have wget installed:
```bash
sudo apt install wget -y
```


Single command for a brand new server/computer that installs both osrs and Simba:
```bash
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/osrs-setup.sh && \
bash osrs-setup.sh && rm -rf osrs-setup.sh && \
wget https://raw.githubusercontent.com/Torwent/wasp-setup/master/linux/setup.sh && \
bash setup.sh && rm -rf setup.sh
```