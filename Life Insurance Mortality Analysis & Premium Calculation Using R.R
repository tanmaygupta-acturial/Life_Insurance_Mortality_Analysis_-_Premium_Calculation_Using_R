

install.packages("tidyverse")   # Data manipulation and visualisation
library(tidyverse)

install.packages("ggplot2")     # Professional Charts
library(ggplot2)

install.packages("dplyr")       # Data Wrangling
library(dplyr)

install.packages("knitr")       # Clean output tables
library(knitr)


# ── CREATE LIFE TABLE ──
# lx = number of lives surviving to age x (out of 100,000 born)
# This is based on a simplified version of the Indian LIC mortality table

life_table = data.frame(
  age = 20:65,
  lx  = c(
    97340, 97180, 97010, 96830, 96640,  # age 20-24
    96440, 96220, 95990, 95740, 95470,  # age 25-29
    95180, 94860, 94510, 94120, 93690,  # age 30-34
    93210, 92670, 92060, 91370, 90590,  # age 35-39
    89710, 88720, 87600, 86340, 84920,  # age 40-44
    83320, 81510, 79480, 77200, 74640,  # age 45-49
    71780, 68590, 65050, 61140, 56840,  # age 50-54
    52140, 47040, 41580, 35830, 29890,  # age 55-59
    24870, 20280, 16220, 12700,  9740,  # age 60-64
    7350                                # age 65
  )
)

life_table


#---------------------------------------
# ── CALCULATE KEY MORTALITY METRICS ──
#---------------------------------------


life_table <- life_table %>%
  mutate(
    # dx = number of deaths between age x and x+1
    dx = lx - lead(lx, default = 0),
    
    # qx = probability of dying between age x and x+1
    # This is the core mortality rate used in all actuarial pricing
    qx = dx / lx,
    
    # px = probability of surviving from age x to x+1
    px = 1 - qx
  )

# View the first 10 rows
head(life_table, 10)


#-----------------------------------------------------
# ── PLOT 1: How mortality rate increases with age ──
#-----------------------------------------------------

ggplot(life_table, aes(x = age, y = qx)) +
  geom_line(color = "#1F4E79", size = 1.2) +
  geom_point(color = "#2E75B6", size = 1.8) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 0.1)) +
  labs(
    title    = "Annual Mortality Rate (qx) by Age",
    subtitle = "Probability of death increases significantly after age 50",
    x        = "Age",
    y        = "Annual Probability of Death (qx)",
    caption  = "Based on simplified LIC mortality table"
  ) +
  theme_minimal() +
  theme(
    plot.title    = element_text(face = "bold", size = 14, color = "#1F4E79"),
    plot.subtitle = element_text(size = 10, color = "#555555")
  )


#------------------------------------------------------------------------
# ── CALCULATE tpx — probability of surviving t more years from age x ──
# This is used to price annuities and long-term insurance products
#------------------------------------------------------------------------


# Function: probability of surviving from age x for t years
tpx <- function(start_age, t_years, table) {
  
  ages <- table %>%
    filter(age >= start_age & age < start_age + t_years)
  
  # Multiply all annual survival probabilities together
  # P(survive 10 years) = px(20) × px(21) × px(22) ... × px(29)
  survival_prob <- prod(ages$px, na.rm = TRUE)
  
  return(round(survival_prob, 6))
}

# Example: probability a 30-year-old survives 10, 20, 30 years
cat("P(30-year-old survives 10 years):", tpx(30, 10, life_table), "\n")
cat("P(30-year-old survives 20 years):", tpx(30, 20, life_table), "\n")
cat("P(30-year-old survives 30 years):", tpx(30, 30, life_table), "\n")


#---------------------------------------------------------
# ── TERM INSURANCE PREMIUM CALCULATOR ──
# Pure premium = Expected present value of death benefit
#---------------------------------------------------------


term_premium <- function(entry_age, term, sum_assured, interest_rate, table) {
  
  # Discount factor v = 1/(1+i)
  v <- 1 / (1 + interest_rate)
  
  APV <- 0  # Actuarial Present Value of benefit
  
  for (t in 0:(term - 1)) {
    
    current_age <- entry_age + t
    
    # Get the row for this age
    row <- table %>% filter(age == current_age)
    
    if (nrow(row) == 0) break
    
    # Probability of surviving to age x+t then dying in that year
    # = tpx × qx
    survive_to_t <- tpx(entry_age, t, table)
    die_in_year  <- row$qx
    
    # Present value of paying sum_assured at end of year t+1
    # discounted back to today
    pv_benefit <- sum_assured * survive_to_t * die_in_year * (v ^ (t + 1))
    
    APV <- APV + pv_benefit
  }
  
  # Annual premium = APV / annuity factor
  # For simplicity: level annual premium over term
  annuity <- sum(sapply(0:(term-1), function(t) {
    tpx(entry_age, t, table) * (v ^ t)
  }))
  
  annual_premium <- APV / annuity
  
  return(list(
    APV            = round(APV, 2),
    annual_premium = round(annual_premium, 2),
    monthly_premium = round(annual_premium / 12, 2)
  ))
}

#---------------------------------------------
# ── CALCULATE PREMIUMS FOR DIFFERENT AGES ──
#---------------------------------------------

ages_to_test <- c(25, 30, 35, 40, 45)
results <- data.frame()

for (age in ages_to_test) {
  p <- term_premium(
    entry_age    = age,
    term         = 20,
    sum_assured  = 1000000,  # ₹10 lakh cover
    interest_rate = 0.06,    # 6% discount rate
    table        = life_table
  )
  results <- rbind(results, data.frame(
    Entry_Age       = age,
    APV             = p$APV,
    Annual_Premium  = p$annual_premium,
    Monthly_Premium = p$monthly_premium
  ))
}

print(results)

#------------------------------------
# ── PLOT 2: Premium vs Entry Age ──
#------------------------------------

ggplot(results, aes(x = Entry_Age, y = Annual_Premium)) +
  geom_bar(stat = "identity", fill = "#2E75B6", width = 0.6) +
  geom_text(aes(label = paste0("₹", format(Annual_Premium, big.mark = ","))),
            vjust = -0.5, size = 3.5, color = "#1F4E79", fontface = "bold") +
  labs(
    title    = "Annual Term Insurance Premium by Entry Age",
    subtitle = "20-year term | ₹10 lakh sum assured | 6% discount rate",
    x        = "Entry Age",
    y        = "Annual Premium (₹)",
    caption  = "Pure premium — no expense or profit loading"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "#1F4E79")
  )


#-------------------------------------------------------------------------
# ── PLOT 3: How interest rate affects premium ──
# Lower interest rates = higher premiums (less investment income assumed)
#-------------------------------------------------------------------------


interest_rates <- c(0.04, 0.05, 0.06, 0.07, 0.08)
sensitivity    <- data.frame()

for (rate in interest_rates) {
  p <- term_premium(30, 20, 1000000, rate, life_table)
  sensitivity <- rbind(sensitivity, data.frame(
    Interest_Rate   = paste0(rate * 100, "%"),
    Annual_Premium  = p$annual_premium
  ))
}

ggplot(sensitivity, aes(x = Interest_Rate, y = Annual_Premium, group = 1)) +
  geom_line(color = "#1F4E79", size = 1.3) +
  geom_point(color = "#2E75B6", size = 3) +
  geom_text(aes(label = paste0("₹", format(Annual_Premium, big.mark = ","))),
            vjust = -1, size = 3.5, color = "#1F4E79") +
  labs(
    title    = "Premium Sensitivity to Interest Rate Assumption",
    subtitle = "Age 30 entry | 20-year term | ₹10 lakh cover",
    x        = "Discount Rate",
    y        = "Annual Premium (₹)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "#1F4E79")
  )


