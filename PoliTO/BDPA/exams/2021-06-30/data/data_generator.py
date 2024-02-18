import csv
import random
from faker import Faker
from datetime import datetime

fake = Faker()

# Define the headers
bike_models_header = ["ModelID", "MName", "Manufacturer"]
sales_header = ["SID", "BikeID", "ModelID", "Date", "Country", "Price", "EU"]

# Generate a list of unique countries
countries = [fake.country() for _ in range(200)]  # Adjust the range as needed

# Associate each country with a random True or False
country_eu_dict = {
    country: "T" if random.choice([True, False]) else "F" for country in countries
}

# Define the data
bike_models_data = [
    [f"Model{i}", fake.catch_phrase(), fake.company()] for i in range(1, 21)
]

start_date = datetime(2019, 1, 1)
end_date = datetime(2020, 12, 31)

sales_data = [
    [
        f"SID{i}",
        f"BikeID{i}",
        f"Model{random.randint(1, 20)}",
        fake.date_between(start_date=start_date, end_date=end_date).strftime(
            "%Y/%m/%d"
        ),
        country,
        random.randint(1000, 10000),
        country_eu_dict[country],
    ]
    for i, country in zip(range(1, 2000001), random.choices(countries, k=1000000))
]

# Write data to BikeModels.csv
with open("BikeModels.csv", "w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(bike_models_header)
    writer.writerows(bike_models_data)

# Write data to Sales.csv
with open("Sales.csv", "w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(sales_header)
    writer.writerows(sales_data)
