#!/bin/bash
# Verify MQTT project isolation
# Requires: mosquitto-clients (apt install mosquitto-clients)

BROKER="${MQTT_HOST:-localhost}"
PORT="${MQTT_PORT:-1883}"

echo "=== MQTT Isolation Test ==="
echo "Broker: $BROKER:$PORT"
echo ""

test_pub() {
  local user=$1 pass=$2 topic=$3 label=$4
  mosquitto_pub -h "$BROKER" -p "$PORT" \
    -u "$user" -P "$pass" \
    -t "$topic" -m "{\"test\":\"$label\"}" \
    -q 1 -W 3 2>/dev/null && echo "  $label: OK" || echo "  $label: FAILED"
}

echo "--- sensor/nrf project (should succeed) ---"
test_pub coap-server coap123456 "sensor/a1b2/data"     "coap-server → sensor/#"
test_pub nrf nrf123456           "industrial/tag/state" "nrf → industrial/#"
test_pub sensor-device sensor123456 "sensor/c3d4/data"  "sensor-device → sensor/#"

echo ""
echo "--- vessel project (should succeed) ---"
test_pub vessel vessel123456 "vessel/engine/temp" "vessel → vessel/#"

echo ""
echo "--- cross-project (must FAIL) ---"
test_pub coap-server coap123456 "vessel/test"     "coap-server → vessel/# (should fail)"
test_pub vessel vessel123456    "sensor/test"     "vessel → sensor/# (should fail)"

echo ""
echo "--- unauthenticated (must FAIL) ---"
test_pub "" "" "sensor/test" "anonymous publish (should fail)"

echo ""
echo "Done. 'FAILED' on cross-project and anonymous = isolation works."
