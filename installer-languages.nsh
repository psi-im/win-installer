;********************************************************
;  installer-languages.nsh v1.1 - installer languages Psi NSIS Script file
;  Copyright © 2004-2005 Mircea Ionut Bardac (IceRAM)
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
; Languages

; use UI_LANGUAGE_LOAD instead of MUI_LANGUAGE if you have a
; translation file for the interface components in a file like
; lang\psi_installer_LANG.nsh

  !insertmacro UI_LANGUAGE_LOAD "English"
  !insertmacro UI_LANGUAGE_LOAD "Catalan"
  !insertmacro UI_LANGUAGE_LOAD "Czech"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro UI_LANGUAGE_LOAD "German"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro UI_LANGUAGE_LOAD "Spanish"
  !insertmacro UI_LANGUAGE_LOAD "French"
  !insertmacro UI_LANGUAGE_LOAD "Greek"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro UI_LANGUAGE_LOAD "Macedonian"
  !insertmacro UI_LANGUAGE_LOAD "Dutch"
  !insertmacro UI_LANGUAGE_LOAD "Polish"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Swedish"

; ********************************

