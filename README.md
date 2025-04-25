# Coal Plant Exemptions

Code and analysis for TKTK.

## Overview

This project analyzes coal plants that have been exempted from certain regulations and how they intersect with disadvantaged communities identified by the Justice40 initiative.

## Data
- coal-plant-exemptions.csv: List of coal plants that received environmental exemptions.
- coal-plant-atlas.csv: National dataset of coal plant attributes. Source: EIA
- NEW_J40.geojson: Shapefile of Justice40 disadvantaged communities.
- justice_40/2.0-codebook.csv: Codebook describing Justice40 variables.

## Script
- analysis.R: Main R script that processes exemption data, performs spatial joins with Justice40 areas and prepares files for mapping and visualization.

## Output
These files are created by the scripts and used for visualizations:
- output/combined_df.csv: Final dataset combining coal plant data and exemption status to get correct locations for map.
- output/plant_buffers.shp: Shapefile of plant buffer zones for map.

## Visualization
Interactive map was created using MapLibre with Justice40 overlays and buffer zones around exempted coal plants.
- Static preview map: index.html
- Interactive map layers sourced from files in data/for-map/

## Contact
Please contact Taylor Johnston at taylor.johnston@cbsnews.com for any questions.
