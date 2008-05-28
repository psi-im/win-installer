;*******************************************************************************
;  config.nsh - Psi Installer Configuration File
;*******************************************************************************

!define APPVERSION "0.12"
!define APPEXTRAVERSION ""

!define BUILD_WITH_LANGPACKS
; ^ comment if you want to build the installer without language packs

!define INSTALLER_HOME "/Volumes/Home/Projects/psi/win-installer/psi-0.12"

!define INSTALLER_BUILD "1"
; ^ update whenever you add something to the installer and rebuild it
;   without changing APPVERSION
; ^ reset to 0 when you change APPVERSION

!define FILE_SEPARATOR "/"
