# 📊 IBM HR Employee Attrition Analysis — Power BI Project

## 🧭 Overview

This project analyzes the IBM HR Employee Attrition dataset (~1,470 employees, 35 attributes) to identify the key drivers of employee attrition and provide HR stakeholders with an interactive, decision-support dashboard. Data was loaded into **SQL Server**, explored and validated with SQL, shaped into reusable views, then modeled and visualized in **Power BI** using DAX measures, calculated columns, drill-through navigation, and a What-If scenario simulation.

**🛠️ Tech stack:** SQL Server (querying, validation, views) → Power BI (data modeling, DAX, visualization)

---

## 🗄️ SQL Analysis — Why It Matters

Even though the source dataset was already reasonably clean, the SQL layer wasn't skipped — it was used deliberately, for a few reasons:

- ✅ **Trust, don't assume.** "Clean" data still needs to be verified — checking for duplicate Employee IDs, unexpected NULLs, invalid ranges (e.g., negative income, zero age), and confirming categorical columns only contain expected values (e.g., `Attrition` really only has `Yes`/`No`) is a baseline step before any analysis is trusted.
- ✅ **SQL is faster for first-pass exploration.** Aggregations, grouping, and ranking directly in SQL are quicker to iterate on than doing the same exploration inside Power BI, and they don't require the model to be built first.
- ✅ **Pre-aggregation and reusable logic.** Building **views** (e.g., department-wise attrition, job-role-wise attrition, age bands, tenure bands) pushes repeatable logic to the database layer instead of duplicating it in DAX — cleaner separation of concerns, and the same views could serve other BI tools, not just Power BI.
- ✅ **It demonstrates a real skill independently of Power BI.** SQL — CTEs, window functions, views — is a distinct, resume-relevant skill from DAX, and doing meaningful analysis in SQL first (not just `SELECT *`) shows that.

### What was done in SQL

**🔍 Data Quality Checks**
- Row counts, distinct Employee ID checks, duplicate ID detection
- Distinct-value checks on every categorical column (Department, Gender, JobRole, MaritalStatus, OverTime, BusinessTravel, Education, EducationField, Attrition)
- Min/Max/Avg sanity checks on numeric columns (Age, MonthlyIncome, TotalWorkingYears, YearsAtCompany) to catch invalid or unusual values

**👥 Basic Workforce Analysis**
- Headcount by Department, Job Role, Gender, Business Travel, Education Field

**📉 Attrition Analysis**
- Overall attrition count and rate
- Attrition rate by Department, Job Role, Gender, Age Group, Business Travel, Marital Status

**💰 Salary & Experience**
- Avg income for leavers vs. stayers
- Attrition rate by salary band and by tenure/experience bands
- Employees earning below their job role's average salary (using a CTE)

**🌱 Work Environment**
- Attrition rate by Job Satisfaction, Environment Satisfaction, Work-Life Balance, OverTime, and Job Role + OverTime combined

**⚙️ Advanced SQL**
- **CTEs** comparing each department's attrition rate against the company-wide rate
- **Window functions** (`RANK() OVER`) to rank employees by salary within department, rank job roles by attrition rate, and find the top 3 highest-paid employees per department
- Combined filtering to identify high-risk segments (high attrition + low satisfaction + overtime)
- **Views created** for reuse in Power BI: employee summary, department-wise summary, job-role-wise summary, and age-group summary

---

## 🧩 Data Model Note

The current model is built primarily around a **single fact table** (the IBM HR employee table). Alongside it, Power BI also holds two small **supporting tables** created for interactivity rather than for employee data itself:
- A disconnected **What-If Parameter table** (`OT Reduction %`) powering the OverTime simulation
- A disconnected **Factors table** powering the Predictor Spread ranking chart

*(If there's a second real data table you're joining in — e.g., a separate Department or Performance table — let me know and I'll document its relationship and join logic here too.)*

---

## 1️⃣ Dashboard: HR Workforce Overview

<img width="611" height="344" alt="image" src="https://github.com/user-attachments/assets/f9488356-3956-42d0-be90-7281ae1075e8" />


**🎯 Purpose:** Give a high-level snapshot of workforce size and overall attrition health — the "are we okay?" page.

**🔘 Slicers:** Attrition (No/Yes), Gender (Female/Male)

### KPIs
| KPI | Value | Description |
|---|---|---|
| Total Employees | 1,470 | Total headcount in the dataset |
| Attrition Rate | 16.12% | % of employees who left |
| Avg Age | 37 | Average employee age |
| Avg Monthly Income | ₹6,502.93 | Average monthly income across all employees |
| Avg Years at Company | 7 | Average tenure |
| No. of Employees Left | 237 | Count of employees with Attrition = Yes |
| No. of Employees Stay | 1,233 | Count of employees with Attrition = No |

### Charts
- 🏢 Attrition by Department (stacked column, No/Yes)
- 👔 No. of Employees by Job Role (bar)
- 🥧 Attrition Rate by Gender (pie)
- 📈 Attrition Rate by Age Group (bar) — highest at 18–24 (39.18%), dropping steadily with age
- 🏢 No. of Employees by Department (clustered column, legend: Gender)

---

## 2️⃣ Dashboard: Attrition Analysis

<img width="609" height="347" alt="image" src="https://github.com/user-attachments/assets/191554ba-2ac3-416b-bfbf-47a537afcae6" />


**🎯 Purpose:** The diagnostic page — explains *why* attrition is happening by comparing attrition rate across key behavioral and satisfaction factors.

**🔘 Slicers:** Department (Human Resources / Research & Development / Sales), Attrition (No/Yes), Gender (Female/Male)

### KPIs
| KPI | Value | Description |
|---|---|---|
| Highest Attrition Age Group | 18–24 | Age band with the highest attrition rate |
| Overtime Attrition Gap | 20.09% | Gap between OverTime = Yes vs. No attrition rates |
| Low Satisfaction Attrition | 47.26% | Share of all leavers who had low job satisfaction |
| Income Gap % | 29.94% | % difference in avg income between leavers and stayers |
| Top Attrition Department | Sales | Department with the highest attrition rate |
| Top Attrition Job Role | Sales Representative | Job role with the highest attrition rate |

### Charts
- 😊 Attrition Rate by Job Satisfaction & Marital Status (clustered column, legend: Divorced/Married/Single)
- ⏰ Attrition Rate by OverTime (30.53% Yes vs. 10.44% No)
- 🏢 Attrition Count vs Attrition Rate by Department (combo chart: column = count, line = rate)
- 📋 Job Role Summary table (Job Role, Total Employees, Avg Income, Attrition Count, Attrition Rate %)
- 👔 Attrition Rate by Job Role (legend: Gender) — Sales Representative and Laboratory Technician stand out highest

---

## 3️⃣ Dashboard: Employee & Job Insights

<img width="611" height="350" alt="image" src="https://github.com/user-attachments/assets/e90794cf-2940-47a5-85ba-0fe278db3d28" />


**🎯 Purpose:** A workforce-composition page — shifts from "why attrition happens" to "what does our workforce look like," useful for general HR planning rather than attrition specifically.

### KPIs
| KPI | Value | Description |
|---|---|---|
| Total Departments | 3 | Distinct count of departments |
| Total Job Roles | 9 | Distinct count of job roles |
| Avg Years in Current Role | 4.23 | Average tenure in current role |
| % With Stock Options | 1% | Share of employees with Stock Option Level ≥ 1 |
| Avg Distance From Home | 9.19 | Average commute distance |
| Avg Performance Rating | 3.15 | Average numeric performance score (see note below) |
| Attrition Rate (OT Yes) | 30.53% | Attrition rate among employees who work overtime |
| Attrition Rate (OT No) | 10.44% | Attrition rate among employees who don't work overtime |

### Charts
- 🏗️ Count of Employees by Job Level (column)
- 💵 Avg Monthly Salary by Job Level & Gender (clustered column)
- ✈️ Count of Employees by Business Travel (donut) — Travel_Rarely dominates at 70.95%
- 😊 Attrition Rate by Job Satisfaction (bar) — Low satisfaction shows the highest attrition at 22.84%
- 📆 Count of Employees by Tenure Band (column: 0–2 / 3–5 / 6–10 / 11–20 / 20+ years)
- 🔵 Avg Monthly Salary vs Avg Performance Rating by Job Role (scatter, bubble size = Total Employees)

**📝 Note:** Performance Rating was converted to descriptive text labels (e.g., "Low," "Excellent") for display purposes elsewhere in the model. A separate hidden numeric column (`PerformanceRatingNum`) was created specifically to support average calculations, keeping display formatting and calculation logic cleanly separated.

---

## 4️⃣ Dashboard: Employee Details (Drill-Through)

<img width="611" height="342" alt="image" src="https://github.com/user-attachments/assets/d685fbad-c04b-41cf-82d2-5d09638e3afc" />


**🎯 Purpose:** A record-level detail page reached by drilling through from other pages. Lets a viewer go from "something's wrong in this department/role" to seeing exactly which employees, and flags currently active employees who resemble past leavers.

### KPIs
| KPI | Value | Description |
|---|---|---|
| Filtered Total Employees | 828 *(example: R&D drill-through)* | Number of employees in the current drill-through context |
| At Risk Employee Count | 645 | Count of currently active employees with a high Flight Risk Score |
| Avg Risk Score | 2.08 | Average Flight Risk Score within the filtered slice |
| Attrition Rate (vs Overall) | 16.12% (−0%) | Filtered attrition rate, with the delta vs. company-wide rate shown alongside |

### Charts / Visuals
- 📋 **Employee Summary table** — Employee Number, Age, Gender, Marital Status, Job Role, Years At Company, Total Working Years, Monthly Income, OverTime, Job Satisfaction, Work-Life Balance, Years Since Last Promotion, Attrition, Flight Risk Score
- 🔙 Back button for returning to the source page

### 🖱️ How Drill-Through Works
1. Fields (Department, Job Role, Age Group) are added to this page's **Drillthrough** well in the Visualizations pane.
2. On any other page, right-clicking a data point that uses one of those fields shows a **"Drill through"** option.
3. Selecting it navigates to this page, automatically filtered to that context (e.g., Department = Research & Development).
4. An auto-generated **back button** lets the viewer return to the page they came from.
5. Multiple drillthrough fields apply as an **AND** filter — a field only filters if the source visual actually contains that field.

---

## ➕ Additional Feature 1: What-If Analysis (OverTime Reduction Simulation)

<img width="540" height="173" alt="image" src="https://github.com/user-attachments/assets/3f3e5259-8578-4d08-b65b-ab6e292e0419" />

### 💡 What it is
An interactive scenario tool using Power BI's **What-If Parameter** feature. A slider (`OT Reduction %`) lets the viewer simulate reducing the OverTime-driven attrition rate by a chosen percentage, and see the projected effect on overall attrition.

**Example from the dashboard:** at a slider value of **0.15 (15% OT reduction)** — Current Attrition Rate: **16.12%** → Simulated Attrition Rate: **14.83%** → Attrition Rate Change: **−1.3%**

### 🤔 Why it was added
The standard dashboard shows attrition is *correlated* with overtime (a ~20-point gap between OT and non-OT employees), but that's an observation, not a recommendation. The What-If tool turns that observation into a **decision-support estimate**: "if HR reduces overtime by X%, attrition could drop by roughly Y%." It shifts the dashboard from descriptive to prescriptive.

### 🎯 Purpose
- Makes the OT–attrition relationship tangible and interactive rather than a static percentage
- Gives a rough, directional estimate to support a resource-allocation or policy conversation (e.g., hiring more staff to reduce reliance on overtime)
- Demonstrates scenario modeling, not just reporting

### ⏱️ When to use it
Best used once a factor (like OverTime) has already been identified as a top driver of attrition — it's the natural next step after diagnosis, before recommending action. It is **not** a validated predictive model; it assumes a simplified, linear relationship between OT reduction and attrition rate, and should be presented with that caveat.

### Visuals
- 🎚️ Slider (auto-generated from the parameter)
- 🔢 KPI cards: Attrition Rate, Simulated Attrition Rate, Attrition Rate Change

---

## ➕ Additional Feature 2: Model / Predictors Page

<img width="563" height="263" alt="image" src="https://github.com/user-attachments/assets/f70a5d04-d224-441f-ba13-0570b3ca3376" />


### 💡 What it is
A separate sheet containing a ranked bar chart showing which factors have the largest impact on attrition, measured by the **spread** (max attrition rate − min attrition rate) across each factor's categories.

**Results from the dashboard:**
| Factor | Spread |
|---|---|
| ⏰ OverTime | 20.09% |
| ✈️ Business Travel | 16.91% |
| ⚖️ Work-Life Balance | 1.85% (KPI card rounds to 2%) |
| 😊 Job Satisfaction | 0.61% |

### 🎯 Purpose
Findings elsewhere in the dashboard are spread across multiple KPI cards and charts. This page consolidates them into one direct answer to: **"Out of everything measured, what matters most for attrition?"** It functions as the project's executive summary / "so what" page, and sets up the What-If simulation as a logical next step (top driver identified → simulate fixing it → show projected impact). The results confirm OverTime is the strongest driver, with Business Travel as a close second — a finding not obvious from any single earlier chart.

### 📝 Note on methodology
This is not a statistical or machine-learning model — it's an explainable proxy built by comparing attrition rates across each factor's categories and ranking the spread. It approximates the kind of top-driver findings a full logistic regression model would typically surface on this dataset, without requiring one.

---

## 🧮 Key DAX Functions Used

| Function | Purpose in this project |
|---|---|
| `DIVIDE` | Safe division for all rate calculations (e.g., Attrition Rate), avoiding divide-by-zero errors |
| `CALCULATE` | Changes filter context — used throughout to isolate leavers vs. stayers, OT vs. non-OT, department-specific rates, etc. |
| `SWITCH` (with `TRUE()`) | Used to bucket continuous fields into categories — Age Group, Tenure Band, and the Scenario/Factor lookup measures |
| `SELECTEDVALUE` | Used in dynamic text KPIs (e.g., Top Attrition Department/Job Role) and in the Predictor Spread switch measure to read the currently selected row from a disconnected table |
| `ALL` | Clears filter context to calculate company-wide baselines (e.g., overall attrition rate used in "Attrition Rate vs Overall") |
| `ALLEXCEPT` | Used inside `TOPN` ranking measures to preserve one dimension while clearing others |
| `TOPN` | Ranks departments/job roles by attrition rate to return the single highest one |
| `RANKX` | Ranks departments by attrition rate for ordinal comparison |
| `MAX` / `MIN` (via TOPN/spread logic) | Used to compute the spread (max − min attrition rate) behind the Predictor Spread chart |
| `COUNTROWS` | Base row-counting logic behind headcount and attrition counts |
| `AVERAGE` | Used for average income, tenure, distance, performance rating, etc. |
| `VAR` / `RETURN` | Used throughout to break complex measures (What-If simulation, vs-Overall comparison) into readable steps |

---

## 🔎 Summary of Findings

- ⏰ Employees who work **overtime** have an attrition rate roughly **20 percentage points higher** (30.53% vs. 10.44%) than those who don't — the strongest single driver identified.
- ✈️ **Business Travel** is the second strongest factor, with a **16.91-point spread** across travel frequency categories.
- 😞 **47.26%** of all employees who left had low job satisfaction (rated ≤2 of 4).
- 👶 Attrition is highest in the **18–24 age group (39.18%)** and drops steadily with age.
- 🏢 **Sales** is the top attrition department, and **Sales Representative** the top attrition job role.
- 💰 There's a **29.94% income gap** between employees who left and those who stayed.
- 🎯 A simplified What-If simulation suggests a 15% reduction in overtime could lower overall attrition from 16.12% to roughly 14.83%, though this is a directional estimate, not a validated forecast.

---

## 🚀 Possible Future Extensions
- Replace the manual "spread" predictor ranking with an actual logistic regression model (Python) feeding back into Power BI
- Add real Row-Level Security testing with multiple user roles
- Expand the What-If simulation to combine multiple factors (OT + Business Travel) simultaneously
- Formalize the SQL views into a proper star schema with dimension tables (Department, Job Role, Date) if the project is extended

---

## 🖼️ Screenshots

All dashboard screenshots referenced above should be saved into an `/images` folder in the repository using the filenames used in this README (`01_hr_workforce_overview.png`, `02_attrition_analysis.png`, `03_employee_job_insights.png`, `04_employee_details.png`, `05_what_if_analysis.png`, `06_predictor_spread.png`) so they render correctly on GitHub.
