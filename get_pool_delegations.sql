WITH "delegations" AS
	(SELECT "d"."addr_id",
			"d"."tx_id",
			"d"."pool_hash_id",
			"d"."active_epoch_no"
		FROM "pool_hash" AS "p"
		INNER JOIN
			(SELECT DISTINCT ON (D.ADDR_ID) D.ADDR_ID,
					"d"."tx_id",
					"d"."pool_hash_id",
					"d"."active_epoch_no"
				FROM "delegation" AS "d"
				LEFT JOIN
					(SELECT DISTINCT ON (SD.ADDR_ID) SD.TX_ID,
							"sd"."addr_id"
						FROM "stake_deregistration" AS "sd"
						ORDER BY SD.ADDR_ID,
							SD.TX_ID DESC) AS "sd" ON "sd"."addr_id" = "d"."addr_id"
				INNER JOIN "pool_hash" AS "p" ON "p"."id" = "d"."pool_hash_id"
				WHERE SD.ADDR_ID IS NULL
					OR SD.TX_ID < D.TX_ID
				ORDER BY D.ADDR_ID,
					D.TX_ID DESC) AS "d" ON "d"."pool_hash_id" = "p"."id"
		WHERE P.VIEW = 'pool1rnsw42f2q0u9fc32ttxy9l085n736jxz07lvwutz63wpyef03zh'
		ORDER BY "d"."tx_id" DESC
		LIMIT 50)
SELECT "r"."tx_id",
	S.VIEW AS STAKE_ADDRESS,
	R.REWARDS - W.WITHDRAWALS AS AVAILABLE_REWARDS,
	S.STAKE + (R.REWARDS - W.WITHDRAWALS) AS STAKE
FROM
	(SELECT D.TX_ID,
			COALESCE(SUM (R.AMOUNT), 0) AS REWARDS
		FROM "delegations" AS "d"
		LEFT JOIN "reward" AS "r" ON "r"."addr_id" = "d"."addr_id"
		AND R.POOL_ID IS NOT NULL
		GROUP BY D.TX_ID) AS "r"
INNER JOIN
	(SELECT D.TX_ID,
			COALESCE(SUM (W.AMOUNT), 0) AS WITHDRAWALS
		FROM "delegations" AS "d"
		LEFT JOIN
			(SELECT "w"."addr_id",
					"w"."amount",
					"block"."epoch_no"
				FROM "withdrawal" AS "w"
				INNER JOIN "tx" ON "tx"."id" = "w"."tx_id"
				INNER JOIN "block" ON "block"."id" = "tx"."block_id") AS "w" ON "w"."addr_id" = "d"."addr_id"
		GROUP BY D.TX_ID) AS "w" ON "w"."tx_id" = "r"."tx_id"
INNER JOIN
	(SELECT D.TX_ID,
			MAX(SA.VIEW) AS VIEW,
			COALESCE(SUM(UV.VALUE),
				0) AS STAKE
		FROM "delegations" AS "d"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "d"."addr_id"
		LEFT JOIN "utxo_view" AS "uv" ON "uv"."stake_address_id" = "d"."addr_id"
		GROUP BY "d"."tx_id") AS "s" ON "s"."tx_id" = "r"."tx_id"
ORDER BY "r"."tx_id" DESC;
