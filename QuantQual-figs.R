library(ggplot2)        # Pretty plots
theme_set(theme_bw(base_size = 19))   # Even prettier plots
png_width = 800
png_height = 500
library(patchwork)      # Put pretty plots together
#devtools::install_github("nicolash2/ggbrace")
library(ggbrace)        # Annotate a brace
library(dplyr)          # Data cleaning
library(palmerpenguins) # Data
penguins <- filter(palmerpenguins::penguins,
    !is.na(sex), !is.na(species), 
    !is.na(flipper_length_mm), !is.na(body_mass_g))
library(knitr)          # Pretty tables (kable() function)
library(broom)          # better linear model output
library(e1071)          # svm function
#library(devtools); install_github("vqv/ggbiplot")
library(ggbiplot)       # For pca plots
library(neuralnet)
library(here)           # Finding files

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
png(here("figs", "1-intro.png"), height = png_height, width = png_width)
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
png(here("figs", "2-center.png"), height = png_height, width = png_width)
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
png(here("figs", "3-slope.png"), height = png_height, width = png_width)
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
png(here("figs", "4-error.png"), height = png_height, width = png_width)
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
png(here("figs", "5-resid.png"), height = png_height, width = png_width)
ggplot(lm_flip) +
    aes(x = .fitted, y = .resid) + 
    geom_point() + 
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_smooth(colour = "forestgreen") +
    labs(y = "Residuals (errors)", x = "Fitted Values",
        title = "Residual Plot")
dev.off()




# Quantitative: The pattern
png(here("figs", "6-species.png"), height = png_height, width = png_width)
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
gg_pat2
dev.off()


# Classification: Binary Target
pengtoo <- filter(penguins, !is.na(sex), species == "Gentoo")
pengtoo %>% slice(1, 10, 28, 35, 46, 59) %>% 
    select(body_mass_g,                     # Target variable
        bill_length_mm, flipper_length_mm,  # Numerical features
        species, island, sex) %>%           # Categorical features
    kable(format = "pipe")

# Classification: Choosing between two options
cutoff <- 198
png(here("figs", "7-SVM.png"), height = png_height, width = png_width)
ggplot(penguins, 
        aes(x = flipper_length_mm, y = sex, colour = sex)) +
    geom_jitter(height = 0.25) +
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
    annotate("text", x = cutoff, y = 1, hjust = -0.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm >= cutoff & penguins$sex == "female"), 
        size = 10) +
    annotate("text", x = cutoff, y = 1, hjust = 1.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm < cutoff & penguins$sex == "female"), 
        size = 10) +
    annotate("text", x = cutoff, y = 2, hjust = 1.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm < cutoff & penguins$sex == "male"), 
        size = 10) +
    annotate("text", x = cutoff, y = 2, hjust = -0.2, vjust = 1.2,
        label = sum(penguins$flipper_length_mm >= cutoff & penguins$sex == "male"), 
        size = 10) +
    theme(legend.position = "none")
dev.off()

table(penguins$sex, penguins$flipper_length_mm >= 198) %>%
    kable()


# Classification: More dimensions!
svm_flip <- svm(factor(sex) ~ flipper_length_mm + body_mass_g, 
    data = pengtoo, scale = FALSE, kernel = "linear")
x <- as.matrix(pengtoo[, c("flipper_length_mm", "body_mass_g")])
beta <- drop(t(svm_flip$coefs) %*% x[svm_flip$index,])
beta0 <- svm_flip$rho
intercept <- beta0 / beta[2]
slope <- -beta[1] / beta[2]

png(here("figs", "8-SVM2.png"), height = png_height, width = png_width)
ggplot(pengtoo) +
    aes(x = flipper_length_mm, y = body_mass_g, colour = sex) +
    geom_point() +
    scale_colour_manual(values = c("forestgreen", "darkorchid")) +
    labs(x = "Flipper Length (mm)", y = "Body Mass (g)",
        title = "Above the line = male, below = female",
        colour = "Sex") +
    geom_abline(intercept = intercept, slope = slope)
dev.off()


png(here("figs", "9-SVM3.png"), height = png_height, width = png_width)
ggplot(penguins) +
    aes(x = flipper_length_mm, y = body_mass_g, colour = sex) +
    geom_point() +
    scale_colour_manual(values = c("forestgreen", "darkorchid")) +
    labs(x = "Flipper Length (mm)", y = "Body Mass (g)",
        title = "Above the line = male, below = female",
        colour = "Sex") +
    geom_abline(intercept = intercept, slope = slope)
dev.off()



svm_species <- svm(factor(species) ~ flipper_length_mm + body_mass_g, 
    data = penguins, 
    kernel = "linear")
species_coords <- expand.grid(
    flipper_length_mm = seq(
        from = floor(min(penguins$flipper_length_mm)),
        to = ceiling(max(penguins$flipper_length_mm)),
        length.out = 2^9
    ), 
    body_mass_g = seq(
        from = floor(min(penguins$body_mass_g)),
        to = ceiling(max(penguins$body_mass_g)),
        length.out = 2^9
    ) 
)
species_preds <- predict(svm_species, newdata = species_coords)
png(here("figs", "10-SVM4.png"), height = png_height, width = png_width)
ggplot() + 
    geom_tile(
        mapping = aes(x = species_coords$flipper_length_mm, 
            y = species_coords$body_mass_g,
            fill = species_preds),
        alpha = 0.7) +
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_mm,
            y = body_mass_g),
        size = 2) +
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_mm,
            y = body_mass_g,
            colour = species),
        show.legend = FALSE) +
    labs(x = "Flipper Lenght (mm)",
        y = "Body Mass (g)",
        fill = "Species",
        title = "Three class classification")
dev.off()



svm_species <- svm(factor(species) ~ flipper_length_mm + body_mass_g, 
    data = penguins, 
    kernel = "sigmoid")
species_coords <- expand.grid(
    flipper_length_mm = seq(
        from = floor(min(penguins$flipper_length_mm)),
        to = ceiling(max(penguins$flipper_length_mm)),
        length.out = 2^9
    ), 
    body_mass_g = seq(
        from = floor(min(penguins$body_mass_g)),
        to = ceiling(max(penguins$body_mass_g)),
        length.out = 2^9
    ) 
)
species_preds <- predict(svm_species, newdata = species_coords)
png(here("figs", "11-SVM5.png"), height = png_height, width = png_width)
ggplot() + 
    geom_tile(
        mapping = aes(x = species_coords$flipper_length_mm, 
            y = species_coords$body_mass_g,
            fill = species_preds),
        alpha = 0.7) +
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_mm,
            y = body_mass_g),
        size = 2) +
    geom_point(data = penguins,
        mapping = aes(x = flipper_length_mm,
            y = body_mass_g,
            colour = species),
        show.legend = FALSE) +
    labs(x = "Flipper Lenght (mm)",
        y = "Body Mass (g)",
        fill = "Species",
        title = "Three class classification")
dev.off()


ggplot(penguins) +
    aes(x = bill_length_mm, y = bill_depth_mm) +
    geom_point()


pca_peng <- prcomp(select(penguins, bill_length_mm, bill_depth_mm, flipper_length_mm),
    center = TRUE, scale = TRUE)
png(here::here("figs/12-PCA.png"), height = png_height, width = 1.5*png_width)
gg_raw <- ggplot(penguins, aes(x = bill_depth_mm, y = flipper_length_mm, colour = paste(species, sex, sep = " & "))) + 
    geom_point() +
    theme(legend.position = "none") +
    labs(title = "Without PCA (two features)",
        x = "Bill Depth (mm)",
        y = "Flipper Length (mm)")
gg_pca <- ggbiplot(pca_peng, ellipse = TRUE, groups = paste(penguins$species, penguins$sex, sep = " & ")) +
    labs(colour = "Species & Sex",
        title = "PCA (two combinations of three features)", 
        x = "First Principal Component",
        y = "Second Principal Component")
gg_raw + gg_pca + 
    plot_layout(guides = "collect", width = c(0.75, 1.5))
dev.off()


# Neural Net
peng2 <- penguins %>%
    select(body_mass_g, flipper_length_mm, bill_depth_mm) %>%
    mutate(body_mass_g = scale(body_mass_g),
        flipper_length_mm = scale(flipper_length_mm),
        bill_depth_mm = scale(bill_depth_mm))
nn_peng <- neuralnet(body_mass_g ~ flipper_length_mm + bill_depth_mm, 
    data = peng2,
    hidden = 5)
png(here::here("figs/NN.png"), height = 0.5*png_height, width = 0.5*png_width)
plot(nn_peng, rep = "best")
dev.off()

peng_nn <- peng2
nn_pred <- neuralnet::compute(nn_peng, 
    peng2[, c("flipper_length_mm", "bill_depth_mm")])
peng_nn$pred <- nn_pred$net.result
peng_nn$model = "Neural Net"
peng_lm <- peng2
peng_lm$pred <- predict(
    lm(body_mass_g ~ flipper_length_mm + bill_depth_mm,
        data = peng2), 
    newdata = peng2[, c("flipper_length_mm", "bill_depth_mm")]
    )
peng_lm$model <- "Linear Model"
peng3 <- bind_rows(peng_nn, peng_lm)
png(here::here("figs/NNLM.png"), height = png_height, width = 1.5*png_width)
ggplot(peng3) +
    aes(x = body_mass_g, y = pred,
        colour = model) +
    geom_point() +
    labs(x = "True Value", y = "Predicted Value",
        colour = NULL)
dev.off()


kmean_peng <- kmeans(penguins[, c("bill_length_mm", "flipper_length_mm")],
    centers = 3, nstart = 25)
ggplot() +
        geom_point(
            mapping = aes(x = penguins$flipper_length_mm, y = penguins$bill_length_mm,
            colour = factor(kmean_peng$cluster))
        ) + 
        geom_point(
            mapping = aes(x = kmean_peng$centers[, 2], y = kmean_peng$centers[, 1],
                colour = factor(1:3)),
            size = 8, shape = 23, fill = "lightgrey", alpha = 0.5) +
        labs(x = "Flipper Length (mm)", y = "Bill Length (mm)",
            colour = "Class")
# 1 cluseter, 2 clusters, 3 clusters, etc.
kmeans_list <- list()
for(i in 1:6) {
    kmean_peng <- kmeans(penguins[, c("bill_length_mm", "flipper_length_mm")],
        centers = i, nstart = 25)
    if(i == 1){
        kdf <- data.frame(bill = penguins$bill_length_mm,
            flipper = penguins$flipper_length_mm,
            class = kmean_peng$cluster,
            nclust = i)
    } else {
        kdf <- bind_rows(kdf, data.frame(bill = penguins$bill_length_mm,
            flipper = penguins$flipper_length_mm,
            class = kmean_peng$cluster,
            nclust = i))
    }
}
png(here::here("figs/kmeans.png"), height = png_height, width = 1.5*png_width)
ggplot(kdf, aes(x = flipper, y = bill, colour = factor(class))) +
    geom_point() +
    facet_wrap(~ nclust) +
        labs(x = "Flipper Length (mm)", y = "Bill Length (mm)",
            colour = "Class") +
    theme(legend.position = "none")
dev.off()
