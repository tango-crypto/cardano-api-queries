-- Get asset metadata
WITH "asset" AS (
	SELECT 
		MAX(tx_metadata.tx_id) AS LAST_MINTED_TX_ID
-- 		tx_metadata.tx_id AS LAST_MINTED_TX_ID
	FROM "ma_tx_mint"
	INNER JOIN "multi_asset" AS "asset" ON "asset"."id" = "ma_tx_mint"."ident"
	INNER JOIN "tx_metadata" ON "tx_metadata"."tx_id" = "ma_tx_mint"."tx_id"
	WHERE ASSET.FINGERPRINT = 'asset1l6rg97vuuqf7ycqyz5lwkmvzu4s2hdqdlk0yk2'
-- 	ORDER BY tx_metadata.tx_id DESC NULLS LAST LIMIT 1 -- (this is equivalent to MAX where null are ignored)
-- 	;
)
SELECT 
	JSONB_BUILD_OBJECT('json',TX_METADATA.JSON) || JSONB_BUILD_OBJECT('label',TX_METADATA.KEY) AS METADATA
FROM "asset"
INNER JOIN "tx_metadata" ON "tx_metadata"."tx_id" = "asset"."last_minted_tx_id";
