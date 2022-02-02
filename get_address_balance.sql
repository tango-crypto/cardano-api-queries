SELECT SUM(VALUE) AS BALANCE
FROM "tx_out"
WHERE NOT EXISTS
(
	SELECT 1
	FROM "tx_in"
	WHERE TX_OUT.TX_ID = TX_IN.TX_OUT_ID AND TX_OUT.INDEX = TX_IN.TX_OUT_INDEX
)
AND "tx_out"."address" = 'addr_test1wrsexavz37208qda7mwwu4k7hcpg26cz0ce86f5e9kul3hqzlh22t'
