
VERSION := 3.1.7-2020-01-23-a3869d977

all: build 

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/connectiq:$(VERSION) .
	docker tag kalemena/connectiq:$(VERSION) kalemena/connectiq:latest

run:
	bash ./run.sh

eclipse:
	COMMAND=/opt/eclipse/eclipse bash ./run.sh
