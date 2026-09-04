#!/bin/bash
# TLS reverse proxy in front of Guacamole (HTTP :8080).
# Expects FQDN in the environment (Azure public IP DNS name).
set -euo pipefail

LOG=/var/log/guacamole-https-setup.log
echo "==== $(date -Is) guacamole HTTPS setup fqdn=${FQDN:-} ====" | tee -a "$LOG"

if command -v ufw >/dev/null 2>&1; then
  ufw allow 80/tcp || true
  ufw allow 443/tcp || true
  ufw allow 8080/tcp || true
fi

for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36; do
  docker info >/dev/null 2>&1 && break
  sleep 5
done
docker info >/dev/null 2>&1 || {
  echo "ERROR: docker is not available"
  exit 1
}

mkdir -p /opt/guacamole-https

proxy_block() {
  cat <<'EOF'
  reverse_proxy 127.0.0.1:8080 {
    flush_interval -1
    transport http {
      read_timeout 24h
      write_timeout 24h
    }
  }
EOF
}

write_caddyfile_letsencrypt() {
  cat > /opt/guacamole-https/Caddyfile <<EOF
{
  email lab@$(echo "$FQDN" | tr '[:upper:]' '[:lower:]')
}

$FQDN {
$(proxy_block)
}
EOF
}

write_caddyfile_internal() {
  cat > /opt/guacamole-https/Caddyfile <<EOF
{
  auto_https disable_redirects
}

:443 {
  tls internal
$(proxy_block)
}
EOF
}

if [[ -n "${FQDN:-}" ]]; then
  write_caddyfile_letsencrypt
else
  write_caddyfile_internal
fi

docker rm -f guac-https >/dev/null 2>&1 || true
docker pull caddy:2-alpine
docker run -d --name guac-https --restart unless-stopped \
  --network host \
  -v /opt/guacamole-https/Caddyfile:/etc/caddy/Caddyfile:ro \
  -v guacamole-caddy-data:/data \
  -v guacamole-caddy-config:/config \
  caddy:2-alpine

sleep 8

https_ok() {
  local url=$1
  curl -sfk --max-time 10 "$url" >/dev/null
}

ok=0
if [[ -n "${FQDN:-}" ]]; then
  for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36; do
    # Verify a public CA certificate, not Guacamole HTTP status (502 is OK).
    if curl -sS --max-time 10 -o /dev/null "https://${FQDN}/"; then
      ok=1
      break
    fi
    sleep 5
  done
  if [[ "$ok" -ne 1 ]]; then
    echo "Let's Encrypt did not succeed; falling back to an internal TLS certificate"
    write_caddyfile_internal
    docker rm -f guac-https >/dev/null 2>&1 || true
    docker run -d --name guac-https --restart unless-stopped \
      --network host \
      -v /opt/guacamole-https/Caddyfile:/etc/caddy/Caddyfile:ro \
      -v guacamole-caddy-data:/data \
      -v guacamole-caddy-config:/config \
      caddy:2-alpine
    sleep 5
  fi
fi

https_ok "https://127.0.0.1/guacamole/" || https_ok "https://${FQDN:-127.0.0.1}/guacamole/" || {
  echo "WARNING: HTTPS proxy started but Guacamole is not answering yet"
}

echo "==== $(date -Is) guacamole HTTPS setup done ===="
