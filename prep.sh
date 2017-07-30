#!/bin/sh

PSI_DIR="$(cd "$1"; pwd)"
INST_DIR="$(cd "$(dirname "$0")"; pwd)" # readlink can the same easier but it's not always available
BUILD_DIR="$(cd "${INST_DIR}/.."; pwd)/build"
TS_DIR="$(cd "${INST_DIR}/.."; pwd)/psi-l10n"
QM_DIR="${BUILD_DIR}/psi_lang"
QT_QM_DIR="$(qmake -query QT_INSTALL_TRANSLATIONS)"
LANG_REPO_URL=https://github.com/psi-im/psi-l10n.git
SPELL_DIR="$PSI_DIR/myspell/dicts"

die() { echo "Error: $@"; exit 1; }

[ -d "$1" ] || die "Pass a directory with files for installation as a first argument"
cd "${INST_DIR}"
mkdir -p "${QM_DIR}"

if [ "$NOGIT" != 1 ]; then
	if [ -d "${TS_DIR}" ]; then
		(cd "${TS_DIR}"; git pull) || die "failed to get translation sources"
	else
		git clone "${LANG_REPO_URL}" "${TS_DIR}" || die "failed to get translation sources"
	fi
fi

for f in "${TS_DIR}"/translations/*.ts; do
	base="$(basename "$f" .ts)"
	code="$(echo "$base" | cut -d '_' -f 2-)" # strip psi_
	qm="${QM_DIR}"/${base}.qm
	qt_qm="${QT_QM_DIR}/qt_${code}.qm"
	if [ "$f" -nt "$qm" ]; then
		lrelease "$f" -qm "${qm}" || die "failed to update to generate qm"
	fi
	if [ "$qt_qm" -nt "${QM_DIR}/qt_${code}.qm" ]; then
		cp "${QT_QM_DIR}/qt_${code}.qm" "${QM_DIR}"
	fi
done
# QM files are ready by this moment in ../build/psi_lang
# Not let's generate some NSIS magic

flanginst="${BUILD_DIR}/psi_lang_install.nsh"
flangsetup="${BUILD_DIR}/psi_lang_setup.nsh"
rm -f "$flanginst" "$flangsetup"

cat tools/psi_lang.map | grep -E 'Lang.*	LANG' | sort | while read -r ldesc; do
	#<key>,<SectionName>,<LanguageID>,<LanguageName>
	lang_key="$(echo "$ldesc" | cut -f 1)"
	lang_section="$(echo "$ldesc" | cut -f 2)"
	lang_id="$(echo "$ldesc" | cut -f 3)"
	lang_name="$(echo "$ldesc" | cut -f 4-)"
	lang_file="psi_${lang_key}.qm"
	if [ -f "$QM_DIR/$lang_file" ]; then
		echo "Found translation file for ${lang_name}"
	else
		echo "Translation file for ${lang_name} is not found"
		continue
	fi
	
	# psi_lang_install.nsh
	(echo "
; ${lang_name}
Section /o \"${lang_name}\" $lang_section
	SetOverwrite on
	\${SetOutPath} \"\$INSTDIR\\translations\\\"
	\${File} \"\${APP_BUILD}psi_lang\${FILE_SEPARATOR}${lang_file}\""
	if [ -f "$QM_DIR/qt_${lang_key}.qm" ]; then
		echo "	\${File} \"\${APP_BUILD}psi_lang\${FILE_SEPARATOR}qt_${lang_key}.qm\""
	fi
	echo "SectionEnd"
) >> "${flanginst}"

	# psi_lang_setup.nsh
	if [ -n "$lang_id" ]; then
		echo "
	StrCmp \$LANGUAGE \${${lang_id}} 0 +2
		SectionSetFlags \${${lang_section}} \${SF_SELECTED}" >> "${flangsetup}"
	else
		echo "
	; No ${lang_name} AutoSelection" >> "${flangsetup}"
	fi
done

# ========================================================
# nsh files to Psi translations are generated.
# Now lets generate everything else

out_inst="${BUILD_DIR}/psi_files_install.nsh"

echo ";
; List of files to be INSTALLED (Base section)
;
" > $out_inst

(cd "$PSI_DIR"; find -type f  -path './myspell/dicts/*' -prune -o -printf '%P\n' | while read -r f; do
	winf="${f//\//\\}"
	dn=$(dirname "$f")
	[ "$dn" = "." ] && dn="\$INSTDIR" || dn="\$INSTDIR\\${dn//\//\\}"
	if [ "$dn" != "$last_dn" ]; then
		echo "\${SetOutPath} $dn" >> $out_inst
		last_dn="$dn"
	fi
	echo "\${File} \"\${APP_SOURCE}\\${winf}\"" >> $out_inst
done)

# ========================================================
# Now the last thing. Install sections for spelling dicts
spell_inst="${BUILD_DIR}/psi_spell_install.nsh"
spell_setup="${BUILD_DIR}/psi_spell_setup.nsh"
cat tools/spell_lang.map | grep -E 'Lang.*	LANG' | sort | while read -r ldesc; do
	#<key>,<SectionName>,<LanguageID>,<LanguageName>
	lang_key="$(echo "$ldesc" | cut -f 1)"
	lang_section="$(echo "$ldesc" | cut -f 2)"
	lang_id="$(echo "$ldesc" | cut -f 3)"
	lang_name="$(echo "$ldesc" | cut -f 4-)"
	if [ -f "$SPELL_DIR/${lang_key}.dic" -a -f "$SPELL_DIR/${lang_key}.aff" ]; then
		echo "Found spell dictionary for ${lang_name}"
	else
		echo "Spell dictionary for ${lang_name} is not found"
		continue
	fi
	
	# psi_lang_install.nsh
	(echo "
; ${lang_name}
Section /o \"${lang_name}\" $lang_section
	SetOverwrite on
	\${SetOutPath} \"\$INSTDIR\${FILE_SEPARATOR}myspell\${FILE_SEPARATOR}dicts\${FILE_SEPARATOR}\"
	\${File} \"\${APP_SOURCE}\${FILE_SEPARATOR}myspell\${FILE_SEPARATOR}dicts\${FILE_SEPARATOR}${lang_key}.dic\"
	\${File} \"\${APP_SOURCE}\${FILE_SEPARATOR}myspell\${FILE_SEPARATOR}dicts\${FILE_SEPARATOR}${lang_key}.aff\""
	echo "SectionEnd"
) >> "${spell_inst}"

	# psi_lang_setup.nsh
	if [ -n "$lang_id" ]; then
		echo "
	StrCmp \$LANGUAGE \${${lang_id}} 0 +2
		SectionSetFlags \${${lang_section}} \${SF_SELECTED}" >> "${spell_setup}"
	else
		echo "
	; No ${lang_name} AutoSelection" >> "${spell_setup}"
	fi
done

# ========================================================
# Generate configuration file
echo "
!define APPVERSION \"1.2\"
!define APPEXTRAVERSION \"\"

!define BUILD_WITH_LANGPACKS
; ^ comment if you want to build the installer without language packs

!define BUILD_WITH_SPELL
; ^ comment if you want to build the installer without spell dictionaries

;!define BUILD_32
; ^ uncomment to package a 32-bit psi. otherwise 64-bit psi is assumed

!define INSTALLER_HOME \"$(cygpath -pw "$INST_DIR")\"
!define APP_SOURCE \"$(cygpath -pw "$PSI_DIR")\\\"
!define APP_BUILD \"$(cygpath -pw "$BUILD_DIR")\\\"

!define INSTALLER_BUILD \"0\"
; ^ update whenever you add something to the installer and rebuild it
;   without changing APPVERSION
; ^ reset to 0 when you change APPVERSION

!define FILE_SEPARATOR \"\\\"
" > "${INST_DIR}/config.nsh"
