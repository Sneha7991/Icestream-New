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
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = 'icestream-flink-group',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json',
    'json.ignore-parse-errors' = 'true'
);

SELECT *
FROM transactions;