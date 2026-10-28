#!/bin/bash
# TLS reverse proxy in front of Guacamole (HTTP :8080).
# With the Azure public-IP DNS name, Caddy requests a Let's Encrypt cert so
# https://<fqdn>/guacamole/ has a public CA (no browser warning). Do not fall
# back to tls internal when FQDN is set — that is the cert warning.
# Always exit 0: HTTP :8080 remains the lab fallback if ACME is slow/rate-limited.
set -u

LOG=/var/log/guacamole-https-setup.log
# Do not use exec > >(tee) — Azure Run Command can hang on the tee FIFO.
log() { echo "$*" | tee -a "$LOG"; }
log "==== $(date -Is) guacamole HTTPS setup fqdn=${FQDN:-} ===="

if command -v ufw >/dev/null 2>&1; then
  ufw allow 80/tcp || true
  ufw allow 443/tcp || true
  ufw allow 8080/tcp || true
fi

for _ in $(seq 1 12); do
  docker info >/dev/null 2>&1 && break
  sleep 5
done
if ! docker info >/dev/null 2>&1; then
  log "WARNING: docker is not available; students can use HTTP :8080"
  exit 0
fi

mkdir -p /opt/guacamole-https

FQDN="$(echo "${FQDN:-}" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"

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

if [[ -n "$FQDN" ]]; then
  # Same ACME email on every student VM so Caddy does not register a new
  # ZeroSSL/Let's Encrypt account per FQDN (that is what delayed this lab).
  cat > /opt/guacamole-https/Caddyfile <<EOF
{
  email mcp201-workshop@users.noreply.github.com
}

${FQDN} {
$(proxy_block)
}
EOF
  log "Caddyfile: Let's Encrypt for ${FQDN}"
else
  cat > /opt/guacamole-https/Caddyfile <<EOF
{
  auto_https off
  servers {
    protocols h1 h2
  }
}

:443 {
  tls {
    issuer internal
    on_demand
  }
$(proxy_block)
}
EOF
  log "Caddyfile: internal TLS (no FQDN); browser warning expected"
fi

ensure_caddy_image() {
  docker image inspect caddy:2-alpine >/dev/null 2>&1 && return 0
  log "caddy:2-alpine not cached; pulling with 45s timeout"
  if command -v timeout >/dev/null 2>&1; then
    timeout 45 docker pull caddy:2-alpine || true
  else
    docker pull caddy:2-alpine || true
  fi
  docker image inspect caddy:2-alpine >/dev/null 2>&1
}

if ! ensure_caddy_image; then
  log "WARNING: could not pull caddy:2-alpine; HTTPS skipped; use HTTP :8080"
  exit 0
fi

docker rm -f guac-https >/dev/null 2>&1 || true
if docker run -d --name guac-https --restart unless-stopped \
  --network host \
  -v /opt/guacamole-https/Caddyfile:/etc/caddy/Caddyfile:ro \
  -v guacamole-caddy-data:/data \
  -v guacamole-caddy-config:/config \
  caddy:2-alpine; then
  log "Caddy container started"
else
  log "WARNING: failed to start Caddy; use HTTP :8080"
  log "==== $(date -Is) guacamole HTTPS setup done ===="
  exit 0
fi

if [[ -n "$FQDN" ]]; then
  # --resolve hits local Caddy with the right SNI. Do not curl the public
  # FQDN from the guest (Azure hairpin NAT) and do not replace LE with
  # tls internal if this check fails.
  ok=0
  for _ in $(seq 1 24); do
    if curl -sS --max-time 8 --resolve "${FQDN}:443:127.0.0.1" \
      -o /dev/null "https://${FQDN}/guacamole/"; then
      ok=1
      break
    fi
    sleep 5
  done
  if [[ "$ok" -eq 1 ]]; then
      log "Let's Encrypt certificate is trusted for https://${FQDN}/guacamole/"
  else
    log "WARNING: Let's Encrypt not ready yet; use HTTP :8080 or wait and retry the FQDN URL"
    docker logs guac-https --tail 40 || true
  fi
fi

log "==== $(date -Is) guacamole HTTPS setup done ===="
exit 0
