# Retail CO Analytics

A three-page Power BI retail analytics report that turns four years of constructed training data into sales, product, profitability, and customer insights.

## Report pages

### Overview

![Retail CO overview](Retail_Co_PowerBI_Capstone_Dataset_v3/Retail_Co_PowerBI_Capstone_Dataset_v3/Screenshot%202026-09-05%20194437.png)

### Products

![Product performance](Retail_Co_PowerBI_Capstone_Dataset_v3/Retail_Co_PowerBI_Capstone_Dataset_v3/Screenshot%202026-09-05%20194519.png)

### Customers

![Customer analytics](Retail_Co_PowerBI_Capstone_Dataset_v3/Retail_Co_PowerBI_Capstone_Dataset_v3/Screenshot%202026-09-05%20194534.png)

## Key results

| Metric | Value |
| --- | ---: |
| Total sales | SAR 38.20M |
| Total profit | SAR 8.76M |
| Profit margin | 22.9% |
| Total quantity | 56.59K |

## Features

- Overview, Products, and Customers report pages.
- Date, year, region, category, and segment filters.
- Current-year versus prior-year comparisons.
- Branch and category performance analysis.
- Top products and loss-making product analysis.
- Customer acquisition, segmentation, and profitability analysis.
- Dedicated validation checks for transformation accuracy.

## Data preparation

- Appends annual sales files from 2023 through 2026.
- Removes exact duplicate sales rows.
- Excludes cancelled orders from business sales.
- Deduplicates customer records.
- Converts product cost from SAR text to numeric values.
- Splits combined region and city fields.
- Uses a DAX calendar for date analysis.

## Files

The project assets are stored in [Retail_Co_PowerBI_Capstone_Dataset_v3](Retail_Co_PowerBI_Capstone_Dataset_v3/Retail_Co_PowerBI_Capstone_Dataset_v3/), including the final PBIX report, working copy, CSV datasets, validation checks, icons, screenshots, and demo video.

> The dataset is intentionally constructed for training and validation. It does not contain real customer information.
