SELECT 
		o.primary_product_id,
		-- oi.product_id AS cross_sell_product_id,
		COUNT(DISTINCT o.order_id) AS orders,
        COUNT(CASE WHEN oi.product_id = 1 THEN oi.product_id ELSE NULL END) AS xsell_prod1,
        COUNT(CASE WHEN oi.product_id = 2 THEN oi.product_id ELSE NULL END) AS xsell_prod2,
        COUNT(CASE WHEN oi.product_id = 3 THEN oi.product_id ELSE NULL END) AS xsell_prod3,
		COUNT(CASE WHEN oi.product_id = 1 THEN oi.product_id ELSE NULL END) / COUNT(DISTINCT o.order_id) AS xsell_rate_prod1,
        COUNT(CASE WHEN oi.product_id = 2 THEN oi.product_id ELSE NULL END) / COUNT(DISTINCT o.order_id) AS xsell_rate_prod2,
        COUNT(CASE WHEN oi.product_id = 3 THEN oi.product_id ELSE NULL END) / COUNT(DISTINCT o.order_id) AS xsell_rate_prod3
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_id AND oi.is_primary_item=0
WHERE o.order_id BETWEEN 10000 AND 11000 
GROUP BY o.primary_product_id  -- , oi.product_id


