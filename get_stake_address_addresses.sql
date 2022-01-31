SELECT "a"."tx_id",
	"a"."index",
	"a"."address"
FROM
	(SELECT MAX(TX_OUT.TX_ID) AS TX_ID,
			MAX(TX_OUT.INDEX) AS INDEX,
			"tx_out"."address"
		FROM "tx_out"
		INNER JOIN "stake_address" AS "sa" ON "tx_out"."stake_address_id" = "sa"."id"
		WHERE "sa"."view" = 'stake_test1urtt0tpxwxyll6gclxnz5srjx3zjr099pgrqkd3st7339tcr0u0ph'
		GROUP BY "tx_out"."address") AS "a"
WHERE A.TX_ID < 58574 OR (A.TX_ID = 58574 AND A.INDEX < 0)
ORDER BY A.TX_ID DESC, A.INDEX DESC
LIMIT 50
