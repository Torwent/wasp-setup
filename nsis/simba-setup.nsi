############################################################################################
#      NSIS Installation Script created by NSIS Quick Setup Script Generator v1.09.18
#               Entirely Edited with NullSoft Scriptable Installation System                
#              by Vlasis K. Barkas aka Red Wine red_wine@freemail.gr Sep 2006               
############################################################################################

!define APP "Simba"
!define GROUP "SRL"
!define VERSION "2.0.0.0"
!define COPYRIGHT "SRL"
!define DESCRIPTION "Application"
!define INSTALLER_NAME ".\${APP}-setup.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define REG_ROOT "HKCU"
!define REG_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${APP}"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}"

######################################################################

VIProductVersion  "${VERSION}"
VIAddVersionKey "ProductName"  "${APP}"
VIAddVersionKey "CompanyName"  "${GROUP}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

SetCompressor ZLIB
Name "${APP}"
Caption "${APP}"
OutFile "${INSTALLER_NAME}"
BrandingText "${APP}"
XPStyle on
InstallDirRegKey "${REG_ROOT}" "${REG_PATH}" ""
InstallDir "$LOCALAPPDATA\${APP}"

######################################################################

!include "MUI.nsh"

!define MUI_ICON ".\${APP}\${APP}.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP ".\${APP}\${APP}.ico"
!define MUI_HEADERIMAGE_RIGHT

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!insertmacro MUI_PAGE_WELCOME

!ifdef LICENSE_TXT
!insertmacro MUI_PAGE_LICENSE "${LICENSE_TXT}"
!endif

!ifdef REG_START_MENU
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APP}"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${REG_ROOT}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${UNINSTALL_PATH}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${REG_START_MENU}"
!insertmacro MUI_PAGE_STARTMENU Application $SM_Folder
!endif

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN "$INSTDIR\${APP}64.exe"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

######################################################################

Section -MainProgram
${INSTALL_TYPE}
SetOverwrite on

Delete "$INSTDIR\${APP}.exe"
Delete "$INSTDIR\${APP}32.exe"
Delete "$INSTDIR\${APP}64.exe"
Delete "$INSTDIR\Data\settings.ini"
Delete "$INSTDIR\Data\default.${APP}"
Delete "$INSTDIR\COPYING"

Delete "$INSTDIR\uninstall.exe"
!ifdef WEB_SITE
Delete "$INSTDIR\${APP} website.url"
!endif

RmDir /r "$INSTDIR\Data\packages"
RmDir /r "$INSTDIR\Includes"
RmDir /r "$INSTDIR\Fonts"
RmDir /r "$INSTDIR\Scripts"

SetOutPath "$INSTDIR\Data"
File ".\${APP}\Data\default.${APP}"
SetOutPath "$INSTDIR\Data\packages"
File ".\${APP}\Data\packages.ini"

CreateDirectory "$INSTDIR\Data"
CreateDirectory "$INSTDIR\Includes"
CreateDirectory "$INSTDIR\Scripts"
CreateDirectory "$INSTDIR\Scripts\waspscripts.com"

inetc::get /caption "Downloading ${APP} 32 bits" /nocancel "https://github.com/Torwent/${APP}/releases/download/${APP}1400/${APP}-Win32.exe" "$INSTDIR\${APP}32.exe" /end
inetc::get /caption "Downloading ${APP} 64 bits" /nocancel "https://github.com/Torwent/${APP}/releases/download/${APP}1400/${APP}-Win64.exe" "$INSTDIR\${APP}64.exe" /end
inetc::get /caption "Downloading License" /nocancel "https://raw.githubusercontent.com/Villavu/${APP}/${APP}1500/COPYING" "$INSTDIR\COPYING" /end
inetc::get /caption "Downloading Launcher" /nocancel "https://raw.githubusercontent.com/Torwent/wasp-launcher/main/launcher.${APP}" "$INSTDIR\Scripts\wasp-launcher.${APP}" /end
inetc::get /caption "Downloading SRL-T" /nocancel "https://github.com/Torwent/SRL-T/archive/refs/heads/master.zip" "$INSTDIR\srlt.zip" /end
inetc::get /caption "Downloading WaspLib" /nocancel "https://github.com/Torwent/WaspLib/archive/refs/heads/master.zip" "$INSTDIR\wl.zip" /end

nsisunz::Unzip  "$INSTDIR\srlt.zip" "$INSTDIR\srlt"
nsisunz::Unzip  "$INSTDIR\wl.zip" "$INSTDIR\wl"

Rename  "$INSTDIR\srlt\SRL-T-master" "$INSTDIR\Includes\SRL-T"
Rename  "$INSTDIR\wl\WaspLib-master" "$INSTDIR\Includes\WaspLib"

RmDir "$INSTDIR\srlt"
RmDir "$INSTDIR\wl"
RmDir "$INSTDIR\Includes\SRL-T\.github"
RmDir "$INSTDIR\Includes\WaspLib\.github"

Delete "$INSTDIR\srlt.zip"
Delete "$INSTDIR\wl.zip"

Delete "$INSTDIR\Includes\SRL-T\.gitattributes"
Delete "$INSTDIR\Includes\WaspLib\.gitattributes"

Delete "$INSTDIR\Includes\SRL-T\.gitignore"
Delete "$INSTDIR\Includes\WaspLib\.gitignore"

Delete "$INSTDIR\Includes\SRL-T\.${APP}package"
Delete "$INSTDIR\Includes\WaspLib\.${APP}package"

SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
CreateDirectory "$SMPROGRAMS\$SM_Folder"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP}32.lnk" "$INSTDIR\${APP}32.exe"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP}64.lnk" "$INSTDIR\${APP}64.exe"
CreateShortCut "$DESKTOP\${APP}32.lnk" "$INSTDIR\${APP}32.exe"
CreateShortCut "$DESKTOP\${APP}64.lnk" "$INSTDIR\${APP}64.exe"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Uninstall ${APP}.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP} Website.lnk" "$INSTDIR\${APP} website.url"
!endif
!insertmacro MUI_STARTMENU_WRITE_END
!endif

!ifndef REG_START_MENU
CreateDirectory "$SMPROGRAMS\${APP}"
CreateShortCut "$SMPROGRAMS\${APP}\${APP}32.lnk" "$INSTDIR\${APP}32.exe"
CreateShortCut "$SMPROGRAMS\${APP}\${APP}64.lnk" "$INSTDIR\${APP}64.exe"
CreateShortCut "$DESKTOP\${APP}32.lnk" "$INSTDIR\${APP}32.exe"
CreateShortCut "$DESKTOP\${APP}64.lnk" "$INSTDIR\${APP}64.exe"
CreateShortCut "$DESKTOP\${APP}Folder.lnk" "$INSTDIR\"
CreateShortCut "$SMPROGRAMS\${APP}\Uninstall ${APP}.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\${APP}\${APP} Website.lnk" "$INSTDIR\${APP} website.url"
!endif
!endif

WriteRegStr ${REG_ROOT} "${REG_PATH}" "" "$INSTDIR\${APP}32.exe"
WriteRegStr ${REG_ROOT} "${REG_PATH}" "" "$INSTDIR\${APP}64.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" "$INSTDIR\uninstall.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" "$INSTDIR\${APP}32.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" "$INSTDIR\${APP}64.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayVersion" "${VERSION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${GROUP}"

!ifdef WEB_SITE
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "URLInfoAbout" "${WEB_SITE}"
!endif
SectionEnd

######################################################################

Section Uninstall
${INSTALL_TYPE}
Delete "$INSTDIR\${APP}.exe"
Delete "$INSTDIR\${APP}32.exe"
Delete "$INSTDIR\${APP}64.exe"
Delete "$INSTDIR\Data\settings.ini"
Delete "$INSTDIR\COPYING"

RmDir /r "$INSTDIR\Data\packages"
RmDir /r "$INSTDIR\Includes"
RmDir /r "$INSTDIR\Fonts"
RmDir /r "$INSTDIR\Scripts"

Delete "$INSTDIR\uninstall.exe"
!ifdef WEB_SITE
Delete "$INSTDIR\${APP} website.url"
!endif

#RmDir "$INSTDIR"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_GETFOLDER "Application" $SM_Folder
Delete "$SMPROGRAMS\$SM_Folder\${APP}.lnk"
Delete "$SMPROGRAMS\$SM_Folder\Uninstall ${APP}.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\$SM_Folder\${APP} Website.lnk"
!endif
Delete "$DESKTOP\${APP}.lnk"

RmDir "$SMPROGRAMS\$SM_Folder"
!endif

!ifndef REG_START_MENU
Delete "$SMPROGRAMS\${APP}\${APP}.lnk"
Delete "$SMPROGRAMS\${APP}\Uninstall ${APP}.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\${APP}\${APP} Website.lnk"
!endif
Delete "$DESKTOP\${APP}.lnk"
Delete "$DESKTOP\${APP}Folder.lnk"

RmDir "$SMPROGRAMS\${APP}"
!endif

DeleteRegKey ${REG_ROOT} "${REG_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
SectionEnd

######################################################################