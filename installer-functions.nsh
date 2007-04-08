;********************************************************
;  installer-functions.nsh v1.1 - functions for the Psi NSIS Script file
;  Copyright © 2004-2005 Mircea Bardac (IceRAM)
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
;*****************************************************

; ********************************
; Close Psi Instances
; Waits for all running instances of Psi to close
Function ClosePsiInstances
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

; function that checks if the user running the installer is an Administrator
; thanks Michal Jazlowiecki (michalj)
Function IsUserAdmin
Push $R0
ClearErrors
UserInfo::GetAccountType
IfErrors admin
Pop $R0
StrCmp $R0 "Admin" admin

NoAdmin:
; User is NOT an Admin
Pop $R0
Push "false"
Goto end_isadmin

Admin:
; User is an Admin
Pop $R0
Push "true"

end_isadmin:
FunctionEnd

; *************************************

!macro UI_LANGUAGE_LOAD LANG
  !insertmacro MUI_LANGUAGE "${LANG}"
;  !verbose push
;  !verbose on
;  IfFileExists "lang\psi_installer_${LANG}.nsh" 0 +2
   !include "lang\psi_installer_${LANG}.nsh"
;  !verbose off
  !undef LANG
!macroend

!macro LANG_STRING NAME VALUE
  LangString ${NAME} "${LANG_${LANG}}" "${VALUE}"
!macroend

!macro LANG_UNSTRING NAME VALUE
  !insertmacro LANG_STRING "un.${NAME}" "${VALUE}"
!macroend

; *************************************

!macro INIT_LANG_STRINGS
 ; initializing the strings with the coresponding ones in the active language
 StrCpy $LSTR_PSIBASE         "Psi (base)"
 StrCpy $LSTR_LANGUAGES       "Languages"
 StrCpy $LSTR_CURRENTUSER     "Current User"
 StrCpy $LSTR_ALLUSERS        "All Users"
 StrCpy $LSTR_SHORTCUTS       "Shortcuts"
 StrCpy $LSTR_QUICKLAUNCH     "Quick Launch shortcut"
 StrCpy $LSTR_DESKTOP_S       "Desktop shortcut"
 StrCpy $LSTR_STARTMENU_GROUP "Start Menu group"
 StrCpy $LSTR_AUTOSTART       "Automatic startup"
 StrCpy $LSTR_ASK_EXIT_PSI    "You must exit all running copies of Psi to continue!"
 StrCpy $LSTR_UNINST_RUNNING  "The uninstaller is already running."
 StrCpy $LSTR_INST_RUNNING    "The installer is already running."
 StrCpy $LSTR_WARN_ADMIN_1    "You are running this installer as a normal user, NOT as an Administrator."
 StrCpy $LSTR_WARN_ADMIN_2    "If you want to uninstall this application, you must use the same user or your system may become unstable."
 StrCpy $LSTR_A_INSTALLED     "Psi is already installed. Would you like to upgrade?$\n$\nClick <Yes> to remove the previous version or <No> install this version separately."
 StrCpy $LSTR_ERR_UNINST      "There were some errors uninstalling Psi. $\n$\nWould you like to continue?"

 StrCmp $(STR_PSIBASE) "" +2
    StrCpy $LSTR_PSIBASE $(STR_PSIBASE)
 StrCmp $(STR_LANGUAGES) "" +2
    StrCpy $LSTR_LANGUAGES $(STR_LANGUAGES)
 StrCmp $(STR_CURRENTUSER) "" +2
    StrCpy $LSTR_CURRENTUSER $(STR_CURRENTUSER)
 StrCmp $(STR_ALLUSERS) "" +2
    StrCpy $LSTR_ALLUSERS $(STR_ALLUSERS)
 StrCmp $(STR_SHORTCUTS) "" +2
    StrCpy $LSTR_SHORTCUTS $(STR_SHORTCUTS)
 StrCmp $(STR_QUICKLAUNCH) "" +2
    StrCpy $LSTR_QUICKLAUNCH $(STR_QUICKLAUNCH)
 StrCmp $(STR_DESKTOP_S) "" +2
    StrCpy $LSTR_DESKTOP_S $(STR_DESKTOP_S)
 StrCmp $(STR_STARTMENU_GROUP) "" +2
    StrCpy $LSTR_STARTMENU_GROUP $(STR_STARTMENU_GROUP)
 StrCmp $(STR_AUTOSTART) "" +2
    StrCpy $LSTR_AUTOSTART $(STR_AUTOSTART)
 StrCmp $(STR_ASK_EXIT_PSI) "" +2
    StrCpy $LSTR_ASK_EXIT_PSI $(STR_ASK_EXIT_PSI)
 StrCmp $(STR_UNINST_RUNNING) "" +2
    StrCpy $LSTR_UNINST_RUNNING $(STR_UNINST_RUNNING)
 StrCmp $(STR_INST_RUNNING) "" +2
    StrCpy $LSTR_INST_RUNNING $(STR_INST_RUNNING)
 StrCmp $(STR_WARN_ADMIN_1) "" +2
    StrCpy $LSTR_WARN_ADMIN_1 $(STR_WARN_ADMIN_1)
 StrCmp $(STR_WARN_ADMIN_2) "" +2
    StrCpy $LSTR_WARN_ADMIN_2 $(STR_WARN_ADMIN_2)
 StrCmp $(STR_A_INSTALLED) "" +2
    StrCpy $LSTR_A_INSTALLED $(STR_A_INSTALLED)
 StrCmp $(STR_ERR_UNINST) "" +2
    StrCpy $LSTR_ERR_UNINST $(STR_ERR_UNINST)
!macroend

; *************************************


