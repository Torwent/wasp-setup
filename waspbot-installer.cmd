@ECHO OFF

ECHO Downloading Simba
MKDIR Simba
CURL -L https://github.com/ollydev/Simba/releases/download/simba1400-lape-update/Simba-Win32.exe > Simba/Simba.exe

MKDIR Simba\Data
MKDIR Simba\Data\packages
MKDIR Simba\Includes

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
	ECHO Name=SRL>>Simba\Data\packages\packages.ini
	CURL -L %SRL_LINK% > srl.zip
	TAR -xf srl.zip
	DEL srl.zip
	MOVE SRL* Simba\Includes\SRL
	
:INSTALL_WL
	CURL -L https://github.com/Torwent/WaspLib/archive/refs/heads/master.zip > wl.zip
	TAR -xf wl.zip
	DEL wl.zip
	RENAME WaspLib-master WaspLib
	MOVE WaspLib Simba\Includes\WaspLib
	ECHO [Torwent/WaspLib]>>Simba\Data\packages\packages.ini
	ECHO Name=WaspLib>>Simba\Data\packages\packages.ini

CHOICE /C YN /D Y /M "Do you want to keep git files? They are not required to use the scripts."
IF %ERRORLEVEL% EQU 1 GOTO :DELETE_GIT_FILES
IF %ERRORLEVEL% EQU 2 GOTO :EOF

PAUSE