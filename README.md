# Nginx Reverse Proxy

Docker 化的 Nginx 反向代理，支援 Let's Encrypt wildcard SSL 憑證（透過 Cloudflare DNS 驗證）。

## 快速開始

### 1. 設定 Cloudflare API Token

```bash
mv certbot/cloudflare.example.ini certbot/cloudflare.ini
# 編輯填入你的 API Token
chmod 600 certbot/cloudflare.ini
```

### 2. 設定 DNS

在 Cloudflare 加 A record：

- `<subdomain>` → 你的伺服器 IP
- `*.<subdomain>` → 你的伺服器 IP（wildcard）

### 3. 設定 Nginx

```bash
mv nginx/conf.d/default.example.conf nginx/conf.d/default.conf
# 編輯 default.conf，把 DOMAIN 換成你的域名
```

### 4. 簽發憑證

```bash
./scripts/cert-issue.sh <subdomain.domain.com>
```

### 5. 啟動服務

```bash
docker compose up -d
```

### 6. 開啟自動續簽

```bash
./scripts/auto-renew.sh on
```

## 目錄結構

```text
nginx-proxy/
├── compose.yaml
├── nginx/
│   ├── nginx.conf
│   └── conf.d/
│       └── default.conf          # 站台設定
├── certbot/
│   ├── cloudflare.ini            # Cloudflare API Token
│   └── conf/                     # SSL 憑證
└── scripts/
    ├── cert-issue.sh             # 簽發憑證
    ├── cert-renew.sh             # 手動續簽
    └── auto-renew.sh             # 自動續簽開關
```

## 新增站台

編輯 `nginx/conf.d/default.conf`，加入新的 server block：

```nginx
server {
    listen 443 ssl;
    http2 on;
    server_name xxx.DOMAIN;

    ssl_certificate /etc/letsencrypt/live/DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/DOMAIN/privkey.pem;

    location / {
        proxy_pass http://host.docker.internal:PORT;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

然後測試設定並 reload：

```bash
make reload
```

## 常用指令

| 指令 | 說明 |
| --- | --- |
| `make up` | 啟動服務 |
| `make down` | 停止服務 |
| `make reload` | 測試設定並 reload nginx |
| `make logs` | 查看 nginx logs |
| `make cert-issue DOMAIN=<domain>` | 簽發憑證 |
| `make cert-renew` | 手動續簽 |
| `make auto-renew-on` | 開啟自動續簽 |
| `make auto-renew-off` | 關閉自動續簽 |
| `make auto-renew-status` | 查看自動續簽狀態 |
