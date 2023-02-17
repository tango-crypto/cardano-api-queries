WITH asset AS (
	SELECT 
		MIN(encode(asset.policy, 'hex')) as policy_id, 
		MIN(encode(asset.name, 'hex')) as asset_name,
		MIN(asset.fingerprint) as fingerprint,
		SUM(MA_TX_MINT.QUANTITY) AS QUANTITY,
		COALESCE(SUM(MA_TX_MINT.QUANTITY) FILTER (WHERE MA_TX_MINT.QUANTITY > 0),0) AS MINT_QUANTITY,
		COALESCE(SUM(MA_TX_MINT.QUANTITY) FILTER (WHERE MA_TX_MINT.QUANTITY < 0),0) AS BURN_QUANTITY,
		COUNT(*) AS MINT_TRANSACTIONS,
		MIN(BLOCK.TIME) AS CREATED_AT,
		MAX(BLOCK.TIME) AS UPDATED_AT,
		MAX(tx.id) FILTER (WHERE TX_METADATA.KEY IS NOT NULL) as last_minted_tx_id
	FROM "ma_tx_mint"
	INNER JOIN "multi_asset" AS "asset" ON "asset"."id" = "ma_tx_mint"."ident"
	INNER JOIN "tx" ON "tx"."id" = "ma_tx_mint"."tx_id"
	INNER JOIN "block" ON "block"."id" = "tx"."block_id"
	LEFT JOIN "tx_metadata" ON "tx_metadata"."tx_id" = tx.id
	WHERE ASSET.FINGERPRINT = 'asset1l6rg97vuuqf7ycqyz5lwkmvzu4s2hdqdlk0yk2'
)
SELECT 
	asset.*,
	CASE WHEN TX_METADATA.KEY IS NOT NULL 
	 	 THEN JSONB_BUILD_OBJECT('json',TX_METADATA.JSON) || JSONB_BUILD_OBJECT('label',TX_METADATA.KEY)
		 ELSE NULL 
	END as metadata

FROM "asset"
LEFT JOIN "tx_metadata" ON "tx_metadata"."tx_id" = asset.last_minted_tx_id;
