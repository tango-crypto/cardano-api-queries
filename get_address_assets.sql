SELECT SUM(MTO.QUANTITY) AS QUANTITY,
	MAX(ENCODE(ASSET.POLICY,'hex')) AS POLICY_ID,
	MAX(ENCODE(ASSET.NAME,'hex')) AS ASSET_NAME,
	ASSET.FINGERPRINT
FROM "ma_tx_out" AS "mto"
INNER JOIN
(
	SELECT "tx_out"."id",
		"tx_out"."tx_id",
		"tx_out"."index",
		"tx_out"."value"
	FROM "tx_out"
	LEFT JOIN "tx_in" ON "tx_out"."tx_id" = "tx_in"."tx_out_id" AND "tx_out"."index" = "tx_in"."tx_out_index"
	WHERE TX_IN.TX_IN_ID IS NULL AND TX_OUT.ADDRESS = 'addr_test1wrsexavz37208qda7mwwu4k7hcpg26cz0ce86f5e9kul3hqzlh22t'
) AS "t" ON "mto"."tx_out_id" = "t"."id"
INNER JOIN "multi_asset" AS "asset" ON "asset"."id" = "mto"."ident"
WHERE ASSET.POLICY IS NOT NULL AND ASSET.fingerprint < 'asset1y92pll80kekqe9kf0rczt79cm7j0tyzs5nd09j'
GROUP BY ASSET.FINGERPRINT
ORDER BY ASSET.FINGERPRINT DESC
LIMIT 50;
