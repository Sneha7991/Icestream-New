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
    'properties.group.id' = 'icestream-validation-group',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json',
    'json.ignore-parse-errors' = 'true'
);

SELECT
    transaction_id,
    user_id,
    amount,
    event_time,
    status,
    CASE
        WHEN transaction_id IS NULL THEN 'INVALID'
        WHEN user_id IS NULL THEN 'INVALID'
        WHEN amount <= 0 THEN 'INVALID'
        WHEN status NOT IN ('success', 'failed') THEN 'INVALID'
        ELSE 'VALID'
    END AS validation_status
FROM transactions;