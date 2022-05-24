@ECHO OFF

@ECHO OFF & CLS & ECHO.
NET FILE 1>NUL 2>NUL & IF ERRORLEVEL 1 (
	ECHO You must right-click and select
 	ECHO "RUN AS ADMINISTRATOR"  to run this batch. Exiting...
  	TIMEOUT 5
	EXIT
)

SET path=C:\Simba

:CHECK_DIR

IF exist %path% GOTO :DIR_EXISTS
GOTO :MAKE_DIRECTORY_TREE

:DIR_EXISTS
	ECHO Directory exists
	RMDIR /S /Q %path%
GOTO :MAKE_DIRECTORY_TREE

:MAKE_DIRECTORY_TREE
	MKDIR %path%
	MKDIR %path%\Data
	MKDIR %path%\Data\packages
	MKDIR %path%\Includes
	MKDIR %path%\Scripts

ECHO Downloading Simba
CURL -L https://github.com/ollydev/Simba/releases/latest/download/Simba-Win32.exe > %path%\Simba.exe

IF exist %USERPROFILE%\Desktop\Simba.lnk (
	DEL %USERPROFILE%\Desktop\Simba.lnk
)

SET SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
ECHO Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
ECHO sLinkFile = "%USERPROFILE%\Desktop\Simba.lnk" >> %SCRIPT%
ECHO Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
ECHO oLink.TargetPath = "%path%\Simba.exe" >> %SCRIPT%
ECHO oLink.Save >> %SCRIPT%
CSCRIPT /nologo %SCRIPT%
DEL %SCRIPT%

CHOICE /C YN /D Y /T 5 /M "Do you want to install the unofficial SRL?"
IF %ERRORLEVEL% EQU 1 GOTO :UNOFFICIAL_SRL
IF %ERRORLEVEL% EQU 2 GOTO :OFFICIAL_SRL

:UNOFFICIAL_SRL
	ECHO Unoffical SRL is going to be installed.
	SET SRL_LINK=https://github.com/Torwent/SRL/archive/refs/heads/master.zip
	ECHO [Torwent/SRL]>>%path%\Data\packages\packages.ini
GOTO :INSTALL_SRL

:OFFICIAL_SRL
	ECHO Official SRL is going to be installed.
	SET SRL_LINK=https://github.com/ollydev/SRL-Development/archive/refs/heads/master.zip
	ECHO [ollydev/SRL-Development]>>%path%\Data\packages\packages.ini
GOTO :INSTALL_SRL

:INSTALL_SRL
	ECHO Installing SRL...
	ECHO Name=SRL>>%path%\Data\packages\packages.ini
	CURL -L %SRL_LINK% > srl.zip
	TAR -xf srl.zip
	DEL srl.zip
	MOVE SRL* %path%\Includes\SRL
	
:INSTALL_WL
	ECHO Installing WaspLib...
	CURL -L https://github.com/Torwent/WaspLib/archive/refs/heads/master.zip > wl.zip
	TAR -xf wl.zip
	DEL wl.zip
	MOVE WaspLib-master %path%\Includes\WaspLib
	ECHO [Torwent/WaspLib]>>%path%\Data\packages\packages.ini
	ECHO Name=WaspLib>>%path%\Data\packages\packages.ini

CHOICE /C YN /D Y /T 5 /M "Do you want to install the free scripts?"
IF %ERRORLEVEL% EQU 1 GOTO :INSTALL_FREE_SCRIPTS
IF %ERRORLEVEL% EQU 2 GOTO :NEXT_CHOICE

:INSTALL_FREE_SCRIPTS
	ECHO Installing Wasp Free Scripts...
	CURL -L https://github.com/Torwent/wasp-free/archive/refs/heads/master.zip > fwb.zip
	TAR -xf fwb.zip
	DEL fwb.zip
	MOVE wasp-free-master %path%\Scripts\wasp-free
	ECHO [Torwent/wasp-free]>>%path%\Data\packages\packages.ini
	ECHO Name=wasp-free>>%path%\Data\packages\packages.ini
	
:NEXT_CHOICE
	CHOICE /C YN /D N /T 15 /M "Do you want to install the mini scripts? This scripts are not maintaned, may have bugs and can get you banned."
	IF %ERRORLEVEL% EQU 1 GOTO :INSTALL_MINI_SCRIPTS
	IF %ERRORLEVEL% EQU 2 GOTO :EOF
	
:INSTALL_MINI_SCRIPTS
	ECHO Installing Wasp Mini Scripts...
	CURL -L https://github.com/Torwent/wasp-mini/archive/refs/heads/master.zip > mwb.zip
	TAR -xf mwb.zip
	DEL mwb.zip
	MOVE wasp-mini-master %path%\Scripts\wasp-mini
	ECHO [Torwent/wasp-mini]>>%path%\Data\packages\packages.ini
	ECHO Name=wasp-mini>>%path%\Data\packages\packages.ini
