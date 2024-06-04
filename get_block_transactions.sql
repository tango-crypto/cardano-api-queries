-- Get transactions in a block
SELECT "tx"."id",
	encode(tx.hash,'hex') as hash,
	"tx"."block_id",
	"tx"."block_index",
	"tx"."out_sum",
	"tx"."fee",
	"tx"."deposit",
	"tx"."size",
	"tx"."invalid_before",
	"tx"."invalid_hereafter",
	"tx"."valid_contract",
	"tx"."script_size"
FROM "tx"
INNER JOIN "block" ON "tx"."block_id" = "block"."id"
WHERE BLOCK.BLOCK_NO = 3174184 and tx.id < 260018
ORDER BY "tx"."id" DESC
LIMIT 50
