-- Get asset UTXO metadata
SELECT 
    ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
	DATUM.VALUE AS VALUE,
	ENCODE(DATUM.BYTES,'hex') AS METADATA
FROM "multi_asset" AS "asset"
INNER JOIN "ma_tx_out" AS "mto" ON "mto"."ident" = "asset"."id"
INNER JOIN "tx_out" ON "tx_out"."id" = "mto"."tx_out_id"
INNER JOIN "datum" ON "datum"."hash" = "tx_out"."data_hash" OR "datum"."id" = "tx_out"."inline_datum_id"
WHERE ASSET.FINGERPRINT = 'asset17nxg4qz9wz8mwhhkryglg8myk803qfhwlv6y2r'
ORDER BY "tx_out"."tx_id" DESC
LIMIT 1;
