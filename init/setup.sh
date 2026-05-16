#!/bin/sh
# Bootstrap MQTT users after EMQX starts.
# EMQX 6.0 REST API: POST /api/v5/authentication/password_based:built_in_database/users

EMQX_API="http://emqx:18083/api/v5"
AUTH="admin:admin1234"

echo "Waiting for EMQX API..."
until curl -sf -o /dev/null "$EMQX_API/status"; do
  sleep 2
done
echo "EMQX API ready."

create_user() {
  local user=$1 pass=$2
  echo -n "Creating user '$user' ... "
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -u "$AUTH" \
    -X POST "$EMQX_API/authentication/password_based:built_in_database/users" \
    -H "Content-Type: application/json" \
    -d "{\"user_id\":\"$user\",\"password\":\"$pass\"}")
  if [ "$STATUS" = "201" ] || [ "$STATUS" = "200" ]; then
    echo "OK ($STATUS)"
  elif [ "$STATUS" = "409" ]; then
    echo "already exists (409)"
  else
    echo "FAILED ($STATUS)"
  fi
}

create_user "coap-server"   "coap123456"
create_user "nrf"           "nrf123456"
create_user "sensor-device" "sensor123456"
create_user "vessel"        "vessel123456"

echo "Users bootstrapped."
