select -- minting scripts
distinct on (script.id) 
script.type,
encode(script.hash, 'hex') as hash,
script.json,
encode(script.bytes, 'hex') as code,
script.serialised_size,
NULLIF('{}', '{}'::JSONB) as datum,
NULLIF(JSONB_STRIP_NULLS(
		JSONB_BUILD_OBJECT('unit_mem', redeemer.unit_mem) ||
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
	), '{}'::JSONB) as redeemer
from script
inner join "multi_asset" AS "asset" on asset.policy = script.hash
inner join "ma_tx_mint" AS "mtm" on mtm.ident = asset.id
inner join tx on tx.id = mtm.tx_id
left join redeemer on redeemer.tx_id = tx.id and redeemer.script_hash = script.hash
left join redeemer_data rd on rd.id = redeemer.redeemer_data_id
-- WHERE TX.HASH = DECODE('d12b29b689ed6711fa27a3ab138f14540f3af1c8d29f6ca8bf016ca1fc6f87b7','hex')
WHERE TX.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd','hex')
UNION ALL
select -- cert|reward|spend scripts (created in this tx)
distinct on (script.id) 
script.type,
encode(script.hash, 'hex') as hash,
script.json,
encode(script.bytes, 'hex') as code,
script.serialised_size,
NULLIF('{}', '{}'::JSONB) as datum,
NULLIF(JSONB_STRIP_NULLS(
		JSONB_BUILD_OBJECT('unit_mem', redeemer.unit_mem) ||
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
	), '{}'::JSONB) as redeemer
from script
inner join tx on tx.id = script.tx_id
left join redeemer on redeemer.tx_id = tx.id and redeemer.script_hash = script.hash
left join redeemer_data rd on rd.id = redeemer.redeemer_data_id
WHERE TX.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd','hex')
-- WHERE TX.HASH = DECODE('0e93e575c6c264f93f3cbcf09d7458024e795263c9bfbad3a607fb948549a847','hex')
UNION ALL
select -- inputs cert|reward|spend scripts (created in previous tx)
script.type,
encode(script.hash, 'hex') as hash,
script.json,
encode(script.bytes, 'hex') as code,
script.serialised_size,
NULLIF(JSONB_STRIP_NULLS(
		JSONB_BUILD_OBJECT('hash', encode(datum.hash, 'hex')) ||
		JSONB_BUILD_OBJECT('value', datum.value) ||
		JSONB_BUILD_OBJECT('value_raw', encode(datum.bytes, 'hex'))
	), '{}'::JSONB) as datum,
NULLIF(JSONB_STRIP_NULLS(
		JSONB_BUILD_OBJECT('unit_mem', redeemer.unit_mem) ||
		JSONB_BUILD_OBJECT('unit_steps', redeemer.unit_steps) ||
		JSONB_BUILD_OBJECT('index', redeemer.index) ||
		JSONB_BUILD_OBJECT('fee', redeemer.fee) ||
		JSONB_BUILD_OBJECT('purpose', redeemer.purpose) ||
		JSONB_BUILD_OBJECT('script_hash', encode(redeemer.script_hash, 'hex')) ||	
		JSONB_BUILD_OBJECT('data',						   
			NULLIF(JSONB_STRIP_NULLS(
				JSONB_BUILD_OBJECT('hash', encode(rd.hash, 'hex')) ||
				JSONB_BUILD_OBJECT('value', rd.value) ||
				JSONB_BUILD_OBJECT('value_raw', encode(rd.bytes, 'hex'))
			), '{}'::JSONB))
	), '{}'::JSONB) as redeemer
from script
inner join tx_out on tx_out.reference_script_id = script.id OR tx_out.payment_cred = script.hash
inner join "tx_in" ON "tx_in"."tx_out_id" = "tx_out"."tx_id" AND "tx_in"."tx_out_index" = "tx_out"."index"
inner join "tx" ON "tx"."id" = "tx_in"."tx_in_id"
left join datum on datum.hash = tx_out.data_hash or datum.id = tx_out.inline_datum_id
left join redeemer on redeemer.id = tx_in.redeemer_id and redeemer.script_hash = script.hash
left join redeemer_data rd on rd.id = redeemer.redeemer_data_id
-- WHERE TX.HASH = DECODE('d12b29b689ed6711fa27a3ab138f14540f3af1c8d29f6ca8bf016ca1fc6f87b7','hex')
WHERE tx.HASH = DECODE('122128d2f72f77ab6bf8fb3f95b13f820b7c08a7ba2cab9c1d4ae5422f97d3fd','hex');
