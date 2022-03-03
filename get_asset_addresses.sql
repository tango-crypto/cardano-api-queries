SELECT 
"tx_out"."address",
SUM(MTO.QUANTITY) AS QUANTITY
FROM "ma_tx_out" AS "mto"
INNER JOIN "multi_asset" AS "ma" ON "ma"."id" = "mto"."ident"
INNER JOIN "tx_out" ON "tx_out"."id" = "mto"."tx_out_id"
LEFT JOIN "tx_in" ON "tx_in"."tx_out_id" = "tx_out"."tx_id"
AND "tx_out"."index" = "tx_in"."tx_out_index"
WHERE MA.POLICY = DECODE('b3fd2e8b5764818d9b33e2bc8d9e84a61fa39e75cf0c41393ee6c7a9','hex')
AND MA.NAME = DECODE('456e6456696f6c656e6365506c61737469633437393761','hex')
AND TX_IN.TX_IN_ID IS NULL
AND TX_OUT.ADDRESS > 'addr_test1qphzuz2250w0zljmt24x37c36nu8nyhv2s8nced4u7psfegtg2ckq83t2adz9gv0y0d0hyz0yj6dmendf7enpze0y33qm8wldn'
GROUP BY "tx_out"."address"
ORDER BY "tx_out"."address" ASC
LIMIT 50;
