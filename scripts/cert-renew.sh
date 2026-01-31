#!/bin/bash
# 手動續簽憑證

set -e
cd "$(dirname "$0")/.."

docker compose run --rm certbot renew

echo "重啟 nginx..."
docker compose restart nginx
echo "完成！"
