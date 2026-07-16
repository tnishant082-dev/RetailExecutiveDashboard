"""Summarize cleaned Online Retail II KPIs (reads full workbook — a bit slow)."""
from pathlib import Path
import pandas as pd

data = Path(__file__).resolve().parents[1] / "data"
r1 = pd.read_excel(data / "online_retail_II.xlsx", sheet_name="Year 2009-2010")
r2 = pd.read_excel(data / "online_retail_II.xlsx", sheet_name="Year 2010-2011")
df = pd.concat([r1, r2], ignore_index=True).drop_duplicates()
df["Invoice"] = df["Invoice"].astype(str)
fee = ["POST", "DOT", "M", "D", "AMAZONFEE", "BANK CHARGES", "CRUK"]
rev = df[
    (~df["Invoice"].str.startswith("C"))
    & (df["Quantity"] > 0)
    & (df["Price"] > 0)
    & (df["Description"].notna())
    & (~df["StockCode"].astype(str).isin(fee))
].copy()
rev["LineAmount"] = rev["Quantity"] * rev["Price"]
print("revenue", round(rev["LineAmount"].sum(), 2))
print("orders", rev["Invoice"].nunique())
print("customers", rev["Customer ID"].nunique(dropna=True))
print("aov", round(rev["LineAmount"].sum() / rev["Invoice"].nunique(), 2))
