-- Get epoch parameters
SELECT 
        "epoch_no",
	"min_fee_a",
	"min_fee_b",
	"max_block_size",
	"max_tx_size",
	"max_bh_size" AS "max_block_header_size",
	"key_deposit",
	"pool_deposit",
	"max_epoch",
	"optimal_pool_count",
	"influence" AS "influence_a0",
	"monetary_expand_rate" AS "monetary_expand_rate_rho",
	"treasury_growth_rate" AS "treasury_growth_rate_tau",
	"decentralisation",
	"extra_entropy",
	"protocol_major",
	"protocol_minor",
	"min_utxo_value" AS "min_utxo",
	"min_pool_cost",
	ENCODE(NONCE,'hex') AS NONCE,
	"coins_per_utxo_size",
	"price_mem",
	"price_step",
	"max_tx_ex_mem",
	"max_tx_ex_steps",
	"max_block_ex_mem",
	"max_block_ex_steps",
	"max_val_size",
	"collateral_percent",
	"max_collateral_inputs",
	epoch.block_id,
	NULLIF(JSONB_STRIP_NULLS(
		JSONB_BUILD_OBJECT('hash', encode(cost_model.hash, 'hex')) ||
		JSONB_BUILD_OBJECT('costs', cost_model.costs) ||
		JSONB_BUILD_OBJECT('block_id', cost_model.block_id)
	), '{}'::JSONB) as cost_model
FROM "epoch_param" as epoch
left join cost_model on cost_model.id = cost_model_id
WHERE epoch.epoch_no = 154
LIMIT 1;
