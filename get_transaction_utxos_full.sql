SELECT -- outputs
	"utxo"."address",
	ENCODE(TX.HASH,'hex') AS HASH,
	"utxo"."index",
	"utxo"."value",
	UTXO.ADDRESS_HAS_SCRIPT AS has_script,
	"mto"."quantity",
	"asset"."fingerprint",
	ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
	NULLIF(JSONB_STRIP_NULLS(JSONB_BUILD_OBJECT('type', script.type) || 
	JSONB_BUILD_OBJECT('hash', encode(script.hash, 'hex')) || 
	JSONB_BUILD_OBJECT('json', script.json) || 
	JSONB_BUILD_OBJECT('code', encode(script.bytes, 'hex')) || 
	JSONB_BUILD_OBJECT('serialised_size', script.serialised_size) || 
	JSONB_BUILD_OBJECT('datum', NULLIF(JSONB_STRIP_NULLS(
				    JSONB_BUILD_OBJECT('hash', case when utxo.data_hash is not null then encode(utxo.data_hash, 'hex') else encode(datum.hash, 'hex') end) || 
				    JSONB_BUILD_OBJECT('value', datum.value) || 
				    JSONB_BUILD_OBJECT('value_raw', encode(datum.bytes, 'hex'))
		          ), '{}'::JSONB))
	), '{}'::JSONB) as script
FROM "tx_out" AS "utxo"
INNER JOIN "tx" ON "tx"."id" = "utxo"."tx_id"
left join datum on datum.hash = utxo.data_hash or datum.id = utxo.inline_datum_id
left join script on script.id = utxo.reference_script_id OR script.hash = utxo.payment_cred
LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "utxo"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
WHERE TX.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd','hex')
UNION
SELECT -- inputs
	"tx_out"."address",
	"tx_out"."hash",
	"tx_out"."index",
	"tx_out"."value",
	TX_OUT.ADDRESS_HAS_SCRIPT AS has_script,
	"mto"."quantity",
	"asset"."fingerprint",
	ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
	ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
-- 	case when c.id is not null then true else false end as is_collateral,
NULLIF(JSONB_STRIP_NULLS(
JSONB_BUILD_OBJECT('type', script.type) || 
JSONB_BUILD_OBJECT('hash', encode(script.hash, 'hex'))  || 
JSONB_BUILD_OBJECT('json', script.json) || 
JSONB_BUILD_OBJECT('code', encode(script.bytes, 'hex')) || 
JSONB_BUILD_OBJECT('serialised_size', script.serialised_size) || 
JSONB_BUILD_OBJECT('redeemer', NULLIF(JSONB_STRIP_NULLS(JSONB_BUILD_OBJECT('unit_mem', redeemer.unit_mem) || 
				JSONB_BUILD_OBJECT('unit_steps', redeemer.unit_steps) || 
				JSONB_BUILD_OBJECT('index', redeemer.index) || 
				JSONB_BUILD_OBJECT('fee', redeemer.fee) || 
				JSONB_BUILD_OBJECT('purpose', redeemer.purpose) || 
				JSONB_BUILD_OBJECT('script_hash', encode(redeemer.script_hash, 'hex')) || 
				JSONB_BUILD_OBJECT('data', NULLIF(JSONB_STRIP_NULLS(
							   JSONB_BUILD_OBJECT('hash', encode(rd.hash, 'hex')) || 
						           JSONB_BUILD_OBJECT('value', rd.value) || 
						           JSONB_BUILD_OBJECT('value_raw', encode(rd.bytes, 'hex'))
						    ), '{}'::JSONB))
	            ), '{}'::JSONB))
), '{}'::JSONB) as script
FROM "tx_in"
INNER JOIN
(SELECT 
	"tx_out".*, ENCODE(TX.HASH,'hex') AS HASH
 FROM "tx_out"
 INNER JOIN "tx" ON "tx"."id" = "tx_out"."tx_id"
) AS "tx_out" ON "tx_out"."tx_id" = "tx_in"."tx_out_id" AND "tx_out"."index" = "tx_in"."tx_out_index"
INNER JOIN "tx" ON "tx"."id" = "tx_in"."tx_in_id"
left join script on script.id = tx_out.reference_script_id OR script.hash = tx_out.payment_cred
LEFT JOIN redeemer on redeemer.id = tx_in.redeemer_id
LEFT JOIN redeemer_data rd on rd.id = redeemer.redeemer_data_id
LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "tx_out"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
WHERE TX.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd', 'hex');

	
	
	
