SELECT ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
	"asset"."fingerprint",
	SUM(MA_TX_MINT.QUANTITY) AS QUANTITY,
	COALESCE(SUM(MA_TX_MINT.QUANTITY) FILTER (WHERE MA_TX_MINT.QUANTITY > 0),0) AS MINT_QUANTITY,
	COALESCE(SUM(MA_TX_MINT.QUANTITY) FILTER (WHERE MA_TX_MINT.QUANTITY < 0),0) AS BURN_QUANTITY,
	COUNT(*) AS MINT_TRANSACTIONS,
	MIN(block.time) as created_at,
	array_remove(array_agg(
		CASE WHEN TX_METADATA.KEY IS NOT NULL THEN JSONB_BUILD_OBJECT('json',TX_METADATA.JSON) || JSONB_BUILD_OBJECT('label',TX_METADATA.KEY) ELSE NULL END),
	NULL) AS METADATA
FROM "ma_tx_mint"
INNER JOIN "tx" ON "tx"."id" = "ma_tx_mint"."tx_id"
INNER JOIN "block" ON "block"."id" = "tx"."block_id"
INNER JOIN "multi_asset" AS "asset" ON "asset"."id" = "ma_tx_mint"."ident"
LEFT JOIN "tx_metadata" ON "tx_metadata"."tx_id" = "tx"."id"
WHERE ASSET.FINGERPRINT = 'asset1uq7kmkq4re85zgxtuzweayl23lgs7tjytw24u2'
GROUP BY "asset"."policy", "asset"."name", "asset"."fingerprint";
