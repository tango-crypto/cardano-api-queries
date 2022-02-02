SELECT 
"pool_hash"."view" AS "pool_id",
ENCODE(POOL_HASH.HASH_RAW,'hex') AS RAW_ID,
"pmr"."url",
ENCODE(pmr.HASH,'hex') AS HASH,
POD.JSON AS DATA,
pmr.registered_tx_id
FROM "pool_hash"
LEFT JOIN "pool_metadata_ref" AS "pmr" ON "pmr"."pool_id" = "pool_hash"."id"
LEFT JOIN "pool_offline_data" AS "pod" ON "pod"."pmr_id" = "pmr"."id"
WHERE "pool_hash"."view" = 'pool1cr8vpy3ta3smcxjq8hfu8n2chxhtc78ukfruqjhfgarf5azypen'
ORDER by pmr.registered_tx_id DESC;

SELECT 
"pool_hash"."view" AS "pool_id",
ENCODE(POOL_HASH.HASH_RAW,'hex') AS id,
pu.pledge,
pu.margin,
pu.fixed_cost,
pu.active_epoch_no,
"pmr"."url",
ENCODE(pmr.HASH,'hex') AS HASH,
POD.JSON AS DATA
FROM "pool_update" as pu
INNER JOIN pool_hash on pool_hash.id = pu.hash_id
LEFT JOIN "pool_metadata_ref" AS "pmr" ON "pmr"."id" = "pu"."meta_id"
LEFT JOIN "pool_offline_data" AS "pod" ON "pod"."pmr_id" = "pmr"."id"
WHERE "pool_hash"."view" = 'pool1cr8vpy3ta3smcxjq8hfu8n2chxhtc78ukfruqjhfgarf5azypen'
AND EXISTS (
	SELECT 1 FROM epoch where epoch.no = pu.active_epoch_no 
)
ORDER by pu.registered_tx_id DESC
LIMIT 1;
