RequestExecutionLevel admin

!define GROUP "SRL"
!define VERSION "2.0.0.1"
!define COPYRIGHT "SRL"
!define DESCRIPTION "Application"
!define INSTALLER_NAME ".\simba-setup.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define REG_ROOT "HKCU"
!define REG_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\Simba"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simba"

######################################################################

VIProductVersion "${VERSION}"
VIAddVersionKey "ProductName"  "Simba"
VIAddVersionKey "CompanyName"  "${GROUP}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

SetCompressor ZLIB
Name "Simba"
Caption "Simba"
OutFile "${INSTALLER_NAME}"
BrandingText "Simba"
XPStyle on
InstallDir "$LOCALAPPDATA\Simba"

######################################################################

!include "MUI.nsh"

!define MUI_ICON ".\Simba\Simba.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP ".\Simba\Simba.ico"
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

!define MUI_FINISHPAGE_RUN "$INSTDIR\Simba64.exe"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

######################################################################

Section -MainProgram
${INSTALL_TYPE}
SetOverwrite on
AccessControl::GrantOnFile "$INSTDIR" "(S-1-5-32-545)" "FullAccess"

Delete "$INSTDIR\Simba.exe"
Delete "$INSTDIR\Simba32.exe"
Delete "$INSTDIR\Simba64.exe"
Delete "$INSTDIR\Data\settings.ini"
Delete "$INSTDIR\Data\default.simba"
Delete "$INSTDIR\COPYING"
Delete "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
Delete "$INSTDIR\Simba website.url"
!endif

RmDir /r "$INSTDIR\Data\packages"
RmDir /r "$INSTDIR\Includes"
RmDir /r "$INSTDIR\Fonts"
RmDir /r "$INSTDIR\Scripts"

SetOutPath "$INSTDIR\Data"
File ".\Simba\Data\default.simba"
SetOutPath "$INSTDIR\Data\packages"
File ".\Simba\Data\packages.ini"

CreateDirectory "$INSTDIR\Data"
CreateDirectory "$INSTDIR\Includes"
CreateDirectory "$INSTDIR\Scripts"
CreateDirectory "$INSTDIR\Scripts\waspscripts.com"
CreateDirectory "$INSTDIR\srlt"
CreateDirectory "$INSTDIR\wl"

inetc::get /caption "Downloading Simba 64 bits" /nocancel "https://github.com/Torwent/Simba/releases/download/Simba1400/Simba-Win64.exe" "$INSTDIR\Simba64.exe" /END
inetc::get /caption "Downloading License" /nocancel "https://raw.githubusercontent.com/Villavu/Simba/Simba1500/COPYING" "$INSTDIR\COPYING" /END
inetc::get /caption "Downloading Launcher" /nocancel "https://raw.githubusercontent.com/Torwent/wasp-launcher/main/launcher.simba" "$INSTDIR\Scripts\wasp-launcher.simba" /END
inetc::get /caption "Downloading SRL-T" /nocancel "https://github.com/Torwent/SRL-T/archive/refs/heads/master.zip" "$INSTDIR\srlt.zip" /END
inetc::get /caption "Downloading WaspLib" /nocancel "https://github.com/Torwent/WaspLib/archive/refs/heads/master.zip" "$INSTDIR\wl.zip" /END

nsisunz::Unzip "$INSTDIR\srlt.zip" "$INSTDIR\srlt"
nsisunz::Unzip "$INSTDIR\wl.zip" "$INSTDIR\wl"

Rename  "$INSTDIR\srlt\SRL-T-master" "$INSTDIR\Includes\SRL-T"
Rename  "$INSTDIR\wl\WaspLib-master" "$INSTDIR\Includes\WaspLib"

RmDir /r "$INSTDIR\srlt"
RmDir /r "$INSTDIR\wl"
RmDir /r "$INSTDIR\Includes\SRL-T\.github"
RmDir /r "$INSTDIR\Includes\WaspLib\.github"

Delete "$INSTDIR\srlt.zip"
Delete "$INSTDIR\wl.zip"
Delete "$INSTDIR\Includes\SRL-T\.gitattributes"
Delete "$INSTDIR\Includes\WaspLib\.gitattributes"
Delete "$INSTDIR\Includes\SRL-T\.gitignore"
Delete "$INSTDIR\Includes\WaspLib\.gitignore"
Delete "$INSTDIR\Includes\SRL-T\.simbapackage"
Delete "$INSTDIR\Includes\WaspLib\.simbapackage"

SectionEnd

######################################################################

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
CreateDirectory "$SMPROGRAMS\$SM_Folder"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Simba64.lnk" "$INSTDIR\Simba64.exe"
CreateShortCut "$DESKTOP\Simba64.lnk" "$INSTDIR\Simba64.exe"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Uninstall Simba.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\Simba website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Simba Website.lnk" "$INSTDIR\Simba website.url"
!endif
!insertmacro MUI_STARTMENU_WRITE_END
!endif

!ifndef REG_START_MENU
CreateDirectory "$SMPROGRAMS\Simba"
CreateShortCut "$SMPROGRAMS\Simba\Simba64.lnk" "$INSTDIR\Simba64.exe"
CreateShortCut "$DESKTOP\Simba64.lnk" "$INSTDIR\Simba64.exe"
CreateShortCut "$DESKTOP\SimbaFolder.lnk" "$INSTDIR\"
CreateShortCut "$SMPROGRAMS\Simba\Uninstall Simba.lnk" "$INSTDIR\uninstall.exe"

!ifdef WEB_SITE
WriteIniStr "$INSTDIR\Simba website.url" "InternetShortcut" "URL" "${WEB_SITE}"
CreateShortCut "$SMPROGRAMS\Simba\Simba Website.lnk" "$INSTDIR\Simba website.url"
!endif
!endif

WriteRegStr ${REG_ROOT} "${REG_PATH}" "" "$INSTDIR\Simba64.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayName" "Simba"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "UninstallString" "$INSTDIR\uninstall.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayIcon" "$INSTDIR\Simba64.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayVersion" "${VERSION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "Publisher" "${GROUP}"

!ifdef WEB_SITE
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "URLInfoAbout" "${WEB_SITE}"
!endif
SectionEnd

######################################################################

Section Uninstall
${INSTALL_TYPE}

Delete "$INSTDIR\Simba.exe"
Delete "$INSTDIR\Simba32.exe"
Delete "$INSTDIR\Simba64.exe"
Delete "$INSTDIR\Data\settings.ini"
Delete "$INSTDIR\COPYING"
Delete "$INSTDIR\uninstall.exe"

RmDir /r "$INSTDIR\Data\packages"
RmDir /r "$INSTDIR\Includes"
RmDir /r "$INSTDIR\Fonts"
RmDir /r "$INSTDIR\Scripts"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_GETFOLDER "Application" $SM_Folder
Delete "$SMPROGRAMS\$SM_Folder\Simba.lnk"
Delete "$SMPROGRAMS\$SM_Folder\Uninstall Simba.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\$SM_Folder\Simba Website.lnk"
!endif
Delete "$DESKTOP\Simba.lnk"

RmDir "$SMPROGRAMS\$SM_Folder"
!endif

!ifndef REG_START_MENU
Delete "$SMPROGRAMS\Simba\Simba.lnk"
Delete "$SMPROGRAMS\Simba\Uninstall Simba.lnk"
!ifdef WEB_SITE
Delete "$SMPROGRAMS\Simba\Simba Website.lnk"
!endif
Delete "$DESKTOP\Simba.lnk"
Delete "$DESKTOP\SimbaFolder.lnk"

RmDir "$SMPROGRAMS\Simba"
!endif

DeleteRegKey ${REG_ROOT} "${REG_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
SectionEnd

######################################################################
