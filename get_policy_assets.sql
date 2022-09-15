WITH "asset" AS
(
	SELECT MAX(ASSET.ID) AS ID,
		ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
		ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
		"asset"."fingerprint",
		SUM(MA_TX_MINT.QUANTITY) AS QUANTITY
	FROM "multi_asset" AS "asset"
	INNER JOIN "ma_tx_mint" ON "asset"."id" = "ma_tx_mint"."ident"
	WHERE ASSET.POLICY = DECODE('6f49bf7603e903abd6191ecbe464783425eca9562223b20fe2f6b820','hex') AND ASSET.FINGERPRINT < 'asset1a20hpccjrqgzaredwhxmuea3veaddlkfvzdg24'
	GROUP BY "asset"."policy","asset"."name","asset"."fingerprint"
	ORDER BY "asset"."fingerprint" DESC
	LIMIT 5
)
SELECT 
	DISTINCT ON (ASSET.FINGERPRINT) ASSET.POLICY_ID,
	"asset"."asset_name",
	"asset"."fingerprint",
	"asset"."quantity",
	FIRST_VALUE(ENCODE(TX.HASH,'hex')) OVER(PARTITION BY ASSET.FINGERPRINT ORDER BY TX.ID ASC) AS INITIAL_MINT_TX_HASH
FROM "asset"
INNER JOIN "ma_tx_mint" ON "asset"."id" = "ma_tx_mint"."ident"
INNER JOIN "tx" ON "ma_tx_mint"."tx_id" = "tx"."id"
LEFT JOIN "tx_metadata" ON "ma_tx_mint"."tx_id" = "tx_metadata"."id"
ORDER BY "asset"."fingerprint" DESC
