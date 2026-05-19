# TLS certificate mount point

Place broker TLS files here before running `docker compose up -d`:

- `cert.pem`: broker certificate
- `key.pem`: broker private key
- `ca.pem`: issuing CA certificate

For public MQTT TLS, use a real certificate whose subject/SAN matches the MQTT host name.
For mutual TLS, also change `verify = verify_peer` in `emqx/emqx.conf` and provision
client certificates on devices.
