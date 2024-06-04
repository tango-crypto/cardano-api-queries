-- Get address/asset/utxos
SELECT 
	tx_out.tx_id,
	tx_out.address,
	encode("tx"."hash", 'hex') as hash,
	"tx_out"."index",
	"tx_out"."value",
	tx_out.address_has_script as smart_contract,
	tx_out.address_has_script as has_script,
	"mto"."quantity",
	"asset"."fingerprint",
	ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
	NULLIF(JSONB_STRIP_NULLS(
		JSONB_BUILD_OBJECT('type', script.type) || 
		JSONB_BUILD_OBJECT('hash', encode(script.hash, 'hex'))  || 
		JSONB_BUILD_OBJECT('json', script.json)  || 
		JSONB_BUILD_OBJECT('code', encode(script.bytes, 'hex')) ||
		JSONB_BUILD_OBJECT('serialised_size', script.serialised_size) ||
		JSONB_BUILD_OBJECT('datum', NULLIF(JSONB_STRIP_NULLS(
			JSONB_BUILD_OBJECT('hash', case when tx_out.data_hash is not null then encode(tx_out.data_hash, 'hex') else encode(datum.hash, 'hex') end) ||
			JSONB_BUILD_OBJECT('value', datum.value) ||
			JSONB_BUILD_OBJECT('value_raw', encode(datum.bytes, 'hex'))
		), '{}'::JSONB))
	), '{}'::JSONB) as script
FROM "tx_out"
INNER JOIN tx on tx.id = tx_out.tx_id
INNER JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "tx_out"."id"
INNER JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
LEFT JOIN "tx_in" as tx_in ON "tx_out"."tx_id" = "tx_in"."tx_out_id" AND "tx_out"."index" = "tx_in"."tx_out_index"
left join datum on datum.hash = tx_out.data_hash or datum.id = tx_out.inline_datum_id
left join script on script.id = tx_out.reference_script_id OR script.hash = tx_out.payment_cred
where  TX_IN.TX_IN_ID IS NULL 
AND tx_out.address = 'addr_test1wrhtrx98lc6dc2zk0uuv0hjjcrffq5fvllq9k7u6cajfvhq0rqywz'
AND asset.fingerprint = 'asset1r5mrxn5377473gus6jzq3n947j33flenl4qptm'
-- AND (tx_out.tx_id < 2387895 or (tx_out.tx_id = 2387895 and tx_out.index < 1))
ORDER BY tx_out.tx_id desc, tx_out.index desc
limit 100;
