package it.polito.bigdata.spark;

import static org.apache.spark.sql.functions.*;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;

public class SparkDriver {

  public static void main(String[] args) {
    BasicConfigurator.configure();

    // The following two lines are used to switch off some verbose log messages
    Logger.getLogger("org").setLevel(Level.OFF);
    Logger.getLogger("akka").setLevel(Level.OFF);

    SparkSession ss = SparkSession
      .builder()
      .appName("exam_2023-02-15 spark")
      .master("local")
      .getOrCreate();

    Dataset<Row> houses = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[0]);
    Dataset<Row> consumption = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[1]);

    // Countries without houses that are characterized by a high average daily
    // consumption in the year 2022. The first part of this application
    // considers only the year 2022 and selects the countries that are never
    // associated with houses with a high average daily consumption in the year
    // 2022. A house is considered a house with a high average daily consumption
    // in the year 2022 if the average daily consumption of that house in the
    // year 2022 is greater than 30 kWh. Store the selected countries in the
    // first HDFS output folder (one country per line).

    Dataset<Row> housesWithHighAvgConsumption2022 = consumption
      .filter(year(consumption.col("date")).equalTo(2022))
      .groupBy("id")
      .agg(avg("consumption").as("avg_consumption"))
      .filter("avg_consumption > 30")
      .select("id");

    Dataset<Row> res1 = houses.join(
      housesWithHighAvgConsumption2022,
      houses.col("id").equalTo(housesWithHighAvgConsumption2022.col("id")),
      "left_anti"
    );

    res1.select("country").distinct().write().csv(args[2]);

    // The number of cities with many houses with high power consumption in the
    // year 2021 for each country. This second part of the application considers
    // only the consumption in the year 2021 and computes for each country the
    // number of cities each one with at least 500 houses with high annual
    // consumption in the year 2021. Specifically, a house is classified as a
    // “house with a high annual consumption in the year 2021” if its annual
    // consumption in the year 2021 is greater than 10000 kWh. Store the result
    // in the second output folder (one country per output line). The output
    // format is “country,number of cities each one with at least 500 houses
    // with a high annual consumption in the year 2021 for that country”. Save
    // also the information for the countries with no cities with at least 500
    // houses with a high annual consumption in the year 2021. In those cases,
    // the output line will be “country,0”.

    Dataset<Row> housesWithHighCumConsumption2021 = consumption
      .filter(year(consumption.col("date")).equalTo(2021))
      .groupBy("id")
      .agg(sum("consumption").as("tot_consumption"))
      .filter("tot_consumption > 10000");

    Dataset<Row> citiesWithMoreThan500Houses = houses
      .join(housesWithHighCumConsumption2021, "id")
      .groupBy("city")
      .agg(count("*").as("num_houses"))
      .filter("num_houses >= 500");

    Dataset<Row> countriesWithNumCities = houses
      .join(citiesWithMoreThan500Houses, "city")
      .groupBy("country")
      .agg(countDistinct("city").as("num_cities"));

    Dataset<Row> res2 = houses
      .join(countriesWithNumCities, "country", "left")
      .select(
        houses.col("country"),
        coalesce(col("num_cities"), lit(0).cast("integer")).as("num_cities")
      );

    res2.distinct().write().csv(args[3]);

    ss.stop();
  }
}
