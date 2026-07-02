# ==================================================
# FUTURE_DS_03
# Statistical Analysis - Logistic Regression
# ==================================================

library(tidyverse)
library(scales)
library(broom)

# Load cleaned data
bank <- read.csv("data/cleaned/bank_marketing_clean.csv")
bank <- bank %>% mutate(across(where(is.character), as.factor))

cat("\n================================================")
cat("\n  STATISTICAL ANALYSIS - CONVERSION DRIVERS")
cat("\n================================================\n")

# ==================================================
# 1. LOGISTIC REGRESSION MODEL
# ==================================================
cat("\n==================== LOGISTIC REGRESSION ====================\n")
cat("Model: Conversion ~ Contact + Job + Age + Duration + Month + Previous\n\n")

# Build model
logit_model <- glm(y ~ contact + job + age_group + duration_group + 
                     month + poutcome + education + housing + loan,
                   data = bank, family = "binomial")

# Summary
model_summary <- summary(logit_model)
print(model_summary)

# ==================================================
# 2. ODDS RATIOS
# ==================================================
cat("\n==================== ODDS RATIOS ====================\n")

odds_ratios <- tidy(logit_model) %>%
  mutate(
    odds_ratio = round(exp(estimate), 3),
    p_value = format(p.value, scientific = TRUE, digits = 3),
    significant = ifelse(p.value < 0.05, "✅", "❌")
  ) %>%
  filter(term != "(Intercept)") %>%
  arrange(desc(abs(odds_ratio - 1)))

print(odds_ratios, n = 40)

# ==================================================
# 3. TOP PREDICTORS SUMMARY
# ==================================================
cat("\n==================== TOP CONVERSION DRIVERS ====================\n")

cat("\nFactors that INCREASE conversion (Odds Ratio > 1):\n")
odds_ratios %>%
  filter(significant == "✅", odds_ratio > 1) %>%
  head(10) %>%
  print(n = 10)

cat("\nFactors that DECREASE conversion (Odds Ratio < 1):\n")
odds_ratios %>%
  filter(significant == "✅", odds_ratio < 1) %>%
  head(10) %>%
  print(n = 10)

# ==================================================
# 4. MODEL PERFORMANCE
# ==================================================
cat("\n==================== MODEL PERFORMANCE ====================\n")

null_deviance <- logit_model$null.deviance
residual_deviance <- logit_model$deviance
pseudo_r2 <- 1 - (residual_deviance / null_deviance)

cat("Pseudo R-squared:", round(pseudo_r2, 4), "\n")
cat("AIC:", round(AIC(logit_model), 2), "\n")

# Confusion Matrix
bank$predicted_prob <- predict(logit_model, type = "response")
bank$predicted_y <- ifelse(bank$predicted_prob > 0.5, 1, 0)

confusion <- table(Actual = bank$y, Predicted = bank$predicted_y)
cat("\nConfusion Matrix:\n")
print(confusion)

accuracy <- sum(diag(confusion)) / sum(confusion)
sensitivity <- confusion[2,2] / sum(confusion[2,])
specificity <- confusion[1,1] / sum(confusion[1,])

cat("\nAccuracy:", round(accuracy * 100, 2), "%\n")
cat("Sensitivity:", round(sensitivity * 100, 2), "%\n")
cat("Specificity:", round(specificity * 100, 2), "%\n")

# ==================================================
# 5. SAVE RESULTS
# ==================================================
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
write.csv(odds_ratios, "outputs/tables/logistic_regression_odds.csv", row.names = FALSE)

# ==================================================
# 6. ODDS RATIOS FOREST PLOT
# ==================================================
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# Top 20 most impactful predictors
top20 <- odds_ratios %>%
  filter(term != "(Intercept)") %>%
  arrange(desc(odds_ratio)) %>%
  head(20)

forest_plot <- ggplot(top20, aes(x = odds_ratio, y = reorder(term, odds_ratio), color = significant)) +
  geom_point(size = 3.5) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "gray40", linewidth = 0.8) +
  geom_segment(aes(x = 1, xend = odds_ratio, y = term, yend = term), linewidth = 1.2) +
  scale_color_manual(values = c("✅" = "#e74c3c", "❌" = "gray60"), guide = "none") +
  scale_x_log10(labels = comma) +
  labs(title = "Conversion Drivers: Odds Ratios",
       subtitle = "Values > 1 increase conversion | Values < 1 decrease conversion",
       x = "Odds Ratio (log scale)", y = NULL,
       caption = "Logistic Regression Results") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold", size = 14, color = "#2c3e50"),
        plot.subtitle = element_text(size = 10, color = "#7f8c8d"),
        axis.text.y = element_text(size = 8),
        panel.grid.minor = element_blank())

ggsave("outputs/figures/odds_ratios_forest.png", forest_plot, width = 12, height = 8, dpi = 300, bg = "white")

# ==================================================
# FINAL SUMMARY
# ==================================================
cat("\n\n================================================")
cat("\n  STATISTICAL ANALYSIS COMPLETE")
cat("\n================================================\n")
cat("Pseudo R-squared:", round(pseudo_r2, 4), "\n")
cat("Model Accuracy:", round(accuracy * 100, 2), "%\n")
cat("Significant predictors:", sum(odds_ratios$significant == "✅"), "of", nrow(odds_ratios), "\n")
cat("\n✅ Results saved to outputs/\n")