@ECHO OFF

ECHO Downloading Simba
MKDIR Simba
CURL -L https://github.com/ollydev/Simba/releases/download/simba1400-lape-update/Simba-Win32.exe > Simba/Simba.exe

MKDIR Simba\Data
MKDIR Simba\Data\packages
MKDIR Simba\Includes
MKDIR Simba\Scripts

CHOICE /C YN /D Y /T 5 /M "Do you want to install the unofficial SRL?"
SET OFFICIAL=%ERRORLEVEL%
:: UNOFFICIAL = 1, OFICIAL = 2

IF %OFFICIAL% EQU 1 GOTO :UNOFFICIAL_SRL
IF %OFFICIAL% EQU 2 GOTO :OFFICIAL_SRL

:UNOFFICIAL_SRL
	ECHO Unoffical SRL is going to be installed.
	SET SRL_LINK=https://github.com/Torwent/SRL/archive/refs/heads/master.zip
	ECHO [Torwent/SRL]>>Simba\Data\packages\packages.ini
GOTO :INSTALL_SRL

:OFFICIAL_SRL
	ECHO Official SRL is going to be installed.
	SET SRL_LINK=https://github.com/ollydev/SRL-Development/archive/refs/heads/master.zip
	ECHO [ollydev/SRL-Development]>>Simba\Data\packages\packages.ini
GOTO :INSTALL_SRL

:INSTALL_SRL
	ECHO Installing SRL...
	ECHO Name=SRL>>Simba\Data\packages\packages.ini
	CURL -L %SRL_LINK% > srl.zip
	TAR -xf srl.zip
	DEL srl.zip
	MOVE SRL* Simba\Includes\SRL
	
:INSTALL_WL
	ECHO Installing WaspLib...
	CURL -L https://github.com/Torwent/WaspLib/archive/refs/heads/master.zip > wl.zip
	TAR -xf wl.zip
	DEL wl.zip
	MOVE WaspLib-master Simba\Includes\WaspLib
	ECHO [Torwent/WaspLib]>>Simba\Data\packages\packages.ini
	ECHO Name=WaspLib>>Simba\Data\packages\packages.ini

CHOICE /C YN /D Y /T 5 /M "Do you want to install the free scripts?"
IF %ERRORLEVEL% EQU 1 GOTO :INSTALL_FREE_SCRIPTS
IF %ERRORLEVEL% EQU 2 GOTO :NEXT_CHOICE

:INSTALL_FREE_SCRIPTS
	ECHO Installing FreeWaspBots...
	CURL -L https://github.com/Torwent/FreeWaspBots/archive/refs/heads/master.zip > fwb.zip
	TAR -xf fwb.zip
	DEL fwb.zip
	MOVE FreeWaspBots-master Simba\Scripts\FreeWaspBots
	ECHO [Torwent/FreeWaspBots]>>Simba\Data\packages\packages.ini
	ECHO Name=FreeWaspBots>>Simba\Data\packages\packages.ini
	
:NEXT_CHOICE
	CHOICE /C YN /D N /T 15 /M "Do you want to install the mini scripts? This scripts are not maintaned, may have bugs and can get you banned."
	IF %ERRORLEVEL% EQU 1 GOTO :INSTALL_MINI_SCRIPTS
	IF %ERRORLEVEL% EQU 2 GOTO :EOF
	
:INSTALL_MINI_SCRIPTS
	ECHO Installing MiniWaspBots...
	CURL -L https://github.com/Torwent/MiniWaspBots/archive/refs/heads/master.zip > mwb.zip
	TAR -xf mwb.zip
	DEL mwb.zip
	MOVE MiniWaspBots-master Simba\Scripts\MiniWaspBots
	ECHO [Torwent/MiniWaspBots]>>Simba\Data\packages\packages.ini
	ECHO Name=MiniWaspBots>>Simba\Data\packages\packages.ini
	