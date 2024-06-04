-- Get address UTXOs
WITH "t" AS
	(SELECT DISTINCT(TX_OUT.TX_ID) AS TX_ID,
			"tx_out"."id",
			"tx_out"."index",
			"tx_out"."value",
			TX_OUT.ADDRESS_HAS_SCRIPT AS SMART_CONTRACT,
			"tx_out"."address"
		FROM "tx_out"
		LEFT JOIN "tx_in" ON "tx_out"."tx_id" = "tx_in"."tx_out_id"
		AND "tx_out"."index" = "tx_in"."tx_out_index"
		WHERE TX_IN.TX_IN_ID IS NULL
			AND TX_OUT.ADDRESS = 'addr_test1wrhtrx98lc6dc2zk0uuv0hjjcrffq5fvllq9k7u6cajfvhq0rqywz'
			AND TX_OUT.TX_ID < 2656228 OR (tx_out.tx_id = 2507820 AND tx_out.index < 1)
		ORDER BY "tx_out"."tx_id" DESC, tx_out.index DESC
		LIMIT 10
	)
SELECT "t"."tx_id",
	"t"."address",
	ENCODE(TX.HASH,'hex') AS HASH,
	"t"."index",
	"t"."value",
	"t"."smart_contract",
	"mto"."quantity",
	ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
	"asset"."fingerprint"
FROM "tx"
INNER JOIN "t" ON "tx"."id" = "t"."tx_id"
LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "t"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
