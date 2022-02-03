SELECT DISTINCT (TX_OUT.ADDRESS) AS ADDRESS
FROM "tx_out"
INNER JOIN "stake_address" AS "sa" ON "tx_out"."stake_address_id" = "sa"."id"
WHERE SA.VIEW = 'stake_test1urtt0tpxwxyll6gclxnz5srjx3zjr099pgrqkd3st7339tcr0u0ph'
ORDER BY "tx_out"."address" DESC
LIMIT 50;
