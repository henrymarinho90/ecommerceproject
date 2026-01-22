import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()

ROOT = Path(__file__).resolve().parents[2]
SQL_DIR = ROOT / "analysis" / "sql"
OUT_DIR = ROOT / "analysis" / "outputs"
OUT_DIR.mkdir(parents=True, exist_ok=True)

engine = create_engine(os.environ["DATABASE_URL"])

def run_query(sql_path: Path) -> pd.DataFrame:
    sql = sql_path.read_text(encoding="utf-8")
    return pd.read_sql_query(sql, engine)

queries = {
    "top_categories": SQL_DIR / "top_categories.sql",
    "fulfillment": SQL_DIR / "fulfillment.sql",
    "traffic_source_revenue": SQL_DIR / "traffic_source_revenue.sql",
}

for name, path in queries.items():
    df = run_query(path)
    csv_path = OUT_DIR / f"{name}.csv"
    df.to_csv(csv_path, index=False)
    print(f"✅ wrote {csv_path} ({len(df)} rows)")
