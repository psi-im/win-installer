# Makefile for the Psi Installer

.PHONY: all languages files build clean

all: languages files build

languages:
	@cd tools; ./preplang ../app/psi_lang

files:
	@# detect zip file in build dir and use it
	@f=$$(ls -1 app/*.zip | head -n1); cd tools; ./prepfiles ../$$f

build:
	cd src; makensis psi.nsi

clean:
	rm -rf build
