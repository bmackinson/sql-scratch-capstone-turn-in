-- 1.  What columns are in the survey table?

SELECT *
FROM survey
LIMIT 10;
	
-- 2.  What is the number of responses for each question?

SELECT question, COUNT(DISTINCT user_id) as 'completed_resp'
FROM survey
WHERE response IS NOT NULL
GROUP BY question;

-- 3.  Use spreadsheet program to calculate the percentage of users who answer each question.

-- 4. Examine the first 5 rows of each Home Try-On table. What are the column names?

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

-- 5.  Create a new table containing user_id, is_home_try_on, number_of_pairs, and is_purchase.

SELECT DISTINCT q.user_id,
	hto.user_id IS NOT NULL AS 'is_home_try_on',
  hto.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
	ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
	ON q.user_id = p.user_id
LIMIT 10;

-- 6a.  Calculate the difference between customers who received 3 pairs of glasses vs. customers who received 5 pairs of glasses.

WITH wpfunnel AS (
SELECT DISTINCT q.user_id,
	hto.user_id IS NOT NULL AS 'is_home_try_on',
	hto.number_of_pairs,
	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
	ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
	ON q.user_id = p.user_id)
SELECT
	number_of_pairs,
  COUNT (*) AS 'num_quiz',
  SUM (is_home_try_on) AS 'num_hto',
  SUM (is_purchase) AS 'num_purch',
  ROUND ((1.0 * SUM (is_home_try_on) / COUNT (user_id)),2) AS '% from q to hto',
  ROUND ((1.0 * SUM (is_purchase) / SUM (is_home_try_on)),2) AS '% from hto to p'
FROM wpfunnel
GROUP BY 1
ORDER BY 1;

-- 6b.  Calculate overall conversion rates - quiz --> home try-on, and home try-on --> purchase.

WITH wpfunnel AS (
SELECT DISTINCT q.user_id,
	hto.user_id IS NOT NULL AS 'is_home_try_on',
	hto.number_of_pairs,
	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
	ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
	ON q.user_id = p.user_id)
SELECT
  COUNT (*) AS 'num_quiz',
  SUM (is_home_try_on) AS 'num_hto',
  SUM (is_purchase) AS 'num_purch',
  ROUND ((1.0 * SUM (is_home_try_on) / COUNT (user_id)),2) AS '% from q to hto',
  ROUND ((1.0 * SUM (is_purchase) / SUM (is_home_try_on)),2) AS '% from hto to p'
FROM wpfunnel;

-- 6C.  Calculate conversion rates by style.

WITH style_funnel AS (
SELECT DISTINCT q.user_id,
	q.style,
  hto.user_id IS NOT NULL AS 'is_home_try_on',
	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
	ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
	ON q.user_id = p.user_id)
SELECT
  style,
  COUNT (*) AS 'num_quiz',
  SUM (is_home_try_on) AS 'num_hto',
  SUM (is_purchase) AS 'num_purch',
  ROUND ((1.0 * SUM (is_home_try_on) / COUNT (user_id)),2) AS '% from q to hto',
  ROUND ((1.0 * SUM (is_purchase) / SUM (is_home_try_on)),2) AS '% from hto to p'
FROM style_funnel
GROUP BY 1
ORDER BY 6 DESC;
	
-- 6d.  Calculate conversion rates by color.

WITH color_funnel AS (
SELECT DISTINCT q.user_id,
	q.color,
  hto.user_id IS NOT NULL AS 'is_home_try_on',
	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
	ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
	ON q.user_id = p.user_id)
SELECT
  color,
  COUNT (*) AS 'num_quiz',
  SUM (is_home_try_on) AS 'num_hto',
  SUM (is_purchase) AS 'num_purch',
  ROUND ((1.0 * SUM (is_home_try_on) / COUNT (user_id)),2) AS '% from q to hto',
  ROUND ((1.0 * SUM (is_purchase) / SUM (is_home_try_on)),2) AS '% from hto to p'
FROM color_funnel
GROUP BY 1
ORDER BY 6 DESC;
	
	

