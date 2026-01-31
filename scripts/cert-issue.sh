#!/bin/bash
# 首次簽發或手動重新簽發 wildcard 憑證

set -e
cd "$(dirname "$0")/.."

if [ ! -f certbot/cloudflare.ini ]; then
    echo "錯誤: 請先建立 certbot/cloudflare.ini 並填入 Cloudflare API Token"
    echo "參考 certbot/cloudflare.example.ini"
    exit 1
fi

DOMAIN="${1:-bot.cxa.soy}"

docker compose run --rm certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /etc/cloudflare.ini \
    --dns-cloudflare-propagation-seconds 30 \
    -d "$DOMAIN" \
    -d "*.$DOMAIN" \
    --non-interactive \
    --agree-tos \
    --email "admin@${DOMAIN#*.}"

echo "憑證簽發完成，重啟 nginx..."
docker compose restart nginx
echo "完成！"
