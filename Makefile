NAME=ignotummisterii
ENVIRONMENT=production
RAILS_MASTER_KEY=4e6ca55ea2266728b51bcfff54cfac42

build:
	docker build --build-arg ENVIRONMENT=$(ENVIRONMENT)\
		--build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY)\
		-t $(NAME) -f Dockerfile .
