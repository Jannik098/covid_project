import plotly.express as px

import json
with open ("kreise_nrw2.geojson") as response: #konvertiert json zu dict - json in github mit drin
    data = json.load(response)
    
#print(data["features"][0])

import pandas as pd

df15 = pd.read_csv("merged_data_new2.csv", dtype={"NUTS": str})

#df15 = df15.sort_values(by=['Datum'])
#print(df15.head())
#print(df15.dtypes)
#print(df15["NUTS"][2])
#print(data["features"][0]["properties"])

fig = px.choropleth_mapbox(df15, geojson=data, featureidkey="properties.NUTS", locations='NUTS', color='Prozentsatz Infizierte',
                           hover_name="Landkreis",
                           animation_frame="Datum",
                           color_continuous_scale="Viridis",
                           title = "Daily new COVID cases",
                           zoom=3, center = {"lat": 51.49974, "lon": 7.47628},
                           mapbox_style='open-street-map')
fig.show()

#print(df15.dtypes)