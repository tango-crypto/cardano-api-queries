SELECT "epoch_no",
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
	ENCODE(ENTROPY,'hex') AS ENTROPY,
	"protocol_major",
	"protocol_minor",
	"min_utxo_value" AS "min_utxo",
	"min_pool_cost",
	ENCODE(NONCE,'hex') AS NONCE,
	"block_id"
FROM "epoch_param"
WHERE "epoch_param"."epoch_no" = 179
LIMIT 1;
