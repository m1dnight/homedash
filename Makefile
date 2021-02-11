DOCKER_TAG := v2
DOCKER_TAG_DEV := dev
DOCKER_IMG := m1dnight/homedash

.PHONY: build

build:
	docker build -t $(DOCKER_IMG):$(DOCKER_TAG) .

dev: 
	docker build -t $(DOCKER_IMG):$(DOCKER_TAG_DEV) .

push: 
	docker push $(DOCKER_IMG):$(DOCKER_TAG)

pushdev: 
	docker push $(DOCKER_IMG):$(DOCKER_TAG_DEV)