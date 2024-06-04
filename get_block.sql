-- Get block
SELECT "block"."id",
	ENCODE(BLOCK.HASH,'hex') AS HASH,
	"block"."epoch_no",
	"block"."slot_no",
	"block"."epoch_slot_no",
	"block"."block_no",
	"prev_block"."block_no" AS "previous_block",
	"next_block"."block_no" AS "next_block",
	"pool_hash"."view" AS "slot_leader",
	"block"."size",
	"block"."time",
	"block"."tx_count",
	"tx"."out_sum",
	"tx"."fees",
	(SELECT BLOCK_NO
		FROM BLOCK
		WHERE BLOCK_NO IS NOT NULL
		ORDER BY BLOCK_NO DESC
		LIMIT 1) - BLOCK.BLOCK_NO + 1 AS CONFIRMATIONS,
	ENCODE(BLOCK.OP_CERT,'hex') AS OP_CERT,
	"block"."vrf_key"
FROM "block"
LEFT JOIN "slot_leader" ON "slot_leader"."id" = "block"."slot_leader_id"
LEFT JOIN "pool_hash" ON "pool_hash"."id" = "slot_leader"."pool_hash_id"
LEFT JOIN "block" AS "prev_block" ON "prev_block"."id" = "block"."previous_id"
LEFT JOIN "block" AS "next_block" ON "next_block"."previous_id" = "block"."id"
INNER JOIN
(SELECT "block"."id" AS "block_id",
		SUM(TX.OUT_SUM) AS OUT_SUM,
		SUM(TX.FEE) AS FEES
	FROM "block"
	LEFT JOIN "tx" ON "tx"."block_id" = "block"."id"
	WHERE BLOCK.HASH = DECODE('1b1d604a7fa80f788e0ed6d39ec371d671bac417d781f1efcaa031e0e8b5f3b7','hex')
	GROUP BY "block"."id"
) AS "tx" ON "tx"."block_id" = "block"."id";
