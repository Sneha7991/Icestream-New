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
    'properties.group.id' = 'icestream-metrics',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json',
    'json.ignore-parse-errors' = 'true'
);

SELECT
    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN transaction_id IS NOT NULL
             AND user_id IS NOT NULL
             AND amount > 0
             AND status IN ('success', 'failed')
            THEN 1
            ELSE 0
        END
    ) AS valid_transactions,

    SUM(
        CASE
            WHEN transaction_id IS NULL
              OR user_id IS NULL
              OR amount <= 0
              OR status NOT IN ('success', 'failed')
            THEN 1
            ELSE 0
        END
    ) AS invalid_transactions,

    SUM(
        CASE
            WHEN transaction_id IS NULL
              OR user_id IS NULL
              OR amount <= 0
              OR status NOT IN ('success', 'failed')
            THEN 1
            ELSE 0
        END
    ) AS quarantined_transactions,

    SUM(
        CASE
            WHEN transaction_id IS NOT NULL
             AND user_id IS NOT NULL
             AND amount > 0
             AND status = 'success'
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,

    SUM(
        CASE
            WHEN transaction_id IS NOT NULL
             AND user_id IS NOT NULL
             AND amount > 0
             AND status = 'failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions

FROM transactions;