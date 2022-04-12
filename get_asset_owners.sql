WITH "owners" AS
(
	SELECT 
		"tx_out"."address",
		SUM(MTO.QUANTITY) OVER(PARTITION BY TX_OUT.ADDRESS) AS QUANTITY,
		SUM(MTO.QUANTITY) OVER() AS TOTAL
	FROM "ma_tx_out" AS "mto"
	INNER JOIN "multi_asset" AS "ma" ON "ma"."id" = "mto"."ident"
	INNER JOIN "tx_out" ON "tx_out"."id" = "mto"."tx_out_id"
	LEFT JOIN "tx_in" ON "tx_in"."tx_out_id" = "tx_out"."tx_id"
	AND "tx_out"."index" = "tx_in"."tx_out_index"
	WHERE MA.FINGERPRINT = 'asset1ee0u29k4xwauf0r7w8g30klgraxw0y4rz2t7xs' AND TX_IN.TX_IN_ID IS NULL
)
SELECT "owners"."address",
	"owners"."quantity",
	OWNERS.QUANTITY / MAX(OWNERS.TOTAL) * 100 AS SHARE
FROM "owners"
WHERE (OWNERS.ADDRESS < 'addr_test1qrg55k6kvxq2kd5h4ejknyhxcgcdemdnc282kcxgs0zp34w7dlk205ytzpkn6yqxgd36m2z6jzajtdaxnp486vsktfzqjxdd32'AND OWNERS.QUANTITY = 1783553)
	OR OWNERS.QUANTITY < 1783553
GROUP BY OWNERS.ADDRESS,
	OWNERS.QUANTITY
ORDER BY OWNERS.QUANTITY DESC,
	OWNERS.ADDRESS DESC
LIMIT 20;
