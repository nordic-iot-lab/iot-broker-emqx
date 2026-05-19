# Changelog

All notable changes to this project are documented in this file.

## [0.1.3] - 2026-05-19

### Security

- Added MQTT TLS listener `8883` with mounted certificate directory support.
- Tightened ACL defaults so device accounts publish telemetry and the dashboard account subscribes only.
- Kept EMQX Dashboard `18083` private to the Docker network by default.
- Added dashboard MQTT user bootstrap and safer JSON generation in setup scripts.

## [0.1.2] - 2026-05-18

### Added

- Regenerated the broker layout visual with the Python/matplotlib Nature-style figure workflow.
- Added PNG, SVG, and PDF exports for GitHub display and editable documentation assets.

## [0.1.1] - 2026-05-18

### Added

- Added bilingual Chinese/English GitHub README documentation.
- Added a visual broker layout diagram for the Docker, EMQX, ACL, and PostgreSQL deployment.
- Documented the Nordic IoT Lab organization release baseline and repository role.

## [0.1.0] - 2026-05-17

### Added

- Added EMQX 6 Docker Compose deployment with MQTT TCP, WebSocket, and WSS listeners.
- Added file-based ACL isolation for `sensor/#`, `industrial/#`, and `vessel/#` projects.
- Added PostgreSQL persistence for MQTT messages.
- Added environment-driven MQTT user bootstrap and verification script.
- Added version metadata for the server/broker configuration baseline.
