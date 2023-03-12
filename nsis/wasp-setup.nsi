############################################################################################
#      NSIS Installation Script created by NSIS Quick Setup Script Generator v1.09.18
#               Entirely Edited with NullSoft Scriptable Installation System                
#              by Vlasis K. Barkas aka Red Wine red_wine@freemail.gr Sep 2006               
############################################################################################

!define APP_NAME "Simba"
!define COMP_NAME "SRL"
!define VERSION "1.4.0.2"
!define COPYRIGHT "SRL"
!define DESCRIPTION "Application"
!define INSTALLER_NAME ".\simba-setup.exe"
!define MAIN_APP_EXE "Simba.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define REG_ROOT "HKCU"
!define REG_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${MAIN_APP_EXE}"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

######################################################################

VIProductVersion  "${VERSION}"
VIAddVersionKey "ProductName"  "${APP_NAME}"
VIAddVersionKey "CompanyName"  "${COMP_NAME}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

SetCompressor ZLIB
Name "${APP_NAME}"
Caption "${APP_NAME}"
OutFile "${INSTALLER_NAME}"
BrandingText "${APP_NAME}"
XPStyle on
InstallDirRegKey "${REG_ROOT}" "${REG_APP_PATH}" ""
InstallDir "$LOCALAPPDATA\Simba"

######################################################################

!include "MUI.nsh"

!define MUI_ICON ".\Simba\simba.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP ".\Simba\simba.ico"
!define MUI_HEADERIMAGE_RIGHT

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!insertmacro MUI_PAGE_WELCOME

!ifdef LICENSE_TXT
!insertmacro MUI_PAGE_LICENSE "${LICENSE_TXT}"
!endif

!ifdef REG_START_MENU
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Simba"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${REG_ROOT}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${UNINSTALL_PATH}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${REG_START_MENU}"
!insertmacro MUI_PAGE_STARTMENU Application $SM_Folder
!endif

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN "$INSTDIR\${MAIN_APP_EXE}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

######################################################################

Section -MainProgram
${INSTALL_TYPE}
SetOverwrite on
SetOutPath "$INSTDIR\Data"
File ".\Simba\Data\default.simba"
SetOutPath "$INSTDIR\Data\packages"
File ".\Simba\Data\packages\Torwent-SRL-T"
File ".\Simba\Data\packages\Torwent-wasp-free"
File ".\Simba\Data\packages\Torwent-wasp-mini"
File ".\Simba\Data\packages\Torwent-WaspLib"

Delete "$INSTDIR\Simba.exe"
Delete "$INSTDIR\Data\settings.ini"
Delete "$INSTDIR\COPYING"

RmDir /r "$INSTDIR\Data\packages"
RmDir /r "$INSTDIR\Includes"
RmDir /r "$INSTDIR\Fonts"
RmDir /r "$INSTDIR\Scripts"


Delete "$INSTDIR\uninstall.exe"
!ifdef WEB_SITE
Delete "$INSTDIR\${APP_NAME} website.url"
!endif

CreateDirectory "$INSTDIR\Includes"
CreateDirectory "$INSTDIR\Scripts"
CreateDirectory "$INSTDIR\Scripts\wasp-premium"

inetc::get /caption "Downloading Simba" /nocancel "https://github.com/Villavu/Simba/releases/download/simba1400-release/Simba-Win32.exe" "$INSTDIR\Simba.exe" /end
inetc::get /caption "Downloading License" /nocancel "https://raw.githubusercontent.com/Villavu/Simba/simba1500/COPYING" "$INSTDIR\COPYING" /end
inetc::get /caption "Downloading SRL-T" /nocancel "https://github.com/Torwent/SRL-T/archive/refs/heads/master.zip" "$INSTDIR\srlt.zip" /end
inetc::get /caption "Downloading WaspLib" /nocancel "https://github.com/Torwent/WaspLib/archive/refs/heads/master.zip" "$INSTDIR\wl.zip" /end
inetc::get /caption "Downloading wasp-free" /nocancel "https://github.com/Torwent/wasp-free/archive/refs/heads/master.zip" "$INSTDIR\wf.zip" /end

nsisunz::Unzip  "$INSTDIR\srlt.zip" "$INSTDIR\srlt"
nsisunz::Unzip  "$INSTDIR\wl.zip" "$INSTDIR\wl"
nsisunz::Unzip  "$INSTDIR\wf.zip" "$INSTDIR\wf"

Rename  "$INSTDIR\srlt\SRL-T-master" "$INSTDIR\Includes\SRL-T"
Rename  "$INSTDIR\wl\WaspLib-master" "$INSTDIR\Includes\WaspLib"
Rename  "$INSTDIR\wf\wasp-free-master" "$INSTDIR\Scripts\wasp-free"

RmDir "$INSTDIR\srlt"
RmDir "$INSTDIR\wl"
RmDir "$INSTDIR\wf"
RmDir "$INSTDIR\Includes\SRL-T\.github"
RmDir "$INSTDIR\Includes\WaspLib\.github"
RmDir "$INSTDIR\Scripts\wasp-free\.github"

Delete "$INSTDIR\srlt.zip"
Delete "$INSTDIR\wl.zip"
Delete "$INSTDIR\wf.zip"

Delete "$INSTDIR\Includes\SRL-T\.gitattributes"
Delete "$INSTDIR\Includes\WaspLib\.gitattributes"
Delete "$INSTDIR\Scripts\wasp-free\.gitattributes"

Delete "$INSTDIR\Includes\SRL-T\.gitignore"
Delete "$INSTDIR\Includes\WaspLib\.gitignore"
Delete "$INSTDIR\Scripts\wasp-free\.gitignore"

Delete "$INSTDIR\Includes\SRL-T\.simbapackage"
Delete "$INSTDIR\Includes\WaspLib\.simbapackage"
Delete "$INSTDIR\Scripts\wasp-free\.simbapackage"

SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
CreateDirectory "$SMPROGRAMS\$SM_Folder"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP_NAME} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME} Website.lnk" "$INSTDIR\${APP_NAME} website.url"
!endif
!insertmacro MUI_STARTMENU_WRITE_END
!endif

!ifndef REG_START_MENU
CreateDirectory "$SMPROGRAMS\Simba"
CreateShortCut "$SMPROGRAMS\Simba\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$DESKTOP\${APP_NAME}Folder.lnk" "$INSTDIR\"
CreateShortCut "$SMPROGRAMS\Simba\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\${APP_NAME} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\Simba\${APP_NAME} Website.lnk" "$INSTDIR\${APP_NAME} website.url"
!endif
!endif

WriteRegStr ${REG_ROOT} "${REG_APP_PATH}" "" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP_NAME}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" "$INSTDIR\uninstall.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayVersion" "${VERSION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${COMP_NAME}"

!ifdef WEB_SITE
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "URLInfoAbout" "${WEB_SITE}"
!endif
SectionEnd

######################################################################

Section Uninstall
${INSTALL_TYPE}
Delete "$INSTDIR\Simba.exe"
Delete "$INSTDIR\Data\settings.ini"
Delete "$INSTDIR\COPYING"

RmDir /r "$INSTDIR\Data\packages"
RmDir /r "$INSTDIR\Includes"
RmDir /r "$INSTDIR\Fonts"
RmDir /r "$INSTDIR\Scripts"


Delete "$INSTDIR\uninstall.exe"
!ifdef WEB_SITE
Delete "$INSTDIR\${APP_NAME} website.url"
!endif

#RmDir "$INSTDIR"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_GETFOLDER "Application" $SM_Folder
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk"
Delete "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\$SM_Folder\${APP_NAME} Website.lnk"
!endif
Delete "$DESKTOP\${APP_NAME}.lnk"

RmDir "$SMPROGRAMS\$SM_Folder"
!endif

!ifndef REG_START_MENU
Delete "$SMPROGRAMS\Simba\${APP_NAME}.lnk"
Delete "$SMPROGRAMS\Simba\Uninstall ${APP_NAME}.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\Simba\${APP_NAME} Website.lnk"
!endif
Delete "$DESKTOP\${APP_NAME}.lnk"
Delete "$DESKTOP\${APP_NAME}Folder.lnk"

RmDir "$SMPROGRAMS\Simba"
!endif

DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
SectionEnd

######################################################################