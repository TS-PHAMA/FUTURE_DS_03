# ==================================================
# FUTURE_DS_03
# Funnel Analysis - Conversion Rates & Visualizations
# ==================================================

library(tidyverse)
library(scales)
library(gridExtra)

# Load cleaned data
bank <- read.csv("data/cleaned/bank_marketing_clean.csv")
bank <- bank %>% mutate(across(where(is.character), as.factor))

cat("\n================================================")
cat("\n  MARKETING FUNNEL ANALYSIS")
cat("\n================================================\n")

# ==================================================
# 1. OVERALL FUNNEL METRICS
# ==================================================
total_contacts <- nrow(bank)
conversions <- sum(bank$y == 1)
conversion_rate <- round(conversions / total_contacts * 100, 2)

cat("\n==================== FUNNEL OVERVIEW ====================\n")
cat("Top of Funnel (Total Contacts):", comma(total_contacts), "\n")
cat("Bottom of Funnel (Conversions):", comma(conversions), "\n")
cat("Overall Conversion Rate:", conversion_rate, "%\n")
cat("Drop-off Rate:", round(100 - conversion_rate, 2), "%\n")

# ==================================================
# 2. CONVERSION BY CONTACT METHOD
# ==================================================
cat("\n==================== CONVERSION BY CONTACT METHOD ====================\n")

contact_funnel <- bank %>%
  group_by(contact) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(conversion_rate))

print(contact_funnel)

# ==================================================
# 3. CONVERSION BY JOB TYPE
# ==================================================
cat("\n==================== CONVERSION BY JOB ====================\n")

job_funnel <- bank %>%
  group_by(job) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(conversion_rate))

print(job_funnel, n = 20)

# ==================================================
# 4. CONVERSION BY AGE GROUP
# ==================================================
cat("\n==================== CONVERSION BY AGE ====================\n")

age_funnel <- bank %>%
  group_by(age_group) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(conversion_rate))

print(age_funnel)

# ==================================================
# 5. CONVERSION BY EDUCATION
# ==================================================
cat("\n==================== CONVERSION BY EDUCATION ====================\n")

education_funnel <- bank %>%
  group_by(education) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(conversion_rate))

print(education_funnel, n = 20)

# ==================================================
# 6. CONVERSION BY CALL DURATION
# ==================================================
cat("\n==================== CONVERSION BY CALL DURATION ====================\n")

duration_funnel <- bank %>%
  group_by(duration_group) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(duration_group)

print(duration_funnel)

# ==================================================
# 7. CONVERSION BY MONTH (SEASONALITY)
# ==================================================
cat("\n==================== CONVERSION BY MONTH ====================\n")

month_funnel <- bank %>%
  group_by(month) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(conversion_rate))

print(month_funnel, n = 10)

# ==================================================
# 8. CONVERSION BY PREVIOUS OUTCOME
# ==================================================
cat("\n==================== CONVERSION BY PREVIOUS OUTCOME ====================\n")

poutcome_funnel <- bank %>%
  group_by(poutcome) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(conversion_rate))

print(poutcome_funnel)

# ==================================================
# 9. CONVERSION BY HOUSING LOAN STATUS
# ==================================================
cat("\n==================== CONVERSION BY HOUSING & LOAN ====================\n")

housing_funnel <- bank %>%
  group_by(housing, loan) %>%
  summarise(
    total = n(),
    conversions = sum(y),
    conversion_rate = round(conversions / total * 100, 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(conversion_rate))

print(housing_funnel)

# ==================================================
# SAVE ALL TABLES
# ==================================================
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(contact_funnel, "outputs/tables/conversion_by_contact.csv", row.names = FALSE)
write.csv(job_funnel, "outputs/tables/conversion_by_job.csv", row.names = FALSE)
write.csv(age_funnel, "outputs/tables/conversion_by_age.csv", row.names = FALSE)
write.csv(education_funnel, "outputs/tables/conversion_by_education.csv", row.names = FALSE)
write.csv(duration_funnel, "outputs/tables/conversion_by_duration.csv", row.names = FALSE)
write.csv(month_funnel, "outputs/tables/conversion_by_month.csv", row.names = FALSE)
write.csv(poutcome_funnel, "outputs/tables/conversion_by_poutcome.csv", row.names = FALSE)
write.csv(housing_funnel, "outputs/tables/conversion_by_housing_loan.csv", row.names = FALSE)

# ==================================================
# VISUALIZATIONS
# ==================================================
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# Color palette
funnel_colors <- c("high" = "#2ecc71", "medium" = "#f39c12", "low" = "#e74c3c")

# ---- Plot 1: Funnel Overview ----
funnel_data <- data.frame(
  stage = c("Total Contacts", "Conversions"),
  value = c(total_contacts, conversions)
)

p1 <- ggplot(funnel_data, aes(x = stage, y = value, fill = stage)) +
  geom_bar(stat = "identity", width = 0.5, alpha = 0.9) +
  geom_text(aes(label = paste0(comma(value), "\n(", 
                               c("100%", paste0(conversion_rate, "%")), ")")),
            vjust = -0.1, size = 5, fontface = "bold", color = "gray20") +
  scale_fill_manual(values = c("Total Contacts" = "#3498db", "Conversions" = "#2ecc71"), guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2)), labels = comma) +
  labs(title = "Marketing Funnel Overview",
       subtitle = paste0("Overall Conversion Rate: ", conversion_rate, "%"),
       x = NULL, y = "Number of Contacts") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 16, color = "#2c3e50"),
        plot.subtitle = element_text(size = 11, color = "#7f8c8d"),
        axis.text.x = element_text(size = 13, face = "bold"))

ggsave("outputs/figures/funnel_overview.png", p1, width = 8, height = 6, dpi = 300, bg = "white")

# ---- Plot 2: Conversion by Contact Method ----
p2 <- ggplot(contact_funnel, aes(x = reorder(contact, conversion_rate), y = conversion_rate, fill = conversion_rate)) +
  geom_bar(stat = "identity", width = 0.6, alpha = 0.9) +
  geom_text(aes(label = paste0(conversion_rate, "%")), hjust = -0.1, size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#e74c3c", high = "#2ecc71", guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
  coord_flip() +
  labs(title = "Conversion Rate by Contact Method",
       subtitle = "Cellular outperforms telephone significantly",
       x = NULL, y = "Conversion Rate (%)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        axis.text.y = element_text(size = 11, face = "bold"))

ggsave("outputs/figures/conversion_by_contact.png", p2, width = 10, height = 5, dpi = 300, bg = "white")

# ---- Plot 3: Conversion by Job (Top 10) ----
top10_jobs <- job_funnel %>% head(10)

p3 <- ggplot(top10_jobs, aes(x = reorder(job, conversion_rate), y = conversion_rate, fill = conversion_rate)) +
  geom_bar(stat = "identity", width = 0.7, alpha = 0.9) +
  geom_text(aes(label = paste0(conversion_rate, "%")), hjust = -0.1, size = 3.8, fontface = "bold") +
  scale_fill_gradient(low = "#f39c12", high = "#2ecc71", guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
  coord_flip() +
  labs(title = "Top 10 Jobs by Conversion Rate",
       subtitle = "Students and retirees convert at highest rates",
       x = NULL, y = "Conversion Rate (%)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        axis.text.y = element_text(size = 10, face = "bold"))

ggsave("outputs/figures/conversion_by_job.png", p3, width = 10, height = 6, dpi = 300, bg = "white")

# ---- Plot 4: Conversion by Age Group ----
p4 <- ggplot(age_funnel, aes(x = age_group, y = conversion_rate, fill = conversion_rate)) +
  geom_bar(stat = "identity", width = 0.7, alpha = 0.9) +
  geom_text(aes(label = paste0(conversion_rate, "%")), vjust = -0.3, size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#e74c3c", high = "#2ecc71", guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Conversion Rate by Age Group",
       subtitle = "Older demographics show higher conversion",
       x = "Age Group", y = "Conversion Rate (%)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("outputs/figures/conversion_by_age.png", p4, width = 10, height = 6, dpi = 300, bg = "white")

# ---- Plot 5: Conversion by Call Duration ----
p5 <- ggplot(duration_funnel, aes(x = duration_group, y = conversion_rate, fill = conversion_rate)) +
  geom_bar(stat = "identity", width = 0.7, alpha = 0.9) +
  geom_text(aes(label = paste0(conversion_rate, "%")), vjust = -0.3, size = 3.5, fontface = "bold") +
  scale_fill_gradient(low = "#e74c3c", high = "#2ecc71", guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
  labs(title = "Conversion Rate by Call Duration",
       subtitle = "Longer calls dramatically increase conversion",
       x = "Call Duration", y = "Conversion Rate (%)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("outputs/figures/conversion_by_duration.png", p5, width = 10, height = 6, dpi = 300, bg = "white")

# ---- Plot 6: Conversion by Month (Seasonality) ----
month_order <- c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")
month_funnel$month <- factor(month_funnel$month, levels = month_order)

p6 <- ggplot(month_funnel, aes(x = month, y = conversion_rate, group = 1)) +
  geom_line(color = "#2ecc71", linewidth = 1.5) +
  geom_point(aes(color = conversion_rate), size = 4) +
  geom_text(aes(label = paste0(conversion_rate, "%")), vjust = -1, size = 3.5, fontface = "bold") +
  scale_color_gradient(low = "#e74c3c", high = "#2ecc71", guide = "none") +
  scale_y_continuous(limits = c(0, max(month_funnel$conversion_rate) + 5)) +
  labs(title = "Conversion Rate by Month (Seasonality)",
       subtitle = "Spring months show strongest conversion performance",
       x = "Month", y = "Conversion Rate (%)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("outputs/figures/conversion_by_month.png", p6, width = 10, height = 6, dpi = 300, bg = "white")

# ---- Plot 7: Previous Outcome Impact ----
p7 <- ggplot(poutcome_funnel, aes(x = reorder(poutcome, conversion_rate), y = conversion_rate, fill = conversion_rate)) +
  geom_bar(stat = "identity", width = 0.6, alpha = 0.9) +
  geom_text(aes(label = paste0(conversion_rate, "%")), hjust = -0.1, size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#e74c3c", high = "#2ecc71", guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
  coord_flip() +
  labs(title = "Conversion Rate by Previous Campaign Outcome",
       subtitle = "Previous success = 65% conversion on follow-up",
       x = NULL, y = "Conversion Rate (%)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        axis.text.y = element_text(size = 11, face = "bold"))

ggsave("outputs/figures/conversion_by_poutcome.png", p7, width = 10, height = 5, dpi = 300, bg = "white")

# ==================================================
# KEY INSIGHTS SUMMARY
# ==================================================
cat("\n================================================")
cat("\n  KEY FUNNEL INSIGHTS")
cat("\n================================================\n")

cat("1. Overall Conversion Rate:", conversion_rate, "%\n")
cat("2. Best Contact Method:", contact_funnel$contact[1], "-", contact_funnel$conversion_rate[1], "%\n")
cat("3. Best Job Segment:", job_funnel$job[1], "-", job_funnel$conversion_rate[1], "%\n")
cat("4. Best Age Group:", age_funnel$age_group[1], "-", age_funnel$conversion_rate[1], "%\n")
cat("5. Best Month:", month_funnel$month[1], "-", month_funnel$conversion_rate[1], "%\n")
cat("6. Previous Success Conversion:", poutcome_funnel$conversion_rate[poutcome_funnel$poutcome == "success"], "%\n")

cat("\nVisualizations saved to outputs/figures/\n")
cat("Tables saved to outputs/tables/\n")