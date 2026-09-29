SELECT
    transaction_id,
    user_id,
    amount,
    status,
    transaction_time
FROM transactions
WHERE status = 'success';