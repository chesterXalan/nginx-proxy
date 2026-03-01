.PHONY: up down reload logs cert-issue cert-renew auto-renew-on auto-renew-off auto-renew-status

up:
	docker compose up -d

down:
	docker compose down

reload:
	docker compose exec nginx nginx -t && docker compose exec nginx nginx -s reload

logs:
	docker compose logs -f nginx

cert-issue:
	./scripts/cert-issue.sh $(DOMAIN)

cert-renew:
	./scripts/cert-renew.sh

auto-renew-on:
	./scripts/auto-renew.sh on

auto-renew-off:
	./scripts/auto-renew.sh off

auto-renew-status:
	./scripts/auto-renew.sh status
