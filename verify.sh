#!/bin/bash
# Verify MQTT project isolation
# Requires: mosquitto-clients (apt install mosquitto-clients)

BROKER="${MQTT_HOST:-localhost}"
PORT="${MQTT_PORT:-1883}"
COAP_USER="${MQTT_COAP_SERVER_USER:-coap-server}"
COAP_PASS="${MQTT_COAP_SERVER_PASS:?set MQTT_COAP_SERVER_PASS}"
NRF_USER="${MQTT_NRF_USER:-nrf}"
NRF_PASS="${MQTT_NRF_PASS:?set MQTT_NRF_PASS}"
SENSOR_USER="${MQTT_SENSOR_DEVICE_USER:-sensor-device}"
SENSOR_PASS="${MQTT_SENSOR_DEVICE_PASS:?set MQTT_SENSOR_DEVICE_PASS}"
DASHBOARD_USER="${MQTT_DASHBOARD_USER:-dashboard}"
DASHBOARD_PASS="${MQTT_DASHBOARD_PASS:?set MQTT_DASHBOARD_PASS}"
VESSEL_USER="${MQTT_VESSEL_USER:-vessel}"
VESSEL_PASS="${MQTT_VESSEL_PASS:?set MQTT_VESSEL_PASS}"

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
test_pub "$COAP_USER" "$COAP_PASS"     "sensor/a1b2/data"     "coap-server -> sensor/#"
test_pub "$NRF_USER" "$NRF_PASS"       "industrial/tag/state" "nrf -> industrial/#"
test_pub "$SENSOR_USER" "$SENSOR_PASS" "sensor/c3d4/data"     "sensor-device -> sensor/#"

echo ""
echo "--- vessel project (should succeed) ---"
test_pub "$VESSEL_USER" "$VESSEL_PASS" "vessel/engine/temp" "vessel -> vessel/#"

echo ""
echo "--- cross-project (must FAIL) ---"
test_pub "$COAP_USER" "$COAP_PASS"   "vessel/test" "coap-server -> vessel/# (should fail)"
test_pub "$VESSEL_USER" "$VESSEL_PASS" "sensor/test" "vessel -> sensor/# (should fail)"
test_pub "$DASHBOARD_USER" "$DASHBOARD_PASS" "sensor/test" "dashboard publish -> sensor/# (should fail)"

echo ""
echo "--- unauthenticated (must FAIL) ---"
test_pub "" "" "sensor/test" "anonymous publish (should fail)"

echo ""
echo "Done. 'FAILED' on cross-project and anonymous = isolation works."
