
VERSION := 3.1.8-2020-05-01-05516d846

all: build 

pull:
	docker pull cti/connectiq:$(VERSION)

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) -t cti/connectiq:$(VERSION) .
	docker tag cti/connectiq:$(VERSION) cti/connectiq:latest

build-proj:
	docker run --rm -v `pwd`:/project cti/connectiq:latest bash -c 'cd /project; chmod +x gradlew; ./gradlew build'
