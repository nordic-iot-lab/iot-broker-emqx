-- PG init: create mqtt_messages table for EMQX persistence
CREATE TABLE IF NOT EXISTS mqtt_messages (
    id SERIAL PRIMARY KEY,
    topic VARCHAR(500) NOT NULL,
    payload TEXT,
    qos INTEGER DEFAULT 0,
    retain BOOLEAN DEFAULT FALSE,
    client_id VARCHAR(256),
    username VARCHAR(128),
    timestamp TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_mqtt_messages_topic ON mqtt_messages(topic);
CREATE INDEX IF NOT EXISTS idx_mqtt_messages_timestamp ON mqtt_messages(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_mqtt_messages_topic_ts ON mqtt_messages(topic, timestamp DESC);
