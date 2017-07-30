; this script is taken from http://nsis.sourceforge.net/Uninstall_only_installed_files

;--------------------------------
; Configure UnInstall log to only remove what is installed
;-------------------------------- 
  ;Set the name of the uninstall log
    !define UninstLog "uninstall.log"
    Var UninstLog
 
  ;Uninstall log file missing.
    LangString UninstLogMissing ${LANG_ENGLISH} "${UninstLog} not found!$\r$\nUninstallation cannot proceed!"
 
  ;AddItem macro
    !define AddItem "!insertmacro AddItem"
 
  ;BackupFile macro
    !define BackupFile "!insertmacro BackupFile" 
 
  ;BackupFiles macro
    !define BackupFiles "!insertmacro BackupFiles" 
 
  ;Copy files macro
    !define CopyFiles "!insertmacro CopyFiles"
 
  ;CreateDirectory macro
    !define CreateDirectory "!insertmacro CreateDirectory"
 
  ;CreateShortcut macro
    !define CreateShortcut "!insertmacro CreateShortcut"
 
  ;File macro
    !define File "!insertmacro File"
 
  ;Rename macro
    !define Rename "!insertmacro Rename"
 
  ;RestoreFile macro
    !define RestoreFile "!insertmacro RestoreFile"    
 
  ;RestoreFiles macro
    !define RestoreFiles "!insertmacro RestoreFiles"
 
  ;SetOutPath macro
    !define SetOutPath "!insertmacro SetOutPath"
 
  ;WriteRegDWORD macro
    !define WriteRegDWORD "!insertmacro WriteRegDWORD" 
 
  ;WriteRegStr macro
    !define WriteRegStr "!insertmacro WriteRegStr"
 
  ;WriteUninstaller macro
    !define WriteUninstaller "!insertmacro WriteUninstaller"
 
  Section -openlogfile
    CreateDirectory "$INSTDIR"
    IfFileExists "$INSTDIR\${UninstLog}" +3
      FileOpen $UninstLog "$INSTDIR\${UninstLog}" w
    Goto +4
      SetFileAttributes "$INSTDIR\${UninstLog}" NORMAL
      FileOpen $UninstLog "$INSTDIR\${UninstLog}" a
      FileSeek $UninstLog 0 END
  SectionEnd
