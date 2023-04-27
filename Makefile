NAME := "helloworld"
REPO := 407461997746.dkr.ecr.ap-southeast-1.amazonaws.com/hello
VERSION  = $(shell git describe --tags --always --dirty)
IMAGE := $(REPO):$(VERSION)

build: options
	docker build -t $(NAME) .

push: build
	docker tag $(NAME) $(IMAGE)
	docker push $(IMAGE)

run:
	docker run --rm -p 8080:8080 $(NAME)

list:
	skopeo list-tags docker://$(REPO)

ls:
	crane ls $(REPO)

newtag: push
	skopeo copy docker://$(IMAGE) docker://$(REPO):newtag

newtagcrane:
	crane tag $(IMAGE) newtag

validate:
	crane validate $(IMAGE)

deletenewtag: # https://github.com/containers/skopeo/issues/1981
	skopeo delete docker://$(REPO):newtag

deletetagaws:
	aws ecr batch-delete-image --repository-name hello --image-ids imageTag=newtag

deletecrane:
	crane delete $(REPO):newtag

login:
	aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 407461997746.dkr.ecr.ap-southeast-1.amazonaws.com

options:
	@echo $(NAME) build options:
	@echo "VERSION   = ${VERSION}"
