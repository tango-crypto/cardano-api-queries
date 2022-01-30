create index idx_pool_hash_view on pool_hash(view);

SELECT "pool_hash"."view" AS "pool_id",
	ENCODE(POOL_HASH.HASH_RAW,

		'hex') AS RAW_ID,
	"pmd"."url",
	ENCODE(PMD.HASH,

		'hex') AS HASH,
	POD.JSON AS DATA
FROM "pool_hash"
LEFT JOIN "pool_metadata_ref" AS "pmd" ON "pmd"."pool_id" = "pool_hash"."id"
LEFT JOIN "pool_offline_data" AS "pod" ON "pod"."pool_id" = "pool_hash"."id"
WHERE "pool_hash"."view" = 'pool1cr8vpy3ta3smcxjq8hfu8n2chxhtc78ukfruqjhfgarf5azypen';
