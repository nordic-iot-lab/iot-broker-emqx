#!/bin/sh
# Bootstrap MQTT users after EMQX starts.
# EMQX 6.0 REST API: POST /api/v5/authentication/password_based:built_in_database/users

EMQX_API="http://emqx:18083/api/v5"
AUTH="${EMQX_DASHBOARD_USER:-admin}:${EMQX_DASHBOARD_PASS:?set EMQX_DASHBOARD_PASS in .env}"

echo "Waiting for EMQX API..."
until curl -sf -o /dev/null "$EMQX_API/status"; do
  sleep 2
done
echo "EMQX API ready."

create_user() {
  local user=$1 pass=$2
  local body
  body=$(json_body "$user" "$pass")
  echo -n "Creating user '$user' ... "
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -u "$AUTH" \
    -X POST "$EMQX_API/authentication/password_based:built_in_database/users" \
    -H "Content-Type: application/json" \
    --data-binary "$body")
  if [ "$STATUS" = "201" ] || [ "$STATUS" = "200" ]; then
    echo "OK ($STATUS)"
  elif [ "$STATUS" = "409" ]; then
    echo "already exists (409)"
  else
    echo "FAILED ($STATUS)"
  fi
}

json_escape() {
  printf '%s' "$1" | tr -d '\n\r\t' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

json_body() {
  printf '{"user_id":"%s","password":"%s"}' "$(json_escape "$1")" "$(json_escape "$2")"
}

create_user "${MQTT_COAP_SERVER_USER:-coap-server}"     "${MQTT_COAP_SERVER_PASS:?set MQTT_COAP_SERVER_PASS in .env}"
create_user "${MQTT_NRF_USER:-nrf}"                     "${MQTT_NRF_PASS:?set MQTT_NRF_PASS in .env}"
create_user "${MQTT_SENSOR_DEVICE_USER:-sensor-device}" "${MQTT_SENSOR_DEVICE_PASS:?set MQTT_SENSOR_DEVICE_PASS in .env}"
create_user "${MQTT_DASHBOARD_USER:-dashboard}"         "${MQTT_DASHBOARD_PASS:?set MQTT_DASHBOARD_PASS in .env}"
create_user "${MQTT_VESSEL_USER:-vessel}"               "${MQTT_VESSEL_PASS:?set MQTT_VESSEL_PASS in .env}"

echo "Users bootstrapped."
