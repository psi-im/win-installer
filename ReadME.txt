******************************************************************************
   NSIS Installer Script for Psi

   Copyright (c) 2004-2008 Mircea Bardac (IceRAM)
   E-mail: dev@mircea.bardac.net
   XMPP:   iceram@jabber.org

   [see ChangeLog.txt for version information]    
******************************************************************************

** Legal notice
  
   psi.nsi - NSIS script for installing Psi
   Copyright (c) 2004-2008 Mircea Bardac (IceRAM)
   
   Graphics (pictures, icons)
   Copyright (c) 2005 Robert Martinez (MRAY)
   
   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.
 
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
   along with this distribution; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 
   * See the COPYING.txt file for more information.

       
*******************************************************************************
** Installer Info

   The script was created in order to pack Psi (http://psi.affinix.com).
   The pack contains the Psi base files and language files.
   LZMA Compression is used.
   
   Compiles with: MakeNSIS v2.03
   * doesn't work with newer versions because of an incompatibility -
   researching
   

     
*******************************************************************************
** Thanks
   
   Many thanks to the Psi community and especially to the Psi developers for
   making such a wonderful IM application.

   Lots of thanks to all the contributors to the NSIS community that inspired
   and helped me build this script.
   
   Special thanks to Michal Jazlowiecki for the 'IsAdmin' function and for
   the help on debug.
   

*******************************************************************************
** File structure

   The script assumes the files are stored in the following structure:
     * INSTALLER_HOME
      \ - psi_app
      | - psi_lang
      | - lang
      | - tools

   * INSTALLER_HOME can be changed in config file. Check config.nsh.example
     The folder contains:
      - psi.nsi < main script file
      - installer-functions.nsh file < some functions used by the installer
      - installer-languages.nsh file < languages availabe for the installer
      - the compiled setup application
      - psi-l.bmp  < picture displayed on the left of the installer
      - psi-header-l.bmp, psi-header-r.bmp < pictures displayed in the header
      - install.ico, uninstall.ico < icons for the (un)installer
   * psi_app contains the Psi files exactly as they would come after
     decompressing the .zip distribution
   * psi_lang contains Psi's *.qm language files
   * lang contains files with translations for the installer:
      Example: psi_installer_LANG.nsh
   * tools contains scrips (& their configuration) for updating the
     installer when a new Psi version and/or Psi language files are out
      - prepfiles < bash script used for updating the file list
      - preplang < Python script used for updating the Psi language file list
      - psi_lang.map < language map file used by the preplang script

*******************************************************************************
** Installer languages

   The installer can be compiled with multiple language support (this has no
   connection with the language packs). The interface of the installer will
   be displayed in the language selected on start.
   
   The available languages for the installer (and the codepages used to make
   translations for them) can be found in the files at:
   http://cvs.sourceforge.net/viewcvs.py/nsis/NSIS/Contrib/Language%20files/
   
   In order to compile the installer with a new language, add a line
   describing the installer language.

   There are 2 types of translations that can be added to the installer:
   1. Translations that contain, besides the standard traslation, the Psi
      installer specific strings:

            !insertmacro UI_LANGUAGE_LOAD "Polish"

      This requires that the file psi_installer_Polish to be found in lang/

   2. Example for adding the standard translation to the installer:

            !insertmacro MUI_LANGUAGE "Polish"

   You can't add a translation in both ways. No. 1 includes No. 2.

*******************************************************************************
** Adding a new Psi language to the installer script:

  1. add the language to the "psi_lang/" dir
  2. make sure the language map file in tools/psi_lang.map contains the correct
     information for the language you add (also check the comments at the
     beginning of the file)
  3. run "./preplang" (Python script) in the "tools/" dir 
   

*******************************************************************************
** Updating the file list

  1. run "./prepfiles archive.zip" (Bash script) in the "tools/" dir with
     archive.zip being the Psi archive with the release you're packing


*******************************************************************************
** Functionality

   INSTALLER
   1. Checks the language of the system and asks the user to
      confirm/change it
      (saves the language setting in the Registry for the uninstaller)
   2. Checks if another Psi installer session is running - exists if so.
   3. Checks if Psi is running, asks the user to stop it.
      If not, exits installer.
   4. Checks if Psi is installed, uninstalls the previous version silently.
   5. Checks if the user is an admin or not and sets what kind of
      Start Menu shortcuts the installer is going to create
   6. Installs Psi according the user needs
   6.1. Copies Psi base files
   6.2. Copies Psi languages
   6.3. Creates Start Menu icons (depending on the rights of the user):
          - Application
          - Uninstaller
          - ReadME file
          - Psi - Home Page - url
          - Psi - Forum - url
   6.4. Creates shortcuts (for Current User)
          - Desktop
          - Quick Launch
   6.5. Adds to the Startup an entry for Psi (for Current User)
   7. Offers to:
        - Run Psi (checked by default)
        - Open ReadME file (checked by default)
        
   UNINSTALLER
   1. Checks what language was used for the installation and uses
      the same language for the uninstall
   2. Checks if another Psi uninstaller session is running - exists if so.
   3. Checks if Psi is running, asks the user to stop it.
      If not, exits uninstaller.
   4. Uninstalls Psi
