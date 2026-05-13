# 📊 Life Insurance Mortality Analysis & Premium Calculation Using R

### *Decoding the Mathematics Behind Insurance Pricing*

A professional actuarial analytics project built using **R Programming** that simulates how life insurance companies calculate premiums using **mortality tables, survival probabilities, and actuarial present value models**.

This project combines **Actuarial Science, Financial Mathematics, Data Analytics, and Visualization** to build a simplified real-world insurance pricing engine from scratch.

---

## 📌 Overview

Life insurance pricing is not random — it is driven by mathematics, probability theory, and financial risk modeling.

This project demonstrates how insurers estimate:

* Probability of survival and death
* Future financial liabilities
* Risk-adjusted premium amounts
* The impact of age and interest rates on policy pricing

Using a simplified LIC-style mortality table, the project performs actuarial calculations and visualizes key insurance insights through professional charts and analytical models.

---

## ✨ Features

* 📊 Mortality Analysis & Visualization
* 🧮 Life Table Construction
* 📈 Survival Probability Modeling (`tpx`)
* 💰 Term Insurance Premium Calculator
* ⚡ Fast & Efficient Actuarial Calculations
* 📉 Interest Rate Sensitivity Analysis
* 🧠 Financial Risk Modeling
* 📁 Clean & Modular R Code Structure
* 📊 Professional Data Visualizations using `ggplot2`

---

## 🏗 Tech Stack

* **R Programming**
* **tidyverse**
* **ggplot2**
* **dplyr**
* **knitr**

---

## 🧠 Core Actuarial Models

### Mortality Probability

q_x = \frac{d_x}{l_x}

### Survival Probability

{}*tp_x = \prod*{k=0}^{t-1} p_{x+k}

### Actuarial Present Value (APV)

APV = \sum_{t=0}^{n-1} v^{t+1} \cdot {}*tp_x \cdot q*{x+t} \cdot S

---

## 📂 Project Structure

```bash
Life-Insurance-Mortality-Analysis/
│
├── data/                    # Mortality table data
├── visualizations/          # Generated actuarial charts
├── outputs/                 # Premium calculation results
├── life_insurance_analysis.R
├── README.md
└── requirements.txt
```

---

## 📈 Visual Reports Included

### 📉 Annual Mortality Rate Analysis

Visualizes how mortality risk increases significantly with age.

### 💰 Premium vs Entry Age

Shows how insurance premiums rise as mortality risk increases.

### 📊 Interest Rate Sensitivity

Analyzes how discount rate assumptions impact premium pricing.

---

## 🚀 Example Scenario

The model calculates premiums for:

* Entry Age: 30
* Policy Term: 20 Years
* Sum Assured: ₹10,00,000
* Interest Rate: 6%

Outputs Generated:

* Actuarial Present Value (APV)
* Annual Premium
* Monthly Premium
* Risk Sensitivity Insights

---

## ▶️ Installation & Usage

### Install Required Packages

```r
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("knitr")
```

### Run the Project

```r
source("life_insurance_analysis.R")
```

---

## 🎯 Learning Outcomes

This project is ideal for:

* Actuarial Science Students
* Finance & Insurance Learners
* Data Analytics Enthusiasts
* Quantitative Finance Beginners
* R Programming Practice

Key Concepts Learned:

* Mortality Modeling
* Insurance Mathematics
* Survival Analysis
* Present Value Calculations
* Financial Risk Assessment
* Data Visualization in R

---

## 🔮 Future Enhancements

* Whole Life Insurance Pricing
* Endowment Policy Models
* Real LIC Mortality Tables
* Monte Carlo Simulations
* Stochastic Mortality Modeling
* Expense & Profit Loading
* Interactive Shiny Dashboard
* Predictive Risk Analytics

---

## ⭐ Support

If you found this project interesting or useful:

⭐ Star the repository
🍴 Fork the project
📢 Share with actuarial & finance communities

---

## 👨‍💻 Author

I am an aspiring actuary currently pursuing the IFOA fellowship qualification. I cleared CM1
(Actuarial Mathematics) and CS1 (Actuarial Statistics) in 2025, alongside completing a
B.Com (Hons.) with a 9.0 CGPA. CM2 result is currently awaited and I am preparing for CS2.
I am actively seeking entry-level roles in actuarial analysis, risk analytics, or insurance —
open to Delhi NCR, Gurugram, Bangalore, Hyderabad, and Mumbai.

tanmay3415gupta@gmail.com
+91 9899051054

