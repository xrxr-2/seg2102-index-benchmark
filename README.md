# SEG2102 Final Assessment – PostgreSQL B-tree Index Benchmark

## Objective
Evaluate how data distribution (uniform vs. skewed) affects B-tree index behaviour and query performance in PostgreSQL using Online Retail transactions and EXPLAIN (ANALYZE, BUFFERS).

## Tools
- PostgreSQL, pgAdmin 4
- Python 3 (pandas, sqlalchemy, psycopg2-binary)

## Reproducibility Steps
1. Import Online Retail CSV into PostgreSQL (pgAdmin import/COPY) and run `sql/01_schema_and_load.sql`.
2. Run `sql/02_cleaning_and_profiling.sql` to create `online_retail_clean`.
3. Run `python/02_generate_distributions.py` to generate `online_retail_uniform` and `online_retail_skewed`.
4. Run `sql/03_frequency_hot_cold_selection.sql` to confirm StockCode frequency (hot/cold selection).
5. Run `sql/04_index_and_queries_explain.sql` to execute the indexed vs no-index workload.
6. Compare outputs in `results/`.

## Outputs
EXPLAIN outputs for point (hot/cold) and range queries across:
- uniform vs skewed
- indexed vs no-index
