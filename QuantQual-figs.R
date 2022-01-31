library(ggplot2)        # Pretty plots
theme_set(theme_bw())   # Even prettier plots
library(patchwork)      # Put pretty plots together
library(dplyr)          # Data cleaning
library(here)           # Finding files
library(palmerpenguins) # Data
library(knitr)          # Pretty tables (kable() function)




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
        label = "Flipper Length\n increases by 1") +
    annotate("text", 
        x = 191, y = mean(y_pred),
        label = " Body mass\nincreases by 49.7\n (the slope)",
        hjust = -0.1, vjust = 0.5)
gg_flip
dev.off()








