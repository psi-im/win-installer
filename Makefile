# Makefile for the Psi Installer

SRC_LANG=http://psi-im.org/download/lang
SRC_APP=http://www.kismith.co.uk/files/psi/windows/nightlies

.PHONY: all languages files build clean

all: languages files build


download_lang:
	rm -rf app/psi_lang
	mkdir -p app/psi_lang
	wget -nv $(SRC_LANG)/listfiles.php -O _tmplist
	@cat _tmplist | sed -e 's|<br/>| |g' | tr ' ' '\n' | while read l; do\
		if [ "$$l " != " " ]; then\
			wget -nv $(SRC_LANG)/$$l -O app/psi_lang/$$l;\
		fi;\
	done
	rm -f _tmplist

download_psi_nightly:
	rm -rf app/*.zip
	mkdir -p app
	wget -nv http://www.kismith.co.uk/files/psi/windows/nightlies/ -O _tmplist
	@f=$$(cat _tmplist | grep .zip | tail -n1 | sed 's|.*HREF="\(.*\)">.*|\1|g'); wget $(SRC_APP)/$$f -O app/$$f
	rm -f _tmplist


path_config:
	sed -i.orig 's|!define INSTALLER_HOME.*|!define INSTALLER_HOME "$(CURDIR)"|g' config.nsh
	rm config.nsh.orig

languages:
	@cd tools; ./preplang ../app/psi_lang

files:
	@# detect zip file in build dir and use it
	@f=$$(ls -1 app/*.zip | head -n1); cd tools; ./prepfiles ../$$f

psi_installer:
	rm -f psi_installler.zip
	zip -r psi_installer.zip src/ build/ *.*

build: path_config
	cd src; makensis psi.nsi

clean:
	rm -rf build psi_installer.zip
