services-up:
	docker compose up -d
	sleep 2

services-down:
	docker compose down

services-down!:
	docker compose restart

prepare:
	bundle install
	bin/rails db:prepare
	bin/rails db:seed

dev:
	bin/dev

dev!: services-down! services-up prepare dev