# Load necessary libraries
library(dplyr)
library(sf)
library(janitor)

# Read in coal plant names
coal_plants <- read.csv("data/coal-plant-exemptions.csv") %>% 
  clean_names() %>% 
  select(plant_name, facility_source_affected)

# Read in power plant atlas data
atlas <- read.csv("data/coal-plant-atlas.csv") %>% 
  clean_names()

# Combine to get location
combined_df <- left_join(coal_plants, atlas, by = "plant_name") %>% 
  select(facility_source_affected, plant_name, utility_name, street_address, city, state, zip, prim_source, latitude, longitude)

write.csv(combined_df, "output/combined_df.csv")


# Convert combined_df to sf and reproject to a CRS with meters
combined_df_sf <- st_as_sf(combined_df,
                           coords = c("longitude", "latitude"),
                           crs = 4326)

combined_df_sf_proj <- st_transform(combined_df_sf, 3857)  # Use a projected CRS for distance

# Buffer each plant location by 3 miles (~4828 meters)
plant_buffers <- st_buffer(combined_df_sf_proj, dist = 4828)

# Read and filter the Justice40 shapefile
justice_40_data <- st_read("data/justice_40/usa/usa.shp")

st_write(plant_buffers, "output/plant_buffers.shp")


justice_40_data <- justice_40_data %>%
  filter(SN_C == 1) %>%
  select(SF, SN_C)

# Count tracts by SN_C status (1 = disadvantaged, 0 = not)
tract_counts <- justice_40_data %>%
  st_drop_geometry() %>%
  mutate(SN_C = case_when(
    SN_C == 1 ~ "Disadvantaged",
    SN_C == 0 ~ "Not Disadvantaged",
    TRUE ~ as.character(SN_C)
  )) %>%
  group_by(SN_C) %>%
  summarise(total = n())

# Reproject Justice40 tracts to match plant buffers
justice_40_proj <- st_transform(justice_40_data, 3857)

# Perform spatial join: check if buffer overlaps a disadvantaged tract
buffers_with_overlap <- st_join(plant_buffers, justice_40_proj, join = st_intersects)

# Count unique plant names that overlap with a disadvantaged tract
num_unique_plants_near_disadvantaged <- buffers_with_overlap %>%
  filter(!is.na(SN_C)) %>%
  distinct(plant_name) %>%
  nrow()

# View the corrected result
print(num_unique_plants_near_disadvantaged)