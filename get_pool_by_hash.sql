SELECT "pool_hash"."view" AS "pool_id",
	ENCODE(POOL_HASH.HASH_RAW,'hex') AS ID,
	"pu"."pledge",
	"pu"."margin",
	"pu"."fixed_cost",
	"pu"."active_epoch_no",
	first_value ("pmr"."url") over(ORDER BY CASE WHEN pmr.url is null then 0 else "pu"."registered_tx_id" end DESC) as url,
	first_value (encode(PMR.HASH,'hex')) over(ORDER BY CASE WHEN pmr.hash is null then 0 else "pu"."registered_tx_id" end DESC) AS HASH,
	first_value (POD.JSON) over(ORDER BY CASE WHEN pod.json is null then 0 else "pu"."registered_tx_id" end DESC) AS DATA
FROM "pool_update" AS "pu"
INNER JOIN "pool_hash" ON "pool_hash"."id" = "pu"."hash_id"
INNER JOIN "epoch" ON "epoch"."no" = "pu"."active_epoch_no"
LEFT JOIN "pool_metadata_ref" AS "pmr" ON "pmr"."id" = "pu"."meta_id"
LEFT JOIN "pool_offline_data" AS "pod" ON "pod"."pmr_id" = "pmr"."id"
WHERE "pool_hash"."hash_raw" = DECODE('cd02899daeb4c77e88cea88b3a904205ffa2f4abd5ec18d030d7d56e','hex')
ORDER BY CASE WHEN epoch.no is null then 0 else "pu"."registered_tx_id" end DESC, "pu"."active_epoch_no" DESC
LIMIT 1
