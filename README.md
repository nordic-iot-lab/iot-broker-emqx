# EMQX Isolated Broker

Docker Compose baseline for the Mecho/Nordic MQTT server. It provides EMQX, optional PostgreSQL persistence, built-in MQTT users, and ACL isolation between project topic spaces.

## Quick Start

```bash
cp .env.example .env
docker compose up -d
```

Set real passwords in `.env` before deploying. `.env` is intentionally ignored by Git.

## Included

- MQTT TCP: `1883`
- MQTT WebSocket: `8083`
- MQTT WSS: `8084`
- Dashboard credentials from `.env`
- MQTT users created by `init/setup.sh`
- ACL file: `emqx/acl.conf`
- Message persistence table: `mqtt_messages`

## Verify

```bash
set -a
. ./.env
set +a
./verify.sh
```
