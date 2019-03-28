NAME=test
ENVIRONMENT=production
RAILS_MASTER_KEY=4e6ca55ea2266728b51bcfff54cfac42
TAG=$(shell git log -1 --pretty=%h)

NAME_BACKEND=$(NAME)-backend
NAME_NGINX=$(NAME)-nginx

DOCKER_USER=dmella04
APP_NAME=nginx-backend

build:
	docker build --build-arg ENVIRONMENT=$(ENVIRONMENT)\
		--build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY)\
		-t $(NAME_BACKEND) -f Dockerfile .
	docker build -t $(NAME_NGINX) -f Dockerfile-nginx .
tag: build
	docker tag $(NAME_BACKEND) $(DOCKER_USER)/$(NAME_BACKEND):$(TAG)
	docker tag $(NAME_BACKEND) $(DOCKER_USER)/$(NAME_BACKEND):latest
	docker tag $(NAME_NGINX) $(DOCKER_USER)/$(NAME_NGINX):$(TAG)
	docker tag $(NAME_NGINX) $(DOCKER_USER)/$(NAME_NGINX):latest
push: tag
	docker push $(DOCKER_USER)/$(NAME_BACKEND)
	docker push $(DOCKER_USER)/$(NAME_NGINX)

deploy: push
	kubectl delete pods -l app=$(APP_NAME)
