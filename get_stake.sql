SELECT STAKE_ACTIVE(SD.ID,DELEGATION.TX_ID) AS ACTIVE,
	"block"."epoch_no" AS "active_epoch",
	COALESCE(UTXO_VIEW.CONTROLLED_TOTAL_STAKE,0) + COALESCE(REWARD.REWARDS_SUM,0) - COALESCE(WD.WITHDRAWALS_SUM,0) AS CONTROLLED_TOTAL_STAKE,
	COALESCE(REWARD.REWARDS_SUM,0) AS REWARDS_SUM,
	COALESCE(WD.WITHDRAWALS_SUM,0) AS WITHDRAWALS_SUM,
	COALESCE(RESERVE.RESERVES_SUM,0) AS RESERVES_SUM,
	COALESCE(TREASURY.TREASURY_SUM,0) AS TREASURY_SUM,
	COALESCE(REWARD.REWARDS_SUM,0) - COALESCE(WD.WITHDRAWALS_SUM,0) AS WITHDRAW_AVAILABLE,
	(SELECT "pool_hash"."view"
		FROM STAKE_ADDRESS AS SA
		INNER JOIN DELEGATION DEL ON DEL.ADDR_ID = SA.ID
		INNER JOIN POOL_HASH ON POOL_HASH.ID = DEL.POOL_HASH_ID
		WHERE "sa"."view" = 'stake_test1uzxpncx82vfkl5ml00ws44hzfdh64r22kr93e79jqsumv0q8g8cy0'
		ORDER BY DEL.ACTIVE_EPOCH_NO DESC
		LIMIT 1) AS POOL_ID
FROM "stake_address" AS "sa"
LEFT JOIN
	(SELECT "utxo_view"."stake_address_id",
			SUM(UTXO_VIEW.VALUE) AS CONTROLLED_TOTAL_STAKE
		FROM "utxo_view"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "utxo_view"."stake_address_id"
		WHERE "sa"."view" = 'stake_test1uzxpncx82vfkl5ml00ws44hzfdh64r22kr93e79jqsumv0q8g8cy0'
		GROUP BY "utxo_view"."stake_address_id") AS "utxo_view" ON "utxo_view"."stake_address_id" = "sa"."id"
LEFT JOIN
	(SELECT "reward"."addr_id",
			SUM(REWARD.AMOUNT) AS REWARDS_SUM
		FROM "reward"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "reward"."addr_id"
		WHERE "sa"."view" = 'stake_test1uzxpncx82vfkl5ml00ws44hzfdh64r22kr93e79jqsumv0q8g8cy0'
		GROUP BY "reward"."addr_id") AS "reward" ON "reward"."addr_id" = "sa"."id"
LEFT JOIN
	(SELECT "withdrawal"."addr_id",
			SUM(WITHDRAWAL.AMOUNT) AS WITHDRAWALS_SUM
		FROM "withdrawal"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "withdrawal"."addr_id"
		WHERE "sa"."view" = 'stake_test1uzxpncx82vfkl5ml00ws44hzfdh64r22kr93e79jqsumv0q8g8cy0'
		GROUP BY "withdrawal"."addr_id") AS "wd" ON "wd"."addr_id" = "sa"."id"
LEFT JOIN
	(SELECT "reserve"."addr_id",
			SUM(RESERVE.AMOUNT) AS RESERVES_SUM
		FROM "reserve"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "reserve"."addr_id"
		WHERE "sa"."view" = 'stake_test1uzxpncx82vfkl5ml00ws44hzfdh64r22kr93e79jqsumv0q8g8cy0'
		GROUP BY "reserve"."addr_id") AS "reserve" ON "reserve"."addr_id" = "sa"."id"
LEFT JOIN
	(SELECT "treasury"."addr_id",
			SUM(TREASURY.AMOUNT) AS TREASURY_SUM
		FROM "treasury"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "treasury"."addr_id"
		WHERE "sa"."view" = 'stake_test1uzxpncx82vfkl5ml00ws44hzfdh64r22kr93e79jqsumv0q8g8cy0'
		GROUP BY "treasury"."addr_id") AS "treasury" ON "treasury"."addr_id" = "sa"."id"
LEFT JOIN "delegation" ON "delegation"."addr_id" = "sa"."id"
LEFT JOIN "tx" ON "tx"."id" = "delegation"."tx_id"
LEFT JOIN "block" ON "block"."id" = "tx"."block_id"
LEFT JOIN "stake_deregistration" AS "sd" ON "sd"."addr_id" = "sa"."id"
WHERE "sa"."view" = 'stake_test1uzxpncx82vfkl5ml00ws44hzfdh64r22kr93e79jqsumv0q8g8cy0'
LIMIT 1
