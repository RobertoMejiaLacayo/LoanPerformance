# LendingClub Loan Performance Analytics

**When Higher Interest Rates Mean Lower Returns: Analyzing $13.5B in Peer-to-Peer Loans**

[![Looker Studio Dashboard](https://img.shields.io/badge/Dashboard-Looker%20Studio-blue)](https://lookerstudio.google.com/reporting/bcdfcab2-e361-4036-accf-7b290b1453da)
[![SQL](https://img.shields.io/badge/SQL-BigQuery-orange)](https://cloud.google.com/bigquery)
[![Python](https://img.shields.io/badge/Python-3.9+-green)](https://www.python.org/)

---

## 📊 Project Overview

This project analyzes 1.3 million peer-to-peer loans totaling $13.5 billion issued by LendingClub from 2007-2018 to answer a critical risk management question:

> **"At what point does credit risk become uninsurable? At what point is no interest rate high enough to compensate for the likelihood of default?"**

### The Answer

**Grade G loans would need to charge 99% interest to break even**, but currently charge only 27.5%, revealing a 72-percentage-point mispricing gap. 

---

## 🔧 Technical Stack

| Component | Technology |
|-----------|------------|
| **Data Warehouse** | Google BigQuery |
| **ETL** | Python (pandas, BigQuery client) |
| **Analysis** | SQL (window functions, CTEs, aggregations) |
| **Visualization** | Looker Studio |
| **Version Control** | Git / GitHub |

---

## 📈 Dashboard

Interactive 5-page dashboard covering:
1. Executive summary with key metrics
2. Risk-return paradox visualization
3. Borrower segmentation analysis
4. Portfolio strategy comparison
5. Methodology and data sources

**[View Live Dashboard](https://lookerstudio.google.com/reporting/bcdfcab2-e361-4036-accf-7b290b1453da)**

---

## 🧮 Key Metrics Calculated

### ROI (Return on Investment)
```sql
ROI = (Total Payments + Recoveries - Funded Amount) / Funded Amount
```

### Breakeven Interest Rate
```sql
Breakeven Rate = Default Rate / (1 - Default Rate)
```
Example: 40% default rate requires 67% interest to break even

### Profitability Gap
```sql
Gap = Actual Interest Rate - Breakeven Rate
```
Negative gap = underpriced (losing money)

---

## 📖 Documentation
- **[Methodology](docs/methodology.md)** - Technical deep-dive
- **[Data Dictionary](docs/data_dictionary.md)** - Column definitions

---

## 📝 Limitations

- Analysis uses historical data (2007-2018); current platform may differ
- Excludes Current/Late loans (outcome unknown)
- Assumes 100% loss on defaults (actual recovery rates vary)
- Breakeven analysis assumes static default rates (may vary by macro conditions)

---

## 🎓 What This Project Demonstrates

### Technical Skills
✅ Complex SQL (window functions, CTEs, multi-table joins)  
✅ Data pipeline design (ETL, transformation, aggregation)  
✅ Cloud data warehousing (BigQuery)  
✅ Data visualization (Looker Studio)  
✅ Statistical analysis (ROI, breakeven calculations)  

### Business Skills
✅ Risk-return trade-off analysis  
✅ Credit risk assessment  
✅ Portfolio optimization  
✅ Strategic recommendations  
✅ Stakeholder communication (executive summaries, dashboards)  

### Analytical Skills
✅ Multi-dimensional segmentation  
✅ Scenario modeling  
✅ Root cause analysis  
✅ Insight synthesis  
✅ Data storytelling  

---

## 👤 About

**Roberto Mejia Lacayo**  
Data Analytics Portfolio Project  

📧 [robertomejialacayo@gmail.com]  
💼 [LinkedIn](https://www.linkedin.com/in/rmejialacayo/) 

---

## 📜 License

This project is for portfolio/educational purposes. Data sourced from publicly available Kaggle dataset.

---

## 🙏 Acknowledgments

- Data: LendingClub via Kaggle
- Tools: Google Cloud Platform, Looker Studio
- Inspiration: Real-world credit risk analysis challenges

---

**⭐ If you found this analysis interesting, please star this repository!**
