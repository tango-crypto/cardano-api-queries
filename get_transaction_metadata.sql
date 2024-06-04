-- get transaction metadata
SELECT 
"tx_metadata"."key" AS "label",
"tx_metadata"."json"
FROM "tx_metadata"
INNER JOIN "tx" ON "tx"."id" = "tx_metadata"."tx_id"
WHERE TX.HASH = DECODE('1c8997f9f0debde5b15fe29f0f18839a64e51c19ccdbe89e2811930d777c9b68','hex') AND tx_metadata.key < 4
ORDER BY tx_metadata.key DESC
LIMIT 50;
