# a

## Extended SQL

The following relational schema describes a system of PM 2.5 sensors displaced in a country. Each sensor may be used by an agency for measurements. The Measurement table records the number of measurements made for each agency, sensor, and date.

Sensor(<u>sensorId</u>, City, State)
Date(<u>dateId</u>, Date, Month, Semester, Year)
Agency(<u>agencyId</u>, Agency)
Measurement(<u>sensorId</u>, <u>dateId</u>, <u>agencyId</u>, numberOfMeasurements)

### Query 1

For the year 2020, separetely for each month, city and agency, compute:

- The total number of measurements made
- The fraction of measurements made with respect to the measurements made for the whole year in all cities, by all agencies
- The fraction of measurements made with respect to the maximum number of monthly measurements made by an agency for one of the cities in the same state as the current city

```sql
SELECT Month, City, Agency, SUM(numberOfMeasurements),
       SUM(numberOfMeasurements) / SUM(numberOfMeasurements) OVER(),
FROM Sensor s, Date d, Agency a, Measurement m
WHERE s.sensorId = m.sensorId AND
      d.dateId = m.dateId AND
      a.agencyId = m.agencyId AND
      Year = 2020
GROUP BY Month, City, Agency

```
