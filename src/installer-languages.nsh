;********************************************************
;  installer-languages.nsh v1.1 - installer languages Psi NSIS Script file
;  Copyright (c) 2004-2008 Mircea Bardac (IceRAM)
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
; 
; Languages for the installer supported by NSIS:
; http://cvs.sourceforge.net/viewcvs.py/nsis/NSIS/Contrib/Language%20files/

  !insertmacro UI_LANGUAGE_LOAD "English"      ; -
  !insertmacro MUI_LANGUAGE "Bulgarian"        ; bg
  !insertmacro UI_LANGUAGE_LOAD "Catalan"      ; ca
  !insertmacro UI_LANGUAGE_LOAD "Czech"        ; cz
  !insertmacro MUI_LANGUAGE "SimpChinese"      ; zh
  !insertmacro UI_LANGUAGE_LOAD "German"       ; de
  !insertmacro MUI_LANGUAGE "Hungarian"        ; hu
; Esperanto - no NSIS support                  ; eo
  !insertmacro MUI_LANGUAGE "Estonian"         ; et
  !insertmacro UI_LANGUAGE_LOAD "Spanish"      ; es
  !insertmacro UI_LANGUAGE_LOAD "French"       ; fr
  !insertmacro UI_LANGUAGE_LOAD "Greek"        ; el
  !insertmacro MUI_LANGUAGE "Italian"          ; it
  !insertmacro MUI_LANGUAGE "Japanese"         ; jp
  !insertmacro UI_LANGUAGE_LOAD "Macedonian"   ; mk
  !insertmacro UI_LANGUAGE_LOAD "Dutch"        ; nl
  !insertmacro UI_LANGUAGE_LOAD "Polish"       ; pl
  !insertmacro MUI_LANGUAGE "Portuguese"       ; pt
  !insertmacro MUI_LANGUAGE "PortugueseBR"     ; pt_BR
  !insertmacro MUI_LANGUAGE "Russian"          ; ru
  !insertmacro MUI_LANGUAGE "Slovak"           ; sk
  !insertmacro MUI_LANGUAGE "Slovenian"        ; sl
  !insertmacro MUI_LANGUAGE "SerbianLatin"     ; sr@Latn
  !insertmacro MUI_LANGUAGE "Swedish"          ; se
; Vietnamese - no NSIS support                 ; vi

; ********************************

