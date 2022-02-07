library(rgl)
library(palmerpenguins)

plot3d(x = penguins$flipper_length_mm, y = penguins$bill_length_mm, 
    z = penguins$bill_depth_mm, 
    col = as.numeric(factor(paste(penguins$species, penguins$sex, sep = " & "))))
