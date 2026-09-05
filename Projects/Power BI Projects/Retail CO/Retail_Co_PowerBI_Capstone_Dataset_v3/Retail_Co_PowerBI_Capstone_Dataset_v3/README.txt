Retail Co — Power BI Capstone Dataset v3

Use this version for the capstone.

Required transformations:
1. Append the four Sales CSV files.
2. Remove exact duplicate Sales rows.
3. Exclude Cancelled orders from business sales.
4. Remove duplicate CustomerID records in Customers.
5. Convert Products Cost from text containing SAR to numeric.
6. Split Branches Region/City column.
7. Create Calendar in Power BI with DAX.

Validation checkpoints:
- Raw Amount: SAR 41,800,000
- After removing exact duplicate Sales rows: SAR 40,200,000
- After excluding Cancelled orders: SAR 38,200,000

The Sales duplicate trap consists of exact duplicate copies of:
- ORD012383, Amount SAR 29.52 (17 extra copies)
- ORD001692, Amount SAR 2,029.82 (788 extra copies)
Together the extra duplicate amount is SAR 1,600,000.

Note: The data is intentionally constructed for training and validation of the capstone workflow.
