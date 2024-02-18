import random
import faker
from datetime import datetime, timedelta

fake = faker.Faker()

production_plants_header = ["PlantID", "City", "Country"]
robots_header = ["RID", "PlantID", "IP"]
failures_header = ["RID", "FailureTypeCode", "Date", "Time"]

# Generate ProductionPlants.txt
with open("ProductionPlants.csv", "w") as f:
    f.write(",".join(production_plants_header) + "\n")
    for i in range(1000):
        plant_id = f"PID{i+1}"
        city = fake.city()
        country = fake.country()
        f.write(f"{plant_id},{city},{country}\n")

# Generate Robots.txt
with open("Robots.csv", "w") as f:
    f.write(",".join(robots_header) + "\n")
    for i in range(15000):
        robot_id = f"RID{i+1}"
        plant_id = f"PID{random.randint(1, 1000)}"
        ip = fake.ipv4()
        f.write(f"{robot_id},{plant_id},{ip}\n")

# Generate Failures.txt
with open("Failures.csv", "w") as f:
    f.write(",".join(failures_header) + "\n")
    start_date = datetime.now() - timedelta(days=20 * 365)
    for i in range(15000):
        robot_id = f"RID{i+1}"
        failure_code = f"FCode{random.randint(1, 200)}"
        date = fake.date_between_dates(start_date, datetime.now())
        time = fake.time()
        f.write(f"{robot_id},{failure_code},{date},{time}\n")
