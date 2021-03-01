# Beispiel aus Artikel von towardsdatascience
# Hier wird px.chloropleth ohne mapbox genutzt, aber dafür Zeitreihen Animation erstellt die ich übernehmen möchte
# Artikel hierzu: https://towardsdatascience.com/interactive-covid-19-visualizations-using-plotly-with-4-lines-of-code-fa33b334ab84

import pandas as pd
import plotly.express as px

df = pd.read_csv('owid-covid-data.csv') # Kann hier runtergeladen werden: !wget https://covid.ourworldindata.org/data/owid-covid-data.csv

## Drop rows corresponding to the World (einfach weil csv da rows hat die nicht gebraucht werden)
df = df[df.location != 'World']
## Sort df by date
df = df.sort_values(by=['date'])

#print(df.dtypes)
#print(df.head())

fig = px.choropleth(df, locations="iso_code",
                    color="new_cases",
                    hover_name="location",
                    animation_frame="date", # Habe ich übernommen, weil ich auch Zeitreihen Animation haben will
                    title = "Daily new COVID cases",
                   color_continuous_scale=px.colors.sequential.PuRd)
fig["layout"].pop("updatemenus") # Habe ich übernommen, weil ich auch Zeitreihen Animation haben will
fig.show()