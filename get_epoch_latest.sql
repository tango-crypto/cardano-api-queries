SELECT
epoch.id,
epoch.out_sum,
epoch.fees,
epoch.tx_count,
epoch.blk_count,
epoch.no,
epoch.start_time,
epoch.end_time
FROM epoch
ORDER BY epoch.no DESC
LIMIT 1;
