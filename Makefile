# Makefile for the Psi Installer

.PHONY: all languages files build clean

all: path_config languages files build

path_config:
	sed -i.orig 's|!define INSTALLER_HOME.*|!define INSTALLER_HOME "$(CURDIR)"|g' config.nsh
	rm config.nsh.orig

languages:
	@cd tools; ./preplang ../app/psi_lang

files:
	@# detect zip file in build dir and use it
	@f=$$(ls -1 app/*.zip | head -n1); cd tools; ./prepfiles ../$$f

build:
	cd src; makensis psi.nsi

clean:
	rm -rf build
