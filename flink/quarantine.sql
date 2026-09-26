SET 'sql-client.execution.result-mode' = 'tableau';

CREATE TABLE transactions (
    transaction_id STRING,
    user_id STRING,
    amount DOUBLE,
    event_time STRING,
    status STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'checkout-telemetry',
    'properties.bootstrap.servers' = 'icestream-kafka:29092',
    'properties.group.id' = 'icestream-quarantine-group',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json',
    'json.ignore-parse-errors' = 'true'
);
SELECT
    transaction_id,
    user_id,
    amount,
    event_time,
    status,'QUARANTINED' AS quarantine_status
FROM transactions 
WHERE transaction_id IS NULL OR user_id IS NULL OR amount <= 0 OR status NOT IN ('success', 'failed');