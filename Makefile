
IMAGE_NAME = maven-3-jdk-8-builder

build:
	docker build -t $(IMAGE_NAME):1.0 -t $(IMAGE_NAME):latest .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
