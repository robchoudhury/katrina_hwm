library(tidyverse)
library(sp)
library(viridis)
library(elevatr)

prj_dd <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs" #projection

examp_df <- data.frame(y = runif(10, min = 41, max = 45),
                       x = runif(10, min = -73, max = -71))

df_elev <- get_elev_point(examp_df, prj = prj_dd, src = "epqs")

hwm = read_csv("high_water_mark_usgs.csv") %>%
  filter(complete.cases(.)) %>%
  rename(x=long, y=lat)

lat_long_df = data.frame(x=hwm$x, 
                         y=hwm$y, 
                         id = hwm$id, 
                         hwm = hwm$elevation,
                         flood_type = hwm$flood_type)  %>% #it expects a true dataframe
##INEED TO UNCOMMENT THIS
get_elev_point(., prj = prj_dd, src = "epqs") %>% #took me ~1-2 minutes to access
as.data.frame(.) %>%
 mutate(ft = elevation * 3.28084,
        elev_diff = hwm-ft) #not sure if this makes sense

