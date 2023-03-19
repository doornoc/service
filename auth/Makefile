reset:
	docker compose down
	rm -rf data/slapd-data/* data/openldap-data/*
	docker compose build --no-cache
	docker compose up -d
start:
	docker compose build --no-cache
	docker compose up -d
