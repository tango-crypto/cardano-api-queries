SELECT SUM(T.TOTAL) AS TOTAL
FROM
	(SELECT COUNT(DISTINCT TX_OUT.TX_ID) AS TOTAL
		FROM "tx_out"
		WHERE "tx_out"."address" = 'addr_test1wrsexavz37208qda7mwwu4k7hcpg26cz0ce86f5e9kul3hqzlh22t'
		UNION ALL SELECT COUNT(DISTINCT TX_IN.TX_IN_ID) AS TOTAL
		FROM "tx_out"
		INNER JOIN "tx_in" ON "tx_in"."tx_out_id" = "tx_out"."tx_id"
		AND "tx_in"."tx_out_index" = "tx_out"."index"
		WHERE "tx_out"."address" = 'addr_test1wrsexavz37208qda7mwwu4k7hcpg26cz0ce86f5e9kul3hqzlh22t'
	) AS "t"
