select -- input collateral utxos
"tx_out"."address",
ENCODE(tt.HASH,'hex') AS HASH,
"tx_out"."index",
"tx_out"."value",
TX_OUT.ADDRESS_HAS_SCRIPT AS has_script,
"mto"."quantity",
"asset"."fingerprint",
ENCODE(ASSET.POLICY,'hex') AS POLICY_ID,
ENCODE(ASSET.NAME,'hex') AS ASSET_NAME,
NULLIF(JSONB_STRIP_NULLS(
JSONB_BUILD_OBJECT('type', script.type) || 
JSONB_BUILD_OBJECT('hash', encode(script.hash, 'hex'))  || 
JSONB_BUILD_OBJECT('json', script.json) || 
JSONB_BUILD_OBJECT('code', encode(script.bytes, 'hex')) || 
JSONB_BUILD_OBJECT('serialised_size', script.serialised_size)
), '{}'::JSONB) as script
from collateral_tx_in as tx_in
inner join tx_out on tx_out.tx_id = tx_in.tx_out_id and tx_out.index = tx_in.tx_out_index
inner join tx as tt on tt.id = tx_out.tx_id
inner join tx on tx.id = tx_in.tx_in_id
left join script on script.id = tx_out.reference_script_id OR script.hash = tx_out.payment_cred
LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "tx_out"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
WHERE TX.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd','hex')
UNION
select -- output collateral utxos
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
from collateral_tx_out as utxo
inner join tx on tx.id = utxo.tx_id
left join datum on datum.hash = utxo.data_hash or datum.id = utxo.inline_datum_id
left join script on script.id = utxo.reference_script_id OR script.hash = utxo.payment_cred
LEFT JOIN "ma_tx_out" AS "mto" ON "mto"."tx_out_id" = "utxo"."id"
LEFT JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
-- WHERE TX.HASH = DECODE('3fca8f8be6efba69327388dac1d0b37a72f8803ada94f724aa8bbf17b7e38eee','hex')
WHERE TX.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd','hex');
