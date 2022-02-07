-- 1. For the customer with the email address ‘fresh_frank@gmail.com’ show all product_skus the customer has an active subscription for.
SELECT
  p.product_sku AS product_sku
FROM
  customer c
JOIN
  subscription s
ON
  s.fk_customer = c.id_customer
JOIN
  product p
ON
  p.id_product = s.fk_product_subscribed_to
WHERE
  c.email = 'fresh_frank@gmail.com'
  AND
WHERE
  s.status = 'active';

  
--2. Get all the customers that have an active subscription to a product that corresponds to a product family with product_family_handle = ‘classic-box’.
SELECT
  c.first_name AS first_name,
  c.last_name AS last_name,
FROM
  customer c
JOIN
  subscription s
ON
  s.fk_customer = c.id_customer
JOIN
  product p
ON
  p.id_product = s.fk_product_subscribed_to
JOIN
  product_family pf
ON
  pf.id_product_family = p.fk_product_family
WHERE
  pf.product_family_handle = 'classic-box'
  AND
WHERE
  s.status = 'active';


--3. Get all the paused subscriptions that have only received one box.
SELECT
  s.id_subscription AS sub_id
FROM
  'order' o
JOIN
  subscription s
ON
  o.fk_subscription = s.id_subscription
WHERE
  s.status = 'paused'
GROUP BY
  s.id_subscription
HAVING
  COUNT(o.id_order) = 1;


--4. How many subscriptions do our customers have on average? Hint: first average at the customer level.
SELECT
  SUM(derived.count_s)/COUNT( DISTINCT derived.fk_customer) AS avg_sub
FROM (
  SELECT
    fk_customer,
    COUNT(id_subscription) AS count_s
  FROM
    subscription
  GROUP BY
    fk_customer ) derived;


--5. How many customers have ordered more than one product?
SELECT
  COUNT (DISTINCT derived.customers) AS customer_count
FROM (
  SELECT
    c.id_customer AS customers
  FROM
    customer c
  JOIN
    subscription s
  ON
    (c.id_customer=s.fk_customer)
  JOIN
    'order' o
  ON
    (s.id_subscription=o.fk_subscription)
  GROUP BY
    c.id_customer
  HAVING
    COUNT (DISTINCT o.fk_product) > 1 ) derived;


--6. How many customers have ordered more than one product with the same subscription?
SELECT
  COUNT (DISTINCT derived.customers) AS customer_count
FROM (
  SELECT
    c.id_customer AS customers
  FROM
    customer c
  JOIN
    subscription s
  ON
    c.id_customer = s.fk_customer
  JOIN
    'order' o
  ON
    s.id_subscription = o.fk_subscription
  GROUP BY
    c.id_customer,
    o.fk_subscription
  HAVING
    COUNT (DISTINCT o.fk_product) > 1 ) derived;


--7. Get a list of all customers which got a box delivered to them within the previous two weeks and the count of boxes that had been delivered to them within that date range.
SELECT
  c.id_customer AS customer_id,
  c.first_name AS first_name,
  c.last_name AS last_name,
  COUNT(o.id_order) AS count_of_boxes
FROM
  customer c
JOIN
  Subscription s
ON
  c.id_customer = s.fk_customer
JOIN
  'order' o
ON
  o.fk_subscription = s.id_subscription
WHERE
  o.delivery_date >= DATEADD(day,
    -14,
    GETDATE())
GROUP BY
  c.id_customer;