CREATE TEMPORARY TABLE order_item_history

	SELECT 
			o.*,
            oi.order_item_id,
            oi.product_id,
            oi.is_primary_item
	FROM orders o
	LEFT JOIN order_items oi
	ON o.order_id = oi.order_id
	WHERE DATE(o.created_at) < '2014-10-15';
    
CREATE TEMPORARY TABLE orders_with_refund_info
    
    SELECT 
			oih.order_id,
            oih.created_at,
            oih.primary_product_id,
            oih.items_purchased,
            oih.price_usd,
            oih.order_item_id,
            oih.product_id,
            oih.is_primary_item,
            oir.order_item_refund_id,
            oir.refund_amount_usd
	FROM order_item_history oih
    LEFT JOIN order_item_refunds oir
    ON oih.order_item_id = oir.order_item_id;
    
    SELECT 
		YEAR(created_at) AS year,
        MONTH(created_at) AS month,
        COUNT(CASE WHEN product_id = 1 THEN product_id ELSE NULL END ) AS p1_orders,
        COUNT(CASE WHEN  product_id = 1 AND order_item_refund_id IS NOT NULL THEN order_item_refund_id ELSE NULL END) AS p1_refunds,
		COUNT(CASE WHEN  product_id = 1 AND order_item_refund_id IS NOT NULL THEN order_item_refund_id ELSE NULL END) /
        COUNT(CASE WHEN product_id = 1 THEN product_id ELSE NULL END )  AS p1_refund_rt,
        COUNT(CASE WHEN product_id = 2 THEN product_id ELSE NULL END ) AS p2_orders,
		COUNT(CASE WHEN  product_id = 2 AND order_item_refund_id IS NOT NULL THEN order_item_refund_id ELSE NULL END) /
        COUNT(CASE WHEN product_id = 2 THEN product_id ELSE NULL END )  AS p2_refund_rt,
        COUNT(CASE WHEN product_id = 3 THEN product_id ELSE NULL END ) AS p3_orders,
		COUNT(CASE WHEN  product_id = 3 AND order_item_refund_id IS NOT NULL THEN order_item_refund_id ELSE NULL END) /
        COUNT(CASE WHEN product_id = 3 THEN product_id ELSE NULL END )  AS p3_refund_rt,
        COUNT(CASE WHEN product_id = 4 THEN product_id ELSE NULL END ) AS p4_orders,
		COUNT(CASE WHEN  product_id = 4 AND order_item_refund_id IS NOT NULL THEN order_item_refund_id ELSE NULL END) /
        COUNT(CASE WHEN product_id = 4 THEN product_id ELSE NULL END )  AS p4_refund_rt
        FROM orders_with_refund_info
        GROUP BY YEAR(created_at), MONTH(created_at)
        
        
    

    