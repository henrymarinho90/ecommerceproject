# C:\dev\ecommerceproject\analysis\src\extract_returns_profitability.py

from pathlib import Path
import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()

ROOT = Path(__file__).resolve()
# Go up to repo root: analysis/src -> analysis -> repo root
ROOT = ROOT.parents[2]

SQL_FILE = ROOT / "sql" / "returns_profitability" / "10_returns_profitability.sql"
OUT_DIR = ROOT / "analysis" / "outputs"
OUT_DIR.mkdir(parents=True, exist_ok=True)

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("DATABASE_URL not found. Add it to C:\\dev\\ecommerceproject\\.env")

engine = create_engine(DATABASE_URL)

def split_sql_blocks(sql_text: str):
    """
    Splits by semicolon into statements, removing blanks and comments-only chunks.
    """
    chunks = []
    current = []
    for line in sql_text.splitlines():
        current.append(line)
        if line.strip().endswith(";"):
            chunk = "\n".join(current).strip()
            current = []
            if chunk:
                chunks.append(chunk)
    # leftover (if any)
    leftover = "\n".join(current).strip()
    if leftover:
        chunks.append(leftover)
    return chunks

sql = SQL_FILE.read_text(encoding="utf-8")
statements = split_sql_blocks(sql)

# We know the file outputs 6 result sets in this order:
# 1) returns_kpis
# 2) returns_monthly
# 3) returns_by_category
# 4) returns_by_brand
# 5) returns_by_traffic_source
# 6) fulfillment_vs_returns
output_names = [
    "returns_kpis.csv",
    "returns_monthly.csv",
    "returns_by_category.csv",
    "returns_by_brand.csv",
    "returns_by_traffic_source.csv",
    "fulfillment_vs_returns.csv",
]

if len(statements) < len(output_names):
    raise ValueError(f"Expected at least {len(output_names)} SELECT statements, found {len(statements)}")

with engine.connect() as conn:
    for i, out_name in enumerate(output_names):
        stmt = statements[i]
        df = pd.read_sql_query(text(stmt), conn)
        out_path = OUT_DIR / out_name
        df.to_csv(out_path, index=False)
        print(f"Wrote {out_path}  shape={df.shape}")
