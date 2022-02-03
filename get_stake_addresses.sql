select 
DISTINCT (tx_out.address) as address
FROM "tx_out"
INNER JOIN "stake_address" AS "sa" ON "tx_out"."stake_address_id" = "sa"."id"
WHERE "sa"."view" = 'stake_test1urtt0tpxwxyll6gclxnz5srjx3zjr099pgrqkd3st7339tcr0u0ph'
AND tx_out.address < 'addr_test1qrfukqypvy4efts3jy4x0xvcrz406g3z00f8w570kmky2vkkk7kzvuvfll5337dx9fq8ydz9yx722zsxpvmrqharz2hscvtazf'
order by tx_out.address DESC
limit 50
