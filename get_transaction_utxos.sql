-- get transaction UTXOs
SELECT "utxo"."address",
	ENCODE(TX.HASH,'hex') AS HASH,
	"utxo"."index",
	"utxo"."value",
	UTXO.ADDRESS_HAS_SCRIPT AS SMART_CONTRACT,
	"mto"."quantity",
	"asset"."fingerprint",
	ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME
FROM "tx_out" AS "utxo"
INNER JOIN "tx" ON "tx"."id" = "utxo"."tx_id"
LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "utxo"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
WHERE TX.HASH = DECODE('5b730376c443e748705109cca163ed9115b0c4e6fd9459022864dfcc03dd4772','hex')
UNION
SELECT "tx_out"."address",
	"tx_out"."hash",
	"tx_out"."index",
	"tx_out"."value",
	TX_OUT.ADDRESS_HAS_SCRIPT AS SMART_CONTRACT,
	"mto"."quantity",
	"asset"."fingerprint",
	ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME
FROM "tx_in"
INNER JOIN
(
	SELECT "tx_out".*,
		ENCODE(TX.HASH,'hex') AS HASH
	FROM "tx_out"
	INNER JOIN "tx" ON "tx"."id" = "tx_out"."tx_id"
) AS "tx_out" ON "tx_out"."tx_id" = "tx_in"."tx_out_id" AND "tx_out"."index" = "tx_in"."tx_out_index"
INNER JOIN "tx" ON "tx"."id" = "tx_in"."tx_in_id"
LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "tx_out"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
WHERE TX.HASH = DECODE('5b730376c443e748705109cca163ed9115b0c4e6fd9459022864dfcc03dd4772','hex')
