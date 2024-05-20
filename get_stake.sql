SELECT 
	(
	  CASE 
	    WHEN SD.ID IS NULL AND DELEGATION.TX_ID IS NOT NULL THEN true 
	    ELSE false 
	  END
	) AS ACTIVE,
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
		WHERE "sa"."view" = 'stake1u83fqtl4xq5lxtjz47t8w0gtgzu8krrlx66prdvcxq0zl2gu0pdkz'
		ORDER BY DEL.tx_id DESC
		LIMIT 1
    ) AS POOL_ID
FROM "stake_address" AS "sa"
LEFT JOIN
	(SELECT "utxo_view"."stake_address_id",
			SUM(UTXO_VIEW.VALUE) AS CONTROLLED_TOTAL_STAKE
		FROM "utxo_view"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "utxo_view"."stake_address_id"
		WHERE "sa"."view" = 'stake1u83fqtl4xq5lxtjz47t8w0gtgzu8krrlx66prdvcxq0zl2gu0pdkz'
		GROUP BY "utxo_view"."stake_address_id"
    ) AS "utxo_view" ON "utxo_view"."stake_address_id" = "sa"."id"
LEFT JOIN
	(
        SELECT "reward"."addr_id",
			SUM(REWARD.AMOUNT) AS REWARDS_SUM
		FROM "reward"
		INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "reward"."addr_id"
		WHERE "sa"."view" = 'stake1u83fqtl4xq5lxtjz47t8w0gtgzu8krrlx66prdvcxq0zl2gu0pdkz'
		GROUP BY "reward"."addr_id"
    ) AS "reward" ON "reward"."addr_id" = "sa"."id"
LEFT JOIN
	(
        SELECT w.addr_id,
            SUM(w.AMOUNT) AS WITHDRAWALS_SUM
        FROM (
            SELECT DISTINCT ON (withdrawal.tx_id) "withdrawal"."addr_id", "withdrawal"."amount"
            FROM "withdrawal"
            INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "withdrawal"."addr_id"
            WHERE "sa"."view" = 'stake1u83fqtl4xq5lxtjz47t8w0gtgzu8krrlx66prdvcxq0zl2gu0pdkz'
        ) w
        GROUP BY "w"."addr_id"
    ) AS "wd" ON "wd"."addr_id" = "sa"."id"
LEFT JOIN
	(
        SELECT "reserve"."addr_id",
            SUM(reserve.AMOUNT) AS RESERVES_SUM
        FROM (
            SELECT DISTINCT ON ("reserve"."tx_id") "reserve"."addr_id", "reserve"."amount"
            FROM "reserve"
            INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "reserve"."addr_id"
            WHERE "sa"."view" = 'stake1u83fqtl4xq5lxtjz47t8w0gtgzu8krrlx66prdvcxq0zl2gu0pdkz'
        ) AS "reserve"
        GROUP BY "reserve"."addr_id"
    ) AS "reserve" ON "reserve"."addr_id" = "sa"."id"
LEFT JOIN
	(
        SELECT "treasury"."addr_id",
            SUM(TREASURY.AMOUNT) AS TREASURY_SUM
        FROM (
            SELECT DISTINCT ON ("treasury"."tx_id") "treasury"."addr_id", "treasury"."amount"
            FROM "treasury"
            INNER JOIN "stake_address" AS "sa" ON "sa"."id" = "treasury"."addr_id"
            WHERE "sa"."view" = 'stake1u83fqtl4xq5lxtjz47t8w0gtgzu8krrlx66prdvcxq0zl2gu0pdkz'
        ) AS "treasury"
        GROUP BY "treasury"."addr_id"
    ) AS "treasury" ON "treasury"."addr_id" = "sa"."id"
LEFT JOIN "delegation" ON "delegation"."addr_id" = "sa"."id"
LEFT JOIN "tx" ON "tx"."id" = "delegation"."tx_id"
LEFT JOIN "block" ON "block"."id" = "tx"."block_id"
LEFT JOIN "stake_deregistration" AS "sd" ON "sd"."addr_id" = "sa"."id"
WHERE "sa"."view" = 'stake1u83fqtl4xq5lxtjz47t8w0gtgzu8krrlx66prdvcxq0zl2gu0pdkz'
LIMIT 1;
