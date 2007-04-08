;*******************************************************************************
;  psi.nsi v1.7 - NSIS script for installing Psi 0.9.3
;  Copyright � 2004-2005 Mircea Ionut Bardac (IceRAM)
;
;  This program is free software; you can redistribute it and/or
;  modify it under the terms of the GNU General Public License
;  as published by the Free Software Foundation; either version 2
;  of the License, or (at your option) any later version.
; 
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
; 
;  You should have received a copy of the GNU General Public License
;  along with this file; if not, write to the Free Software
;  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;
;  See ReadME.txt for more information on the script.
;*******************************************************************************

; Installer Script Version
!define INSTALLER_VERSION "1.7"

!define INSTALLER_BUILD "1"
; ^ update whenever you add something to the installer and rebuild it
;   without changing APPVERSION
; ^ reset to 0 when you change APPVERSION

;!define BUILD_WITH_LANGPACKS
; ^ comment if you want to build the installer without language packs

;!define LANG_TEST_BUILD
; ^ uncomment if you want to build a test installer

!ifdef LANG_TEST_BUILD
 !ifndef BUILD_WITH_LANGPACKS
  !define BUILD_WITH_LANGPACKS
 !endif
!endif

; Application name
!define APPNAME "Psi"
!define APPVERSION "0.9.3"
!define APPEXTRAVERSION ""
!define APPFULLVERSION "${APPVERSION}${APPEXTRAVERSION}"
!define APPNAMEANDVERSION "${APPNAME} ${APPFULLVERSION}"

!define LCAPPNAME "psi" ; lowercase APPNAME

; Version information for the installer executable
VIAddVersionKey ProductName "${APPNAME}"
VIAddVersionKey ProductVersion "${APPFULLVERSION}"
VIAddVersionKey Comments "${APPNAMEANDVERSION} Installer - Win32 Installer v${INSTALLER_VERSION} build ${INSTALLER_BUILD} � 2004-2005 Mircea Ionut Bardac (IceRAM)"
VIAddVersionKey CompanyName ""
VIAddVersionKey LegalCopyright ""
VIAddVersionKey FileDescription "${APPNAMEANDVERSION} Installer (build ${INSTALLER_BUILD}) - Win32 Installer v${INSTALLER_VERSION}"
VIAddVersionKey FileVersion "${INSTALLER_VERSION}b${INSTALLER_BUILD}"
VIAddVersionKey InternalName "${APPNAMEANDVERSION} Installer  (build ${INSTALLER_BUILD}) - Win32 Installer v${INSTALLER_VERSION}"
VIAddVersionKey LegalTrademarks ""
!ifdef LANG_TEST_BUILD
  VIAddVersionKey OriginalFilename "${LCAPPNAME}-${APPFULLVERSION}-win-langtest.exe"
  VIAddVersionKey PrivateBuild "Language Packs Included: all available"
!else
 !ifdef BUILD_WITH_LANGPACKS
  VIAddVersionKey OriginalFilename "${LCAPPNAME}-${APPFULLVERSION}-win-setup-i18n.exe"
  VIAddVersionKey PrivateBuild "Language Packs Included: yes"
 !else
  VIAddVersionKey OriginalFilename "${LCAPPNAME}-${APPFULLVERSION}-win-setup.exe"
  VIAddVersionKey PrivateBuild "Language Packs Included: none"
 !endif
!endif
VIAddVersionKey SpecialBuild "Build number: ${INSTALLER_BUILD}"
VIProductVersion "${APPVERSION}.${INSTALLER_BUILD}"

SetCompressor lzma

Var DONE_INIT
Var RUN_BY_ADMIN
Var INST_CONTEXT

var LSTR_SHORTCUTS
var LSTR_CURRENTUSER
var LSTR_ALLUSERS
var LSTR_QUICKLAUNCH
var LSTR_DESKTOP_S
var LSTR_STARTMENU_GROUP
var LSTR_ASK_EXIT_PSI
var LSTR_UNINST_RUNNING
var LSTR_INST_RUNNING
var LSTR_WARN_ADMIN_1
var LSTR_WARN_ADMIN_2
var LSTR_PSIBASE
var LSTR_LANGUAGES
var LSTR_AUTOSTART
var LSTR_A_INSTALLED
var LSTR_ERR_UNINST

!include "Sections.nsh"
!include "installer-functions.nsh"

!define XPSTYLE on

BrandingText "- ${APPNAMEANDVERSION} installer - build ${INSTALLER_BUILD} / script ver. ${INSTALLER_VERSION} / � 2004-2005 Mircea Ionut Bardac (IceRAM) "
!define HOME_URL "http://psi.affinix.com/"

!define INSTALLER_SOURCE "C:\dev\psi_installer"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\Psi"
!ifdef LANG_TEST_BUILD
 OutFile "${LCAPPNAME}-${APPFULLVERSION}-win-langtest.exe"
!else
 !ifdef BUILD_WITH_LANGPACKS
  OutFile "${LCAPPNAME}-${APPFULLVERSION}-win-setup-i18n.exe"
 !else
  OutFile "${LCAPPNAME}-${APPFULLVERSION}-win-setup.exe"
 !endif
!endif

InstallDirRegKey HKLM "Software\Affinix\${APPNAME}" ""

; Modern interface settings
!include "MUI.nsh"

;--------------------------------
;Page settings
!define MUI_ICON "${INSTALLER_SOURCE}\install.ico"
!define MUI_UNICON "${INSTALLER_SOURCE}\uninstall.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${INSTALLER_SOURCE}\psi-header-l.bmp"
!define MUI_HEADERIMAGE_BITMAP_RTL "${INSTALLER_SOURCE}\psi-header-r.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${INSTALLER_SOURCE}\psi-header-l.bmp"
!define MUI_HEADERIMAGE_UNBITMAP_RTL "${INSTALLER_SOURCE}\psi-header-r.bmp"

!define MUI_ABORTWARNING
!define MUI_COMPONENTSPAGE_NODESC

!define MUI_FINISHPAGE_RUN "$INSTDIR\Psi.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Readme.txt"

!define MUI_FINISHPAGE_LINK "Psi - Home page"
!define MUI_FINISHPAGE_LINK_LOCATION "http://psi.affinix.com/"

!define MUI_WELCOMEFINISHPAGE_BITMAP "${INSTALLER_SOURCE}\psi-l.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${INSTALLER_SOURCE}\psi-l.bmp"
;!define MUI_LICENSEPAGE_CHECKBOX

;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKLM"
  !define MUI_LANGDLL_REGISTRY_KEY "Software\Affinix\${APPNAME}"
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

PAGE custom InitRoutines
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${INSTALLER_SOURCE}\psi_app\COPYING"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

UNINSTPAGE custom un.InitRoutines
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages
  !include "installer-languages.nsh"

;--------------------------------
;Reserve Files
  !insertmacro MUI_RESERVEFILE_LANGDLL
;--------------------------------

; macro for creating urls
!Macro "CreateURL" "URLFile" "URLSite"
WriteINIStr "$INSTDIR\${URLFile}.url" "InternetShortcut" "URL" "${URLSite}"
!macroend
;--------------------------------

;*********************************
; Sections of the installer

Section "!$LSTR_PSIBASE" SectionBase
  ; Set Section properties
  SetOverwrite on
  SectionIn RO
  ; Set Section Files and Shortcuts
!ifndef LANG_TEST_BUILD
 !include "psi_files_install.nsi"
!else
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_app\COPYING" ;install only one file when LANG_TEST_BUILD
!endif
  SetOutPath "$INSTDIR\"
  !insertmacro "CreateURL" "Psi - Home page" "http://psi.affinix.com/"
  !insertmacro "CreateURL" "Psi - Forum" "http://psi.affinix.com/forums/"
  !insertmacro "CreateURL" "Psi - Documentation" "http://psi.affinix.com/psi_docs/"
SectionEnd

Section "Crystal Iconsets" SectionCrystalIconsets
  ; Set Section properties
  SetOutPath "$INSTDIR\iconsets\roster"
  File "${INSTALLER_SOURCE}\psi_app\iconsets\roster\crystal_aim.jisp"
  File "${INSTALLER_SOURCE}\psi_app\iconsets\roster\crystal_icq.jisp"
  File "${INSTALLER_SOURCE}\psi_app\iconsets\roster\crystal_msn.jisp"
  File "${INSTALLER_SOURCE}\psi_app\iconsets\roster\crystal_roster.jisp"
  File "${INSTALLER_SOURCE}\psi_app\iconsets\roster\crystal_transport.jisp"
  File "${INSTALLER_SOURCE}\psi_app\iconsets\roster\crystal_yahoo.jisp"
  SetOutPath "$INSTDIR\iconsets\system"
  File "${INSTALLER_SOURCE}\psi_app\iconsets\system\crystal_system.jisp"
SectionEnd



; ********************************

!ifdef BUILD_WITH_LANGPACKS
SubSection "$LSTR_LANGUAGES" SectionLang

; Czech
Section /o "Czech" LangCS
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_cs.qm"
SectionEnd

; Dutch
Section /o "Dutch" LangNL
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_nl.qm"
SectionEnd

; Estonian
Section /o "Estonian" LangET
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_et.qm"
SectionEnd

; French
Section /o "French" LangFR
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_fr.qm"
SectionEnd

; German
Section /o "German" LangDE
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_de.qm"
SectionEnd

; Greek
Section /o "Greek" LangEL
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_el.qm"
SectionEnd

; Macedonian
Section /o "Macedonian" LangMK
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_mk.qm"
SectionEnd

; Polish
Section /o "Polish" LangPL
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_pl.qm"
SectionEnd

; Simplified Chinese
Section /o "Simplified Chinese" LangZH
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_zh.qm"
SectionEnd

; Spanish
Section /o "Spanish" LangES
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_es.qm"
SectionEnd

; Russian
Section /o "Russian" LangRU
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_ru.qm"
SectionEnd

; Slovak
Section /o "Slovak" LangSK
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_sk.qm"
SectionEnd

; Vietnamese
Section /o "Vietnamese" LangVI
  SetOverwrite on
  SetOutPath "$INSTDIR\"
  File "${INSTALLER_SOURCE}\psi_lang\psi_vi.qm"
SectionEnd


; *** FOLLOW THE PATTERN WHEN ADDING LANGUAGES
SubSectionEnd
!endif

Section "$LSTR_STARTMENU_GROUP ($INST_CONTEXT)" SectionSM
 StrCmp $RUN_BY_ADMIN "true" sm_admin
 sm_normal:
  SetShellVarContext current
  Goto sm_done
 sm_admin:
  SetShellVarContext all
 sm_done:
  CreateDirectory "$SMPROGRAMS\Psi"
  SetOutPath "$INSTDIR\"
  CreateShortCut "$SMPROGRAMS\Psi\Psi - Forum.lnk" "$INSTDIR\Psi - Forum.url"
  CreateShortCut "$SMPROGRAMS\Psi\Psi - Documentation.lnk" "$INSTDIR\Psi - Documentation.url"
  CreateShortCut "$SMPROGRAMS\Psi\Psi - Home page.lnk" "$INSTDIR\Psi - Home page.url"
  CreateShortCut "$SMPROGRAMS\Psi\Psi.lnk" "$INSTDIR\Psi.exe"
  CreateShortCut "$SMPROGRAMS\Psi\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$SMPROGRAMS\Psi\ReadME.lnk" "$INSTDIR\Readme.txt"
  SetShellVarContext current
SectionEnd

; ********************************
SubSection "$LSTR_SHORTCUTS ($LSTR_CURRENTUSER)" SectionShortcuts
  Section "$LSTR_DESKTOP_S" SectionSD
   SetShellVarContext current
   SetOutPath "$INSTDIR\"
   CreateShortCut "$DESKTOP\Psi.lnk" "$INSTDIR\Psi.exe"
  SectionEnd
  Section /o "$LSTR_QUICKLAUNCH" SectionQuickLaunch
   SetShellVarContext current
   SetOutPath "$INSTDIR\"
   CreateShortCut "$QUICKLAUNCH\Psi.lnk" "$INSTDIR\Psi.exe"
  SectionEnd
SubSectionEnd

Section "$LSTR_AUTOSTART ($LSTR_CURRENTUSER)" SectionAutomaticStartup
  SetShellVarContext current
  SetOutPath "$INSTDIR\"
  CreateShortCut "$SMSTARTUP\Psi.lnk" "$INSTDIR\Psi.exe"
;  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "Psi" "$INSTDIR\Psi.exe"
;  ^ doesn't work - Psi is not started with the correct working dir
SectionEnd

Section -FinishSection
 StrCmp $RUN_BY_ADMIN "true" lastsettings_is_admin
  WriteRegStr HKCU "Software\Affinix\${APPNAME}" "" "$INSTDIR"
  WriteRegStr HKCU "Software\Affinix\${APPNAME}" "Version" "${APPFULLVERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME} (remove only)"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
  Goto lastsettings_done
 lastsettings_is_admin:
  WriteRegStr HKLM "Software\Affinix\${APPNAME}" "" "$INSTDIR"
  WriteRegStr HKLM "Software\Affinix\${APPNAME}" "Version" "${APPFULLVERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME} (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"

 lastsettings_done:
 WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

; ***************************************
; installer initialization

Function InitRoutines

 StrCmp $DONE_INIT "1" done_init

 StrCpy $DONE_INIT "1"

; MessageBox MB_OK "Installing in $LANGUAGE"
 !insertmacro INIT_LANG_STRINGS

; allow only one instance of the installer
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "psi${APPFULLVERSION}-installer") i .r1 ?e'
  Pop $R0
  StrCmp $R0 0 +3
    MessageBox MB_OK "$LSTR_INST_RUNNING"
    Quit
; ****************
  
; close active Psi sessions
  Call ClosePsiInstances
; ****************

; check for an existing installation of Psi
  Call UninstallPreviousPsi
; ****************
 
 Call IsUserAdmin
 Pop $R0
 StrCpy $RUN_BY_ADMIN $R0 ; saving information
 StrCmp $R0 "true" is_admin
   ; not an admin
   MessageBox MB_OK|MB_ICONINFORMATION "$LSTR_WARN_ADMIN_1$\n$\n$LSTR_WARN_ADMIN_2"
   StrCpy $INST_CONTEXT $LSTR_CURRENTUSER
   goto done_init
 is_admin:
   StrCpy $INST_CONTEXT $LSTR_ALLUSERS
 done_init:
FunctionEnd

Function .onInit
; permit the user to choose the installer language
; the setting will be used to automatically select a language pack if availaible
  !insertmacro MUI_LANGDLL_DISPLAY
; ****************

; expand Shorcuts Section
  SectionGetFlags ${SectionShortcuts} $0
  IntOp $0 $0 | ${SF_EXPAND}
  SectionSetFlags ${SectionShortcuts} $0

; ****************

!ifdef BUILD_WITH_LANGPACKS
; automatically choose language pack to install

 StrCmp $LANGUAGE ${LANG_CZECH} 0 +2
  SectionSetFlags ${LangCS} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_ESTONIAN} 0 +2
  SectionSetFlags ${LangET} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_DUTCH} 0 +2
  SectionSetFlags ${LangNL} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_FRENCH} 0 +2
  SectionSetFlags ${LangFR} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_GERMAN} 0 +2
  SectionSetFlags ${LangDE} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_GREEK} 0 +2
  SectionSetFlags ${LangEL} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_MACEDONIAN} 0 +2
  SectionSetFlags ${LangMK} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_POLISH} 0 +2
  SectionSetFlags ${LangPL} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_SIMPCHINESE} 0 +2
  SectionSetFlags ${LangZH} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_SPANISH} 0 +2
  SectionSetFlags ${LangES} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_RUSSIAN} 0 +2
  SectionSetFlags ${LangRU} ${SF_SELECTED}
 StrCmp $LANGUAGE ${LANG_SLOVAK} 0 +2
  SectionSetFlags ${LangSK} ${SF_SELECTED}
; no Vietnamese AutoSelection
  ; *** FOLLOW THE PATTERN WHEN ADDING LANGUAGES
; ****************
!endif

  StrCpy $DONE_INIT "0"
  ; init strings now

FunctionEnd

; ******************************************************
; Uninstall functions

; function that checks if the user running the UNinstaller is an Administrator
Function un.IsUserAdmin
 Push $R0
 Push $R1
 Push $R2

 ClearErrors
 UserInfo::GetName
 IfErrors Win9x
 Pop $R1
 UserInfo::GetAccountType
 Pop $R2

 StrCmp $R2 "Admin" 0 Continue
 StrCpy $R0 "true"
 Goto Done

 Continue:
  StrCmp $R2 "" Win9x
 StrCpy $R0 "false"
  Goto Done

 Win9x:
  StrCpy $R0 "true"

 Done:
 Pop $R2
 Pop $R1
 Exch $R0
FunctionEnd

; ********************************
; Close Psi Instances
; Waits for all running instances of Psi to close
Function un.ClosePsiInstances
    Push $0 ;saving stack
  newcheck:
    FindWindow $0 "QWidget" "Psi" 0
    IntCmp $0 0 done
    MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "$LSTR_ASK_EXIT_PSI" IDRETRY newcheck
    ; cancel
    Quit
  done:
    Pop $0 ; restoring stack
FunctionEnd

Function un.InitRoutines

; MessageBox MB_OK "Uninstalling"

 StrCmp $DONE_INIT "1" done_un_init

 StrCpy $DONE_INIT "1"

 !insertmacro INIT_LANG_STRINGS

; allow only one instance of the uninstaller
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "psi${APPFULLVERSION}-uninstaller") i .r1 ?e'
  Pop $R0
  StrCmp $R0 0 +3
    MessageBox MB_OK "$LSTR_UNINST_RUNNING"
    Abort

  ;ask the user to close all psi instances on uninstall
  Call un.ClosePsiInstances
  done_un_init:
FunctionEnd

Function un.onInit
; ****************
  ;uninstall saved language setting
  !insertmacro MUI_UNGETLANGUAGE

  StrCpy $DONE_INIT "0"

FunctionEnd

;Uninstall section
Section Uninstall
  ;Remove from registry...
 Call un.IsUserAdmin
 Pop $R0
 StrCmp $R0 "true" uninstall_is_admin
   DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
   DeleteRegKey HKCU "Software\Affinix\${APPNAME}"
   Goto uninstall_done
  uninstall_is_admin:
   DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
   DeleteRegKey HKLM "Software\Affinix\${APPNAME}"
  uninstall_done:

  ; Delete self
  Delete "$INSTDIR\uninstall.exe"

  ; Delete Crystal Iconsets
  Delete "$INSTDIR\iconsets\roster\crystal_aim.jisp"
  Delete "$INSTDIR\iconsets\roster\crystal_icq.jisp"
  Delete "$INSTDIR\iconsets\roster\crystal_msn.jisp"
  Delete "$INSTDIR\iconsets\roster\crystal_roster.jisp"
  Delete "$INSTDIR\iconsets\roster\crystal_transport.jisp"
  Delete "$INSTDIR\iconsets\roster\crystal_yahoo.jisp"
  Delete "$INSTDIR\iconsets\system\crystal_system.jisp"
  
  
  ; Delete links
  Delete "$INSTDIR\Psi - Forum.url";
  Delete "$INSTDIR\Psi - Home page.url";
  Delete "$INSTDIR\Psi - Documentation.url";

  ; Delete Shortcuts
  SetShellVarContext current
  Delete "$DESKTOP\Psi.lnk"
  Delete "$SMPROGRAMS\Psi\Psi.lnk"
  Delete "$SMPROGRAMS\Psi\Uninstall.lnk"
  Delete "$SMPROGRAMS\Psi\ReadME.lnk"
  Delete "$QUICKLAUNCH\Psi.lnk"
  Delete "$SMPROGRAMS\Psi\Psi - Forum.lnk"
  Delete "$SMPROGRAMS\Psi\Psi - Home page.lnk"
  Delete "$SMPROGRAMS\Psi\Psi - Documentation.lnk"
  RMDir "$SMPROGRAMS\Psi"

  SetShellVarContext all
  Delete "$DESKTOP\Psi.lnk"
  Delete "$SMPROGRAMS\Psi\Psi.lnk"
  Delete "$SMPROGRAMS\Psi\Uninstall.lnk"
  Delete "$SMPROGRAMS\Psi\ReadME.lnk"
  Delete "$QUICKLAUNCH\Psi.lnk"
  Delete "$SMPROGRAMS\Psi\Psi - Forum.lnk"
  Delete "$SMPROGRAMS\Psi\Psi - Home page.lnk"
  Delete "$SMPROGRAMS\Psi\Psi - Documentation.lnk"
  RMDir "$SMPROGRAMS\Psi"

  ; DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "Psi"
  ; ^ Registry shortcut doesn't work
  SetShellVarContext current
  Delete "$SMSTARTUP\Psi.lnk"

!ifdef BUILD_WITH_LANGPACKS
  ; Delete Language files
  Delete "$INSTDIR\psi_cs.qm"
  Delete "$INSTDIR\psi_et.qm"
  Delete "$INSTDIR\psi_nl.qm"
  Delete "$INSTDIR\psi_fr.qm"
  Delete "$INSTDIR\psi_de.qm"
  Delete "$INSTDIR\psi_el.qm"
  Delete "$INSTDIR\psi_mk.qm"
  Delete "$INSTDIR\psi_pl.qm"
  Delete "$INSTDIR\psi_zh.qm"
  Delete "$INSTDIR\psi_es.qm"
  Delete "$INSTDIR\psi_ru.qm"
  Delete "$INSTDIR\psi_sk.qm"
  Delete "$INSTDIR\psi_vi.qm"
  ; *** FOLLOW THE PATTERN WHEN ADDING LANGUAGES
!endif

  ; Clean up Psi (base)
  !include "psi_files_uninstall.nsi"
SectionEnd


Function UninstallPreviousPsi

 Call IsUserAdmin
 Pop $R0
 StrCpy $RUN_BY_ADMIN $R0 ; saving information
 StrCmp $R0 "true" unppsi_is_admin
  ReadRegStr $R0 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString"
	ReadRegStr $R1 HKCU "Software\Affinix\${APPNAME}" ""
  goto unppsi_done
 unppsi_is_admin:
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString"
	ReadRegStr $R1 HKLM "Software\Affinix\${APPNAME}" ""
 unppsi_done:
  ; $R0 holds the path to the uninstaller
  ; $R1 holds the install dir
  StrCmp $R0 "" auto_uninstall_done

  MessageBox MB_YESNO|MB_ICONEXCLAMATION "$LSTR_A_INSTALLED" \
   IDYES auto_uninstall_yes \
   IDNO auto_uninstall_done

  ;Run the uninstaller
  auto_uninstall_yes:
   ClearErrors
   ExecWait '$R0 /S _?=$INSTDIR'
    ;Uninstall silently
    ;Do not copy the uninstaller to a temp file

   IfErrors no_remove_uninstaller
   Goto auto_uninstall_done

  no_remove_uninstaller:
  MessageBox MB_YESNO|MB_ICONQUESTION "$LSTR_ERR_UNINST" \
   IDYES auto_uninstall_done \
   IDNO auto_uninstall_exit

  auto_uninstall_exit:
  Quit
   
  auto_uninstall_done:

FunctionEnd

; eof