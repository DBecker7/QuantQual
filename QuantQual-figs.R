library(ggplot2)        # Pretty plots
theme_set(theme_bw())   # Even prettier plots
library(patchwork)      # Put pretty plots together
#devtools::install_github("nicolash2/ggbrace")
library(ggbrace)        # Annotate a brace
library(dplyr)          # Data cleaning
library(here)           # Finding files
library(palmerpenguins) # Data
library(knitr)          # Pretty tables (kable() function)
library(broom)          # better linear model output
library(e1071)



# Quantitative - Regression 
penguins %>% 
    select(body_mass_g,                     # Target variable
        bill_length_mm, flipper_length_mm,  # Numerical features
        species, island, sex) %>%           # Categorical features
    slice(c(1,26,169,172,281, 284,323)) %>% # Grab a few for demonstration
    kable(format = "pipe")                  # Pretty table




# Quantitative - Intro to linear models
lm_flip <- lm(body_mass_g ~ flipper_length_mm, data = penguins)
x_flip <- seq(170, 235, by = 5)
y_flip <- predict(lm_flip, newdata = list(flipper_length_mm = x_flip))
png(here("figs", "1-intro.png"), height = 300, width = 600)
gg_flip <- ggplot() + 
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
    geom_line(mapping = aes(x = x_flip, y = y_flip), colour = "forestgreen") +
    labs(x = "Flipper Length (mm)", y = "Body Mass (g)",
        title = "Target versus Flipper Length")
gg_flip
dev.off()




# Quantitative - A **Mean**ingful intercept
penguins$flipper_length_centered <- penguins$flipper_length_mm - 
    mean(penguins$flipper_length_mm, na.rm = TRUE)
lm_flip <- lm(body_mass_g ~ flipper_length_centered, data = penguins)
x_flip <- seq(170, 235, by = 5) - mean(penguins$flipper_length_mm, na.rm = TRUE)
y_flip <- predict(lm_flip, newdata = list(flipper_length_centered = x_flip))
png(here("figs", "2-center.png"), height = 300, width = 600)
gg_flip <- ggplot() + 
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_centered, y = body_mass_g)) +
    geom_line(mapping = aes(x = x_flip, y = y_flip), colour = "forestgreen") +
    labs(x = "Flipper Length (mm, mean-centered)", y = "Body Mass (g)",
        title = "Target versus Flipper Length")
gg_flip
dev.off()




# Quantitative - Linear models: slopes
lm_flip <- lm(body_mass_g ~ flipper_length_mm, data = penguins)
coef(lm_flip)
x_flip <- seq(170, 235, by = 5)
y_flip <- predict(lm_flip, newdata = list(flipper_length_mm = x_flip))
x_pred <- c(190, 191)
y_pred <- predict(lm_flip, newdata = list(flipper_length_mm = x_pred))
png(here("figs", "3-slope.png"), height = 300, width = 600)
gg_flip <- ggplot() + 
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
    geom_line(mapping = aes(x = x_flip, y = y_flip), colour = "forestgreen") +
    labs(x = "Flipper Length (mm)", y = "Body Mass (g)",
        title = "Target versus Flipper Length") +
    coord_cartesian(xlim = c(189.75, 191.5), ylim = c(3645, 3720)) +
    annotate("segment", 
        x = x_pred, y = rep(y_pred[1], 2),
        xend = rep(x_pred[2], 2), yend = y_pred,
        arrow = arrow()) +
    annotate("text", 
        x = 190.5, y = 3650,
        label = "Flipper Length\nincreases by 1") +
    annotate("text", 
        x = 191, y = mean(y_pred),
        label = " Body mass\nincreases by 49.7\n (the slope)",
        hjust = -0.1, vjust = 0.5)
gg_flip
dev.off()




# Quantitative - The most important part!
x_true <- penguins$flipper_length_mm[43]
y_true <- penguins$body_mass_g[43]
lm_flip <- lm(body_mass_g ~ flipper_length_mm, data = penguins)
y_pred <- predict(lm_flip, newdata = list(flipper_length_mm = x_true))
png(here("figs", "4-error.png"), height = 300, width = 600)
ggplot() + 
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
    geom_smooth(data = penguins,
        mapping = aes(x = flipper_length_mm, y = body_mass_g),
        method = lm, formula = y~x, colour = "forestgreen", se = FALSE) +
    labs(x = "Flipper Length (mm)", y = "Body Mass (g)",
        title = "Target versus Flipper Length") +
    annotate("segment", x = x_true, y = y_true,
        xend = x_true, yend = y_pred,
        colour = 1, size = 4) +
    geom_point(mapping = aes(x = x_true, y = y_true),
        colour = 1, size = 10) +
    annotate("segment", x = x_true, y = y_true,
        xend = x_true, yend = y_pred,
        colour = "forestgreen", size = 2) +
    geom_point(mapping = aes(x = x_true, y = y_true),
        colour = "forestgreen", size = 8) +
    geom_brace(aes(c(x_true + 1, x_true + 5), c(y_pred, y_true)), 
        inherit.data = F, rotate = 90, size = 1.5, colour = 1) +
    geom_brace(aes(c(x_true + 1, x_true + 5), c(y_pred, y_true)), 
        inherit.data = F, rotate = 90, size = 1, colour = "firebrick") +
    annotate("text", x = 191, y = mean(c(y_true, y_pred)), 
        hjust = -0.1, yjust = 0.5, size = 13, colour = "firebrick",
        label = "Error") + 
    coord_cartesian(xlim = c(170, 200), ylim = c(3000, 4200))
dev.off()




# Quantitative - Residual plots: residuals versus predicted
lm_flip <- augment(lm_flip)
png(here("figs", "5-resid.png"), height = 300, width = 600)
ggplot(lm_flip) +
    aes(x = .fitted, y = .resid) + 
    geom_point() + 
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_smooth(colour = "forestgreen") +
    labs(y = "Residuals (errors)", x = "Fitted Values",
        title = "Residual Plot")
dev.off()




# Quantitative: The pattern
png(here("figs", "6-species.png"), height = 300, width = 600)
gg_pat1 <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = "y~x", se = FALSE) +
    labs(y = "Body Mass (G)", x = "Flipper Length (mm)",
        title = "Target versus Flipper Length", colour = "Species")
gg_pat2 <- ggplot(lm_flip, aes(x = .fitted, y = .resid, 
        colour = penguins$species[!is.na(penguins$flipper_length_mm)])) +
    geom_point() +
    geom_smooth(method = "lm", formula = "y~x", se = FALSE) +
    labs(y = "Residuals (errors)", x = "Fitted Values",
        title = "Residual Plot", colour = "Species")
gg_pat1 + gg_pat2 + plot_layout(guides = "collect")
dev.off()


# Classification: Binary Target
pengtoo <- filter(penguins, !is.na(sex), species == "Gentoo")
pengtoo %>% slice(1:7) %>% 
    kable(format = "pipe")

# Classification: Choosing between two options
cutoff <- 198
png(here("figs", "7-SVM.png"), height = 300, width = 600)
ggplot(penguins, 
        aes(x = flipper_length_mm, y = sex, colour = sex)) +
    geom_jitter() +
    scale_colour_manual(values = c("forestgreen", "darkorchid")) +
    labs(x = "Flipper Length (mm)", y = "Sex",
        colour = "Sex", 
        title = "Which value of Flipper Length best splits Biosex?") + 
    annotate("segment", x = cutoff, xend = cutoff, y = -Inf, yend = Inf) +
    annotate("segment", x = cutoff, y = 1, yend = 1, 
        xend = max(penguins$flipper_length_mm[penguins$sex == "female"],
            na.rm = TRUE),  
        colour = "forestgreen", arrow = arrow()) +
    annotate("segment", x = cutoff, y = 1, yend = 1, 
        xend = min(penguins$flipper_length_mm[penguins$sex == "female"],
            na.rm = TRUE),  
        colour = "forestgreen", arrow = arrow()) +
    annotate("segment", x = cutoff, y = 2, yend = 2,
        xend = max(penguins$flipper_length_mm[penguins$sex == "male"],
            na.rm = TRUE), 
        colour = "darkorchid", arrow = arrow()) +
    annotate("segment", x = cutoff, y = 2, yend = 2,
        xend = min(penguins$flipper_length_mm[penguins$sex == "male"],
            na.rm = TRUE),  
        colour = "darkorchid", arrow = arrow()) +
    annotate("text", x = cutoff, y = 1, hjust = 1.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm >= cutoff & penguins$sex == "male"), size = 10) +
    annotate("text", x = cutoff, y = 1, hjust = -0.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm < cutoff & penguins$sex == "male"), size = 10) +
    annotate("text", x = cutoff, y = 2, hjust = -0.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm < cutoff & penguins$sex == "female"), size = 10) +
    annotate("text", x = cutoff, y = 2, hjust = 1.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm >= cutoff & penguins$sex == "female"), size = 10)
dev.off()


# Classification: More dimensions!
svm_flip <- svm(factor(sex) ~ flipper_length_mm + body_mass_g, 
    data = pengtoo, scale = FALSE, kernel = "linear")
x <- as.matrix(pengtoo[, c("flipper_length_mm", "body_mass_g")])
beta <- drop(t(svm_flip$coefs) %*% x[svm_flip$index,])
beta0 <- svm_flip$rho
intercept <- beta0 / beta[2]
slope <- -beta[1] / beta[2]

png(here("figs", "8-SVM2.png"), height = 300, width = 600)
ggplot(pengtoo) +
    aes(x = flipper_length_mm, y = body_mass_g, colour = sex) +
    geom_point() +
    scale_colour_manual(values = c("forestgreen", "darkorchid")) +
    labs(x = "Flipper Length (mm)", y = "Body Mass (g)",
        title = "Above the line = male, below = female",
        colour = "Sex") +
    geom_abline(intercept = intercept, slope = slope)
dev.off()


png(here("figs", "9-SVM3.png"), height = 300, width = 600)
ggplot(penguins) +
    aes(x = flipper_length_mm, y = body_mass_g, colour = sex) +
    geom_point() +
    scale_colour_manual(values = c("forestgreen", "darkorchid")) +
    labs(x = "Flipper Length (mm)", y = "Body Mass (g)",
        title = "Above the line = male, below = female",
        colour = "Sex") +
    geom_abline(intercept = intercept, slope = slope)
dev.off()