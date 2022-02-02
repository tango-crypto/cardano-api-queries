SELECT "tx"."id",
	"tx"."block_id",
	ENCODE(TX.HASH,'hex') AS HASH,
	"tx"."block_index",
	"tx"."out_sum",
	"tx"."fee",
	"tx"."deposit",
	"tx"."size",
	"tx"."invalid_before",
	"tx"."invalid_hereafter",
	"tx"."valid_contract",
	"tx"."script_size",
	(SELECT COUNT(*)
		FROM
			(SELECT TX.ID
				FROM TX_OUT
				WHERE TX_OUT.TX_ID = TX.ID
				UNION ALL (SELECT TX.ID
						   FROM TX_IN
						   WHERE TX_IN.TX_IN_ID = TX.ID)
			) TX_COUNT
	) AS UTXO_COUNT,
	(SELECT COUNT(*) FROM WITHDRAWAL WHERE WITHDRAWAL.TX_ID = TX.ID) AS WITHDRAWAL_COUNT,
	(SELECT COUNT(*) FROM DELEGATION WHERE DELEGATION.TX_ID = TX.ID) AS DELEGATION_COUNT,
	(SELECT COUNT(*) FROM STAKE_REGISTRATION WHERE STAKE_REGISTRATION.TX_ID = TX.ID) AS STAKE_CERT_COUNT,
	EXISTS
	(SELECT 1 FROM POOL_UPDATE WHERE POOL_UPDATE.REGISTERED_TX_ID = TX.ID) AS POOL_UPDATE,
	EXISTS
	(SELECT 1 FROM POOL_RETIRE WHERE POOL_RETIRE.ANNOUNCED_TX_ID = TX.ID) AS POOL_RETIRE,
	(SELECT COUNT(*) FROM MA_TX_MINT WHERE MA_TX_MINT.TX_ID = TX.ID) AS ASSET_MINT_OR_BURN_COUNT,
	ENCODE(BLOCK.HASH,'hex') AS BLOCK_HASH,
	"block"."epoch_no" AS "block_epoch_no",
	"block"."block_no" AS "block_block_no",
	"block"."slot_no" AS "block_slot_no",
	"asset"."quantity",
	"asset"."policy_id",
	"asset"."asset_name",
	"asset"."fingerprint"
FROM "tx"
INNER JOIN "block" ON "block"."id" = "tx"."block_id"
INNER JOIN
(
	SELECT "tx"."id" AS "tx_id",
		SUM(MTO.QUANTITY) AS QUANTITY,
		ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
		ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
		"asset"."fingerprint"
	FROM "tx_out" AS "utxo"
	INNER JOIN "tx" ON "tx"."id" = "utxo"."tx_id"
	LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "utxo"."id"
	LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
	WHERE TX.HASH = DECODE('5a1dd8ec8c8209dcf561d3bef62fc75485975a91289ab62771a8f5b41bf98d88','hex')
	GROUP BY "tx"."id", "asset"."policy", "asset"."name", "asset"."fingerprint"
) AS "asset" ON "asset"."tx_id" = "tx"."id"
