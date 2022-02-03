SELECT "block"."id",
	ENCODE(BLOCK.HASH,'hex') AS HASH,
	"block"."epoch_no",
	"block"."slot_no",
	"block"."epoch_slot_no",
	"block"."block_no",
	"prev_block"."block_no" AS "previous_block",
	"pool_hash"."view" AS "slot_leader",
	"block"."size",
	"block"."time",
	"block"."tx_count",
	"tx"."out_sum",
	"tx"."fees",
	ENCODE(BLOCK.OP_CERT,'hex') AS OP_CERT,
	"block"."vrf_key"
FROM "block"
LEFT JOIN "slot_leader" ON "slot_leader"."id" = "block"."slot_leader_id"
LEFT JOIN "pool_hash" ON "pool_hash"."id" = "slot_leader"."pool_hash_id"
LEFT JOIN "block" AS "prev_block" ON "prev_block"."id" = "block"."previous_id"
INNER JOIN
(SELECT "block"."block_no",
		SUM(TX.OUT_SUM) AS OUT_SUM,
		SUM(TX.FEE) AS FEES
	FROM "block"
	LEFT JOIN "tx" ON "tx"."block_id" = "block"."id"
	WHERE BLOCK.BLOCK_NO IS NOT NULL
	GROUP BY "block"."block_no"
	ORDER BY "block"."block_no" DESC
	LIMIT 1
) AS "tx" ON "tx"."block_no" = "block"."block_no";
