# FUTURE_DS_03

## Marketing Funnel & Conversion Performance Analysis

**Future Interns — Data Science & Analytics Task 3**

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

---

## 📊 Project Overview

This project analyzes **41,188 marketing contacts** from a bank's telemarketing campaigns to identify conversion drivers, funnel drop-off points, and optimization opportunities. Using logistic regression, the analysis quantifies the strongest predictors of customer subscription and provides evidence-based recommendations to improve marketing ROI.

---

## 🎯 Business Questions Answered

1. ✅ Where are users dropping off in the funnel?
2. ✅ Which channels bring high-quality leads?
3. ✅ How can conversion rates be improved?
4. ✅ Which stages need optimization?
5. ✅ What is the ROI impact of changes?

---

## 📈 Funnel Overview

| Metric | Value |
|--------|-------|
| **Top of Funnel (Contacts)** | **41,188** |
| **Conversions** | **4,640** |
| **Conversion Rate** | **11.27%** |
| Drop-off Rate | 88.73% |

---

## 🔍 Key Findings

### The Conversion Formula
The highest-probability contact uses **cellular phone**, has a **previous successful relationship**, is called for **15+ minutes**, during **March or October**, and is a **student or retiree aged 60+**. This profile converts at rates exceeding 50%.

### Top Conversion Drivers
- 🟢 **Call Duration 15+ min:** 59.35% conversion (228× odds ratio)
- 🟢 **Call Duration 10-15 min:** 42.30% conversion (97.4× odds ratio)
- 🟢 **Previous Success:** 65.11% re-conversion (10.7× odds ratio)
- 🟢 **Month: March:** 50.55% conversion (6.15× odds ratio)
- 🟢 **Cellular Contact:** 14.74% vs 5.23% for telephone

### Conversion Killers
- 🔴 **Call Duration 0-2 min:** 1.28% conversion
- 🔴 **Month: May:** 6.43% conversion (8× worse than March)
- 🔴 **Month: July:** 9.05% conversion
- 🔴 **Telephone Contact:** 66% lower odds than cellular
- 🔴 **Job: Blue-Collar:** 6.89% conversion (5× worse than students)

### Best Segments to Target
- 🏆 **Students:** 31.43% conversion
- 🏆 **Retirees:** 25.23% conversion
- 🏆 **Age 60+:** 39.56% conversion
- 🏆 **Age Under 30:** 16.26% conversion

---

## 🔬 Statistical Evidence

| Analysis | Key Result |
|----------|------------|
| **Logistic Regression** | 90.60% accuracy, 97.36% specificity |
| **Pseudo R-squared** | 0.371 (strong) |
| **#1 Predictor** | Call Duration 15+ min: 228× odds ratio |
| **#2 Predictor** | Call Duration 10-15 min: 97.4× odds ratio |
| **#3 Predictor** | Previous Success: 10.7× odds ratio |
| **Significant Factors** | Multiple across contact, job, age, duration, month, previous outcome |

---

## 💼 Business Recommendations

### Immediate Actions (0-3 months)
1. **Prioritize cellular contact** — 3× higher conversion than telephone
2. **Train agents on call duration** — Push conversations past 5 minutes
3. **Retarget previous successes** — 65.1% re-conversion rate

### Strategic Initiatives (3-12 months)
4. **Target students and retirees** — 31.4% and 25.2% conversion
5. **Optimize seasonal campaigns** — Shift volume to March, October, December
6. **Reduce May/July campaigns** — Sub-10% conversion wastes resources
7. **Develop 60+ age segment** — 39.6% conversion rate

### Estimated Impact
Improving conversion from **11.27% to 15%** = **1,535 additional conversions** = **$767,500 in additional revenue**.

---

## 🛠️ Tools & Techniques

| Technique | Purpose |
|-----------|---------|
| **R / tidyverse** | Data cleaning, transformation, analysis |
| **Funnel Analysis** | Conversion rates by segment and channel |
| **Logistic Regression** | Quantify conversion drivers (odds ratios) |
| **Seasonality Analysis** | Identify optimal campaign timing |
| **Confusion Matrix** | Evaluate model performance |
| **ggplot2** | Professional data visualizations |
| **LaTeX / Overleaf** | Professional report generation |
| **Git / GitHub** | Version control and portfolio |



---

## 📝 Methodology

1. **Data Cleaning** — Handle missing values, create derived features (age groups, duration groups)
2. **Funnel Analysis** — Conversion rates by contact method, job, age, education, call duration, month
3. **Seasonality Analysis** — Identify high and low performing months
4. **Logistic Regression** — Quantify conversion drivers with odds ratios
5. **Model Evaluation** — Confusion matrix, accuracy, sensitivity, specificity
6. **Business Recommendations** — Evidence-based marketing optimization strategies

---

## 🎓 Skills Demonstrated

- Marketing funnel and conversion analysis
- Channel performance comparison
- Customer segmentation for targeting
- Seasonality and campaign timing analysis
- Predictive modeling (Logistic Regression)
- Business-focused insight generation
- ROI estimation and recommendations

---

## 📞 Connect

**Author:** Thembinkosi Phama  
**Repository:** [FUTURE_DS_03](https://github.com/TS-PHAMA/FUTURE_DS_03)  
**Internship:** Future Interns — Data Science & Analytics Track

---

*© 2026 — Future Interns Data Science & Analytics Task 3*
