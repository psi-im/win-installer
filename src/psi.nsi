;*******************************************************************************
;  psi.nsi - NSIS installer script for Psi
;
;  Copyright (c) 2004-2008 Mircea Bardac (IceRAM)
;  E-mail: dev@mircea.bardac.net
;  XMPP:   iceram@jabber.org
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

Unicode true

; Installer Script Version
!define INSTALLER_VERSION "3.0"

; Psi Installer Configuration File
!include "..\config.nsh"

; to uninstall only installed files
!include "UninstallLog.nsh"

; Application name
!define APPNAME "Psi"

!define APPFULLVERSION "${APPVERSION}${APPEXTRAVERSION}"
!define APPNAMEANDVERSION "${APPNAME} ${APPFULLVERSION}"

!define LCAPPNAME "psi" ; lowercase APPNAME

!define INSTALLER_COPYRIGHT_YEAR "2004-2017"

!define REG_APP_PATH "Software\psi-im.org\${APPNAME}"
!define REG_UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"

; Version information for the installer executable
VIAddVersionKey ProductName "${APPNAME}"
VIAddVersionKey ProductVersion "${APPFULLVERSION}"
VIAddVersionKey Comments "${APPNAMEANDVERSION} installer - build ${INSTALLER_BUILD} / script ver. ${INSTALLER_VERSION} (c) ${INSTALLER_COPYRIGHT_YEAR} The Psi Team"
VIAddVersionKey CompanyName ""
VIAddVersionKey LegalCopyright ""
VIAddVersionKey FileDescription "${APPNAMEANDVERSION} Installer (build ${INSTALLER_BUILD}) - Win32 Installer v${INSTALLER_VERSION}"
VIAddVersionKey FileVersion "${INSTALLER_VERSION}b${INSTALLER_BUILD}"
VIAddVersionKey InternalName "${APPNAMEANDVERSION} Installer  (build ${INSTALLER_BUILD}) - Win32 Installer v${INSTALLER_VERSION}"
VIAddVersionKey LegalTrademarks ""
!ifdef BUILD_WITH_LANGPACKS
!ifdef BUILD_32
  VIAddVersionKey OriginalFilename "${LCAPPNAME}-${APPFULLVERSION}-win32-setup.exe"
!else
  VIAddVersionKey OriginalFilename "${LCAPPNAME}-${APPFULLVERSION}-win64-setup.exe"
!endif
  VIAddVersionKey PrivateBuild "Language Packs Included: yes"
!else
!ifdef BUILD_32
  VIAddVersionKey OriginalFilename "${LCAPPNAME}-${APPFULLVERSION}-win32-setup-base.exe"
!else
  VIAddVersionKey OriginalFilename "${LCAPPNAME}-${APPFULLVERSION}-win64-setup-base.exe"
!endif
  VIAddVersionKey PrivateBuild "Language Packs Included: none"
!endif
VIAddVersionKey SpecialBuild "Build number: ${INSTALLER_BUILD}"
VIProductVersion "${APPVERSION}.0.${INSTALLER_BUILD}"

SetCompressor lzma

Var DONE_INIT
Var RUN_BY_ADMIN
Var INST_CONTEXT

Var LSTR_SHORTCUTS
Var LSTR_CURRENTUSER
Var LSTR_ALLUSERS
Var LSTR_QUICKLAUNCH
Var LSTR_DESKTOP_S
Var LSTR_STARTMENU_GROUP
Var LSTR_ASK_EXIT_PSI
Var LSTR_UNINST_RUNNING
Var LSTR_INST_RUNNING
Var LSTR_WARN_ADMIN_1
Var LSTR_WARN_ADMIN_2
Var LSTR_PSIBASE
Var LSTR_LANGUAGES
Var LSTR_AUTOSTART
Var LSTR_A_INSTALLED
Var LSTR_ERR_UNINST

!include "Sections.nsh"
!include "installer-functions.nsh"

!define XPSTYLE on

BrandingText "- ${APPNAMEANDVERSION} installer - build ${INSTALLER_BUILD} / script ver. ${INSTALLER_VERSION} (c) ${INSTALLER_COPYRIGHT_YEAR} The Psi Team "
!define HOME_URL "http://psi-im.org/"

; Main Install settings
; !define APP_BUILD "${INSTALLER_HOME}${FILE_SEPARATOR}build${FILE_SEPARATOR}"
!define INSTALLER_SRC "${INSTALLER_HOME}${FILE_SEPARATOR}src${FILE_SEPARATOR}"
; !define APP_SOURCE "${APP_BUILD}psi_app${FILE_SEPARATOR}"

Name "${APPNAMEANDVERSION}"
!ifdef BUILD_32
  InstallDir "$PROGRAMFILES\${APPNAME}"
!else
  InstallDir "$PROGRAMFILES64\${APPNAME}"
!endif
!ifdef BUILD_WITH_LANGPACKS
!ifdef BUILD_32
  OutFile "${APP_BUILD}${LCAPPNAME}-${APPFULLVERSION}-win32-setup.exe"
!else
  OutFile "${APP_BUILD}${LCAPPNAME}-${APPFULLVERSION}-win64-setup.exe"
!endif
!else
!ifdef BUILD_32
  OutFile "${APP_BUILD}${LCAPPNAME}-${APPFULLVERSION}-win32-setup-base.exe"
!else
  OutFile "${APP_BUILD}${LCAPPNAME}-${APPFULLVERSION}-win64-setup-base.exe"
!endif
!endif

InstallDirRegKey HKLM "${REG_APP_PATH}" ""

; Modern interface settings
!include "MUI2.nsh"

;--------------------------------
;Page settings
!define MUI_ICON "${INSTALLER_SRC}install.ico"
!define MUI_UNICON "${INSTALLER_SRC}uninstall.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${INSTALLER_SRC}psi-header-l.bmp"
!define MUI_HEADERIMAGE_BITMAP_RTL "${INSTALLER_SRC}psi-header-r.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${INSTALLER_SRC}psi-header-l.bmp"
!define MUI_HEADERIMAGE_UNBITMAP_RTL "${INSTALLER_SRC}psi-header-r.bmp"

!define MUI_ABORTWARNING
!define MUI_COMPONENTSPAGE_NODESC

!define MUI_FINISHPAGE_RUN "$INSTDIR\Psi.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Readme.txt"

!define MUI_FINISHPAGE_LINK "Click here to visit the Psi Homepage"
!define MUI_FINISHPAGE_LINK_LOCATION "http://psi-im.org"

!define MUI_WELCOMEFINISHPAGE_BITMAP "${INSTALLER_SRC}psi-l.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${INSTALLER_SRC}psi-l.bmp"
;!define MUI_LICENSEPAGE_CHECKBOX

;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKLM"
  !define MUI_LANGDLL_REGISTRY_KEY "${REG_APP_PATH}"
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

PAGE custom InitRoutines
!define MUI_PAGE_CUSTOMFUNCTION_SHOW CompNames
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${APP_SOURCE}COPYING"
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
${WriteIniStr} "$INSTDIR\${URLFile}.url" "InternetShortcut" "URL" "${URLSite}"
!macroend
;--------------------------------

;*********************************
; Sections of the installer

!include "UnInstallLog-section.nsh"

;-------------------------------
; Test if Visual Studio Redistributables 2015 v14.0.23918 installed
; Returns -1 if there is no VC redistributables intstalled
Function CheckVCRedist
   Push $R0
   ClearErrors
   ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{5DFEB60C-501E-375A-9967-99BBCB6150C5}" "Version"

   IfErrors 0 VSRedistInstalled
   StrCpy $R0 "-1"

VSRedistInstalled:
   Exch $R0
FunctionEnd

Section "" SectionBase
  ; Set Section properties
  SetOverwrite on
  SectionIn RO
  
  ; Set Section Files and Shortcuts
  !include "${APP_BUILD}psi_files_install.nsh"
  ${SetOutPath} "$INSTDIR\"

  Call CheckVCRedist
  ${If} $R0 == "-1"
    File "${MSVS_DIR}\vcredist_x64.exe" 	
    ExecWait '"$INSTDIR\vcredist_x64.exe"  /passive /norestart'	$0
    IfErrors 0 noError
      MessageBox MB_OK "$LSTR_WARN_VCREDIST"
    noError:
  ${EndIf}

  !insertmacro "CreateURL" "Psi - Home page" "http://psi-im.org"
  !insertmacro "CreateURL" "Psi - Forum" "http://psi-im.org/forum"
  !insertmacro "CreateURL" "Psi - Documentation" "http://psi-im.org/wiki"
SectionEnd


; ********************************

!ifdef BUILD_WITH_LANGPACKS
SectionGroup "_" SectionLang
  !include "${APP_BUILD}psi_lang_install.nsh"
  ; See ReadME.txt for more information
SectionGroupEnd
!endif

!ifdef BUILD_WITH_SPELL
SectionGroup "_" SectionSpell
  !include "${APP_BUILD}psi_spel_install.nsh"
  ; See ReadME.txt for more information
SectionGroupEnd
!endif

Section "" SectionSM
 StrCmp $RUN_BY_ADMIN "true" sm_admin
 sm_normal:
  SetShellVarContext current
  Goto sm_done
 sm_admin:
  SetShellVarContext all
 sm_done:
  ${CreateDirectory} "$SMPROGRAMS\${APPNAME}"
  ${SetOutPath} "$INSTDIR\"
  ${CreateShortcut} "$SMPROGRAMS\${APPNAME}\Psi - Forum.lnk" "$INSTDIR\Psi - Forum.url"
  ${CreateShortcut} "$SMPROGRAMS\${APPNAME}\Psi - Documentation.lnk" "$INSTDIR\Psi - Documentation.url"
  ${CreateShortcut} "$SMPROGRAMS\${APPNAME}\Psi - Home page.lnk" "$INSTDIR\Psi - Home page.url"
  ${CreateShortcut} "$SMPROGRAMS\${APPNAME}\Psi.lnk" "$INSTDIR\Psi.exe"
  ${CreateShortcut} "$SMPROGRAMS\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  ${CreateShortcut} "$SMPROGRAMS\${APPNAME}\ReadME.lnk" "$INSTDIR\Readme.txt"
  SetShellVarContext current
SectionEnd

; ********************************
SectionGroup "_" SectionShortcuts
  Section "" SectionSD
   SetShellVarContext current
   ${SetOutPath} "$INSTDIR\"
   ${CreateShortcut} "$DESKTOP\Psi.lnk" "$INSTDIR\Psi.exe"
  SectionEnd
  Section /o "" SectionQuickLaunch
   SetShellVarContext current
   ${SetOutPath} "$INSTDIR\"
   ${CreateShortcut} "$QUICKLAUNCH\Psi.lnk" "$INSTDIR\Psi.exe"
  SectionEnd
SectionGroupEnd

Section "" SectionAutomaticStartup
  SetShellVarContext current
  ${SetOutPath} "$INSTDIR\"
  ${CreateShortcut} "$SMSTARTUP\Psi.lnk" "$INSTDIR\Psi.exe"
;  ${WriteRegStr} HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "Psi" "$INSTDIR\Psi.exe"
;  ^ doesn't work - Psi is not started with the correct working dir
SectionEnd

Section -FinishSection
 StrCmp $RUN_BY_ADMIN "true" lastsettings_is_admin
  ${WriteRegStr} HKCU "${REG_APP_PATH}" "" "$INSTDIR"
  ${WriteRegStr} HKCU "${REG_APP_PATH}" "Version" "${APPFULLVERSION}"
  ${WriteRegStr} HKCU "${REG_UNINSTALL_PATH}" "DisplayName" "${APPNAME} (remove only)"
  ${WriteRegStr} HKCU "${REG_UNINSTALL_PATH}" "UninstallString" "$INSTDIR\uninstall.exe"
  Goto lastsettings_done
 lastsettings_is_admin:
  ${WriteRegStr} HKLM "${REG_APP_PATH}" "" "$INSTDIR"
  ${WriteRegStr} HKLM "${REG_APP_PATH}" "Version" "${APPFULLVERSION}"
  ${WriteRegStr} HKLM "${REG_UNINSTALL_PATH}" "DisplayName" "${APPNAME} (remove only)"
  ${WriteRegStr} HKLM "${REG_UNINSTALL_PATH}" "UninstallString" "$INSTDIR\uninstall.exe"

 lastsettings_done:
 WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Function CompNames
  SectionSetText ${SectionBase} "$LSTR_PSIBASE"
  !ifdef BUILD_WITH_LANGPACKS
    SectionSetText ${SectionLang} "$LSTR_LANGUAGES"
  !endif
  !ifdef BUILD_WITH_SPELL
    SectionSetText ${SectionSpell} "$LSTR_SPELL_DICTS"
  !endif
  SectionSetText ${SectionSM} "$LSTR_STARTMENU_GROUP ($INST_CONTEXT)"
  SectionSetText ${SectionShortcuts} "$LSTR_SHORTCUTS ($LSTR_CURRENTUSER)"
    SectionSetText ${SectionSD} "$LSTR_DESKTOP_S"
    SectionSetText ${SectionQuickLaunch} "$LSTR_QUICKLAUNCH"
  SectionSetText ${SectionAutomaticStartup} "$LSTR_AUTOSTART ($LSTR_CURRENTUSER)"
FunctionEnd


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
  !include "${APP_BUILD}psi_lang_setup.nsh"
  ; See ReadME.txt for more information
; ****************
!endif

!ifdef BUILD_WITH_SPELL
; automatically choose spell dicts to install
  !include "${APP_BUILD}psi_spell_setup.nsh"
  ; See ReadME.txt for more information
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

;--------------------------------
; Uninstaller
;--------------------------------
Section Uninstall
  ;Can't uninstall if uninstall log is missing!
  IfFileExists "$INSTDIR\${UninstLog}" +3
    MessageBox MB_OK|MB_ICONSTOP "$(UninstLogMissing)"
      Abort

  Var REG_ROOT
  Call un.IsUserAdmin
  Pop $R0
  StrCmp $R0 "true" uninstall_is_admin
   StrCpy $REG_ROOT "HKCU"
   Goto uninstall_done
  uninstall_is_admin:
   StrCpy $REG_ROOT "HKCU"
  uninstall_done:

 
  Push $R0
  Push $R1
  Push $R2
  SetFileAttributes "$INSTDIR\${UninstLog}" NORMAL
  FileOpen $UninstLog "$INSTDIR\${UninstLog}" r
  StrCpy $R1 -1
 
  GetLineCount:
    ClearErrors
    FileRead $UninstLog $R0
    IntOp $R1 $R1 + 1
    StrCpy $R0 $R0 -2
    Push $R0   
    IfErrors 0 GetLineCount
 
  Pop $R0
 
  LoopRead:
    StrCmp $R1 0 LoopDone
    Pop $R0
 
    IfFileExists "$R0\*.*" 0 +3
      RMDir $R0  #is dir
    Goto +9
    IfFileExists $R0 0 +3
      Delete $R0 #is file
    Goto +6
    StrCmp $R0 "$REG_ROOT ${REG_APP_PATH}" 0 +3
      DeleteRegKey $REG_ROOT "${REG_APP_PATH}" #is Reg Element
    Goto +3
    StrCmp $R0 "$REG_ROOT ${REG_UNINSTALL_PATH}" 0 +2
      DeleteRegKey $REG_ROOT "${REG_UNINSTALL_PATH}" #is Reg Element
 
    IntOp $R1 $R1 - 1
    Goto LoopRead
  LoopDone:
  FileClose $UninstLog
  Delete "$INSTDIR\${UninstLog}"
  RMDir "$INSTDIR"
  Pop $R2
  Pop $R1
  Pop $R0
 
  ;Remove registry keys
  DeleteRegKey $REG_ROOT "${REG_APP_PATH}"
  DeleteRegKey $REG_ROOT "${REG_UNINSTALL_PATH}"
SectionEnd

Function UninstallPreviousPsi

 Call IsUserAdmin
 Pop $R0
 StrCpy $RUN_BY_ADMIN $R0 ; saving information
 StrCmp $R0 "true" unppsi_is_admin
  ReadRegStr $R0 HKCU "${REG_UNINSTALL_PATH}" "UninstallString"
	 ReadRegStr $R1 HKCU "${REG_APP_PATH}" ""
  goto unppsi_done
 unppsi_is_admin:
  ReadRegStr $R0 HKLM "${REG_UNINSTALL_PATH}" "UninstallString"
	 ReadRegStr $R1 HKLM "${REG_APP_PATH}" ""
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
