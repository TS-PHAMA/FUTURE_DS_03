# ==================================================
# FUTURE_DS_03
# Marketing Funnel & Conversion Analysis
# Data Cleaning Script
# ==================================================

library(tidyverse)
library(janitor)
library(lubridate)

# ==================================================
# Import Data
# ==================================================
bank <- read.csv("data/raw/bank-additional-full.csv", sep = ";")

cat("\n==================== INITIAL INSPECTION ====================\n")
cat("Rows:", nrow(bank), "\n")
cat("Columns:", ncol(bank), "\n")

# ==================================================
# Clean Column Names
# ==================================================
bank <- clean_names(bank)
names(bank)

# ==================================================
# Check Structure
# ==================================================
str(bank)

# ==================================================
# Missing Values
# ==================================================
missing_values <- colSums(is.na(bank))
cat("\nMissing Values:\n")
print(missing_values[missing_values > 0])

# Check for "unknown" values
cat("\nUnknown Values by Column:\n")
for (col in names(bank)) {
  unknown_count <- sum(bank[[col]] == "unknown", na.rm = TRUE)
  if (unknown_count > 0) {
    cat(col, ":", unknown_count, "\n")
  }
}

# ==================================================
# Convert Data Types
# ==================================================

# Convert target variable
bank$y <- ifelse(bank$y == "yes", 1, 0)

# Convert categorical variables to factors
bank <- bank %>%
  mutate(across(where(is.character), as.factor))

# Create age groups
bank <- bank %>%
  mutate(age_group = case_when(
    age < 30 ~ "Under 30",
    age < 40 ~ "30-39",
    age < 50 ~ "40-49",
    age < 60 ~ "50-59",
    TRUE ~ "60+"
  ))

# Create duration groups (call duration is a key predictor)
bank <- bank %>%
  mutate(duration_group = case_when(
    duration < 120 ~ "0-2 min",
    duration < 300 ~ "2-5 min",
    duration < 600 ~ "5-10 min",
    duration < 900 ~ "10-15 min",
    TRUE ~ "15+ min"
  ))

# ==================================================
# Duplicate Check
# ==================================================
duplicates <- sum(duplicated(bank))
cat("\nDuplicate Records:", duplicates, "\n")

# ==================================================
# Funnel Metrics
# ==================================================

# Total contacts (top of funnel)
total_contacts <- nrow(bank)

# Conversions (subscribed = yes)
conversions <- sum(bank$y == 1)

# Non-conversions
non_conversions <- total_contacts - conversions

# Overall conversion rate
conversion_rate <- round(conversions / total_contacts * 100, 2)

cat("\n==================== FUNNEL METRICS ====================\n")
cat("Total Contacts (Top of Funnel):", total_contacts, "\n")
cat("Conversions (Subscribed):", conversions, "\n")
cat("Non-Conversions:", non_conversions, "\n")
cat("Conversion Rate:", conversion_rate, "%\n")

# ==================================================
# Final Summary
# ==================================================
cat("\n==================== FINAL SUMMARY ====================\n")
cat("Final Rows:", nrow(bank), "\n")
cat("Final Columns:", ncol(bank), "\n")
cat("Conversion Distribution:\n")
print(table(bank$y))

# ==================================================
# Save Cleaned Data
# ==================================================
dir.create("data/cleaned", recursive = TRUE, showWarnings = FALSE)
write.csv(bank, "data/cleaned/bank_marketing_clean.csv", row.names = FALSE)

cat("\nCleaned dataset saved to data/cleaned/bank_marketing_clean.csv\n")