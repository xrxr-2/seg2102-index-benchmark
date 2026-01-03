print("=== SCRIPT STARTED ===")

import pandas as pd
import numpy as np
from sqlalchemy import create_engine

# -------------------------------------------------
# Database connection (UPDATE PASSWORD IF NEEDED)
# -------------------------------------------------
engine = create_engine(
    "postgresql://postgres:8225@localhost:5432/online_retail_asgm"
)



# -------------------------------------------------
# Load cleaned dataset
# -------------------------------------------------
query = "SELECT * FROM online_retail_clean"
df = pd.read_sql(query, engine)
print("Data loaded")


print("Rows loaded:", df.shape[0])
print("Unique StockCodes:", df['stockcode'].nunique())

# -------------------------------------------------
# Uniform distribution
# -------------------------------------------------
unique_codes = df['stockcode'].unique()

df_uniform = df.copy()
df_uniform['stockcode'] = np.random.choice(
    unique_codes,
    size=len(df_uniform),
    replace=True
)

print("Uniform distribution created")

# -------------------------------------------------
# Skewed distribution
# -------------------------------------------------
top_codes = df['stockcode'].value_counts().head(10).index.tolist()

weights = []
for code in unique_codes:
    if code in top_codes:
        weights.append(0.7 / len(top_codes))  # 70% weight
    else:
        weights.append(0.3 / (len(unique_codes) - len(top_codes)))

df_skewed = df.copy()
df_skewed['stockcode'] = np.random.choice(
    unique_codes,
    size=len(df_skewed),
    p=weights
)

print("Skewed distribution created")

# -------------------------------------------------
# Save datasets to PostgreSQL
# -------------------------------------------------
df_uniform.to_sql(
    "online_retail_uniform",
    engine,
    if_exists="replace",
    index=False
)

df_skewed.to_sql(
    "online_retail_skewed",
    engine,
    if_exists="replace",
    index=False
)

print("Tables online_retail_uniform and online_retail_skewed created")
