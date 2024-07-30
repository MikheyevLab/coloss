#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
library(sf)
library(ggplot2)
library(ggiraph)

# Load the shapefile
aus_shp <- suppressWarnings(suppressMessages(st_read("../STE_2021_AUST_GDA2020.shx")[1:8,])) # remove islands

# Simplify geometries with a lower tolerance and keep empty shapes
aus_shp_simplified <- st_simplify(aus_shp, dTolerance = 8000, preserveTopology = TRUE)

# Ensure geometries are valid
aus_shp_simplified <- st_make_valid(aus_shp_simplified)

# Remove empty geometries
aus_shp_simplified <- aus_shp_simplified[!st_is_empty(aus_shp_simplified), ]
# Generate random numbers between 1 and 100 for each state
set.seed(123)  # For reproducibility
aus_shp_simplified$`2024 colony losses` <- sample(1:20, nrow(aus_shp_simplified), replace = TRUE)

# Create ggplot object with interactive elements
p <- ggplot(aus_shp_simplified) +
  geom_sf_interactive(aes(fill = `2024 colony losses`, tooltip = `2024 colony losses`, data_id = `2024 colony losses`)) +
  scale_fill_viridis_c() +
  theme_minimal() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),   axis.text = element_blank())

# Render the interactive plot
girafe(
  ggobj = p,
  options = list(
    opts_hover(css = "fill:orange;"),
    opts_hover_inv(css = "opacity:0.5;"),
    opts_selection(type = "single", only_shiny = FALSE),
    opts_tooltip(css = "font-size: 20px;") 
  )
)

#
#
#
#
#
