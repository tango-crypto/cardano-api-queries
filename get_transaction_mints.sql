-- Get transaction mints
select
ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
"asset"."fingerprint",
"mtm"."quantity",
block.time as created_at
from tx
inner join block on block.id = tx.block_id
LEFT JOIN "ma_tx_mint" AS "mtm" ON "mtm"."tx_id" = "tx"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mtm"."ident"
WHERE TX.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd','hex');
