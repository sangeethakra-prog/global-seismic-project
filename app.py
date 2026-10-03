import streamlit as st
import pandas as pd
from sqlalchemy import create_engine

st.set_page_config(
    page_title="Global Seismic Trends",
    page_icon="🌍",
    layout="wide"
)

st.title("🌍 Global Seismic Trends")
st.subheader("Data-Driven Earthquake Insights")
st.set_page_config(
    page_title="Global Seismic Trends",
    page_icon="🌍",
    layout="wide"
)

# Sidebar

st.sidebar.title("🌍 Global Seismic Trends")

st.sidebar.write(
    """
    ### About this Project

    This dashboard analyzes global earthquake
    activity using data collected from the USGS API.

    **Technologies Used:**
    - Python
    - Pandas
    - MySQL
    - SQL
    - Streamlit

    **Analysis Includes:**
    - Magnitude
    - Depth
    - Year and month trends
    - Tsunami events
    - Alert levels
    - Earthquake locations
    """
)

# MySQL connection
engine = create_engine(
    "mysql+pymysql://root:Aathiran@localhost/seismic_project"
)

# Load earthquake data
df = pd.read_sql(
    "SELECT * FROM earthquakes",
    engine
)

st.success("Earthquake data loaded successfully!")

# Display data
st.header("📊 Earthquake Data")

st.dataframe(
    df.head(20),
    use_container_width=True
)
# Earthquakes by year

st.header("📈 Earthquakes by Year")

yearly_count = df.groupby("year").size().reset_index(name="total_earthquakes")

st.bar_chart(
    yearly_count.set_index("year")
)
# Magnitude Distribution

st.header("📊 Earthquake Magnitude Distribution")

st.bar_chart(
    df["mag"].value_counts().sort_index()
)
# Earthquakes by Depth Category

st.header("🌍 Earthquakes by Depth Category")

depth_count = df["depth_category"].value_counts()

st.bar_chart(depth_count)
# Tsunami vs Non-Tsunami

st.header("🌊 Tsunami vs Non-Tsunami Earthquakes")

tsunami_count = df["tsunami"].map({
    0: "No Tsunami",
    1: "Tsunami"
}).value_counts()

st.bar_chart(tsunami_count)
# Earthquakes by Alert Level

st.header("🚨 Earthquakes by Alert Level")

alert_count = df["alert"].value_counts()

st.bar_chart(alert_count)
# Earthquake Location Map

# Year Filter

st.header("📅 Filter Earthquakes by Year")

years = sorted(df["year"].dropna().unique())

selected_year = st.selectbox(
    "Select Year",
    years
)

filtered_df = df[df["year"] == selected_year]

st.write(
    f"Showing {len(filtered_df):,} earthquakes for {selected_year}"
)


# Filtered Earthquake Map

st.subheader("🗺️ Earthquake Locations")

map_data = filtered_df[["latitude", "longitude"]].dropna()

st.map(map_data)
# Average Magnitude by Year

st.header("📈 Average Magnitude by Year")

avg_mag_year = (
    df.groupby("year")["mag"]
    .mean()
    .reset_index()
)

avg_mag_year["mag"] = avg_mag_year["mag"].round(2)

st.line_chart(
    avg_mag_year.set_index("year")
)
# Earthquakes by Month

st.header("📅 Earthquakes by Month")

monthly_count = (
    df.groupby(["month", "month_name"])
    .size()
    .reset_index(name="total_earthquakes")
    .sort_values("month")
)

st.bar_chart(
    monthly_count.set_index("month_name")["total_earthquakes"]
)
# Earthquakes by Status

st.header("🔍 Earthquakes by Status")

status_count = df["status"].value_counts()

st.bar_chart(status_count)
# Earthquakes by Type

st.header("🌋 Earthquakes by Type")

type_count = df["type"].value_counts()

st.bar_chart(type_count)
# Top 10 Strongest Earthquakes

st.header("🔥 Top 10 Strongest Earthquakes")

top_10 = (
    df[["id", "time", "place", "mag", "depth_km"]]
    .dropna(subset=["mag"])
    .sort_values("mag", ascending=False)
    .head(10)
)

st.dataframe(
    top_10,
    width="stretch"
)

# Earthquakes by Country

st.header("🌎 Earthquakes by Country")

country_count = (
    df["country"]
    .value_counts()
    .head(10)
)

st.bar_chart(country_count)
# Download Earthquake Data

st.header("📥 Download Earthquake Data")

csv_data = df.to_csv(index=False)

st.download_button(
    label="Download CSV",
    data=csv_data,
    file_name="earthquake_data.csv",
    mime="text/csv"
)
# Project Insights

st.header("📌 Project Insights")

st.write("""
### Key Insights

- The dashboard shows the total number of earthquake events
  recorded in the selected dataset.
- Earthquake activity can be analyzed by year and month.
- Earthquakes are categorized into Shallow, Intermediate,
  and Deep based on depth.
- Magnitude analysis helps identify stronger earthquake events.
- The tsunami flag identifies earthquake records marked by
  USGS as tsunami-related.
- Alert levels provide additional information about selected
  earthquake events.
- The map shows the geographical distribution of earthquake
  locations.

### Project Conclusion

This project demonstrates how Python, Pandas, SQL, MySQL,
and Streamlit can be combined to collect, clean, store,
analyze, and visualize earthquake data.
""")
total_earthquakes = len(df)
max_magnitude = df["mag"].max()
avg_magnitude = df["mag"].mean()
max_depth = df["depth_km"].max()

col1, col2, col3, col4 = st.columns(4)

col1.metric("🌎 Total Earthquakes", total_earthquakes)
col2.metric("📈 Maximum Magnitude", round(max_magnitude, 2))
col3.metric("📊 Average Magnitude", round(avg_magnitude, 2))
col4.metric("⬇️ Maximum Depth (km)", round(max_depth, 2))