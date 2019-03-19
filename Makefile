NAME=test
ENVIRONMENT=production
RAILS_MASTER_KEY=4e6ca55ea2266728b51bcfff54cfac42
TAG=$(shell git log -1 --pretty=%h)

NAME_BACKEND=$(NAME)-backend
NAME_NGINX=$(NAME)-nginx

DOCKER_USER=dmella04

build:
	docker build --build-arg ENVIRONMENT=$(ENVIRONMENT)\
		--build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY)\
		-t $(NAME_BACKEND):$(TAG) -f Dockerfile .
	docker build -t $(NAME_NGINX):$(TAG) -f Dockerfile-nginx .
tag: build
	docker tag $(NAME_BACKEND):$(TAG) $(DOCKER_USER)/$(NAME_BACKEND):$(TAG)
	docker tag $(NAME_NGINX):$(TAG) $(DOCKER_USER)/$(NAME_NGINX):$(TAG)
push: tag
	docker push $(DOCKER_USER)/$(NAME_BACKEND):$(TAG)
	docker push $(DOCKER_USER)/$(NAME_NGINX):$(TAG)

deploy: push
	kubectl --record deployments/nginx-backend-deployment set image \
		backend=$(DOCKER_USER)/$(NAME_BACKEND):$(TAG)\
		nginx=$(DOCKER_USER)/$(NAME_NGINX):$(TAG)

