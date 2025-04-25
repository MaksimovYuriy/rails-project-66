setup:
	bundle install
	yarn install
	yarn build
	yarn build:css
	bin/rails db:migrate
	bin/rails db:seed

tests:
	rake test

lint:
	rake lint:all

env:
	cp .env.example .env