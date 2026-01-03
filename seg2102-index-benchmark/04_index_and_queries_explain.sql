-- =========================================================
-- 04_index_and_queries_explain.sql
-- Purpose:
--   Benchmark B-tree index behaviour under:
--   (1) uniform vs skewed distributions
--   (2) with index vs without index
--   Workload: point queries (hot/cold) + range query
-- Evidence: EXPLAIN (ANALYZE, BUFFERS)
-- =========================================================

-- =========================================================
-- A) INDEXED CONDITION
-- =========================================================

-- Ensure planner statistics are up-to-date (recommended)
ANALYZE online_retail_uniform;
ANALYZE online_retail_skewed;

-- Create B-tree indexes on StockCode
CREATE INDEX IF NOT EXISTS idx_uniform_stockcode
ON online_retail_uniform(stockcode);

CREATE INDEX IF NOT EXISTS idx_skewed_stockcode
ON online_retail_skewed(stockcode);

-- Verify index existence
SELECT tablename, indexname
FROM pg_indexes
WHERE indexname IN ('idx_uniform_stockcode', 'idx_skewed_stockcode');

-- ---------------------------------------------------------
-- [INDEXED] Uniform | Point | Hot key = '85123A'
-- Expected: Bitmap/Index-based access (depends on selectivity)
-- Output file suggestion: point_hot_uniform_indexed.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_uniform
WHERE stockcode = '85123A';

-- ---------------------------------------------------------
-- [INDEXED] Skewed | Point | Hot key = '85123A'
-- Output file suggestion: point_hot_skewed_indexed.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_skewed
WHERE stockcode = '85123A';

-- ---------------------------------------------------------
-- [INDEXED] Uniform | Point | Cold key = '23634'
-- Output file suggestion: point_cold_uniform_indexed.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_uniform
WHERE stockcode = '23634';

-- ---------------------------------------------------------
-- [INDEXED] Skewed | Point | Cold key = '23634'
-- Output file suggestion: point_cold_skewed_indexed.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_skewed
WHERE stockcode = '23634';

-- ---------------------------------------------------------
-- [INDEXED] Uniform | Range | stockcode BETWEEN '22000' AND '23000'
-- Output file suggestion: range_uniform_indexed.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_uniform
WHERE stockcode BETWEEN '22000' AND '23000';

-- ---------------------------------------------------------
-- [INDEXED] Skewed | Range | stockcode BETWEEN '22000' AND '23000'
-- Output file suggestion: range_skewed_indexed.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_skewed
WHERE stockcode BETWEEN '22000' AND '23000';


-- =========================================================
-- B) NO-INDEX BASELINE
-- =========================================================

-- Drop indexes to force sequential scan baseline
DROP INDEX IF EXISTS idx_uniform_stockcode;
DROP INDEX IF EXISTS idx_skewed_stockcode;

-- Re-ANALYZE after structural change (recommended)
ANALYZE online_retail_uniform;
ANALYZE online_retail_skewed;

-- Verify indexes are removed (should return 0 rows)
SELECT tablename, indexname
FROM pg_indexes
WHERE indexname IN ('idx_uniform_stockcode', 'idx_skewed_stockcode');

-- ---------------------------------------------------------
-- [NO INDEX] Uniform | Point | Hot key = '85123A'
-- Expected: Seq Scan baseline
-- Output file suggestion: point_hot_uniform_no_index.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_uniform
WHERE stockcode = '85123A';

-- ---------------------------------------------------------
-- [NO INDEX] Skewed | Point | Hot key = '85123A'
-- Output file suggestion: point_hot_skewed_no_index.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_skewed
WHERE stockcode = '85123A';

-- ---------------------------------------------------------
-- [NO INDEX] Uniform | Point | Cold key = '23634'
-- Output file suggestion: point_cold_uniform_no_index.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_uniform
WHERE stockcode = '23634';

-- ---------------------------------------------------------
-- [NO INDEX] Skewed | Point | Cold key = '23634'
-- Output file suggestion: point_cold_skewed_no_index.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_skewed
WHERE stockcode = '23634';

-- ---------------------------------------------------------
-- [NO INDEX] Uniform | Range | stockcode BETWEEN '22000' AND '23000'
-- Output file suggestion: range_uniform_no_index.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_uniform
WHERE stockcode BETWEEN '22000' AND '23000';

-- ---------------------------------------------------------
-- [NO INDEX] Skewed | Range | stockcode BETWEEN '22000' AND '23000'
-- Output file suggestion: range_skewed_no_index.txt
-- ---------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM online_retail_skewed
WHERE stockcode BETWEEN '22000' AND '23000';


-- =========================================================
-- C) RESTORE INDEXES (OPTIONAL)
-- =========================================================

-- Re-create indexes to restore environment (optional)
CREATE INDEX IF NOT EXISTS idx_uniform_stockcode
ON online_retail_uniform(stockcode);

CREATE INDEX IF NOT EXISTS idx_skewed_stockcode
ON online_retail_skewed(stockcode);

ANALYZE online_retail_uniform;
ANALYZE online_retail_skewed;

-- Final verification
SELECT tablename, indexname
FROM pg_indexes
WHERE indexname IN ('idx_uniform_stockcode', 'idx_skewed_stockcode');
