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
      .appName("exam_2021-02-05 spark")
      .master("local")
      .getOrCreate();

    Dataset<Row> failures = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[0]);

    Dataset<Row> productionPlants = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[1]);

    Dataset<Row> robots = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[2]);

    failures.printSchema();
    productionPlants.printSchema();
    robots.printSchema();

    // Production plants with at least one robot with at least 50 failures in
    // year 2020. The application considers only the failures occurred in year
    // 2020 and selects the identifiers (PlantIDs) of the production plants with
    // at least one robot associated with at least 50 failures in year 2020.
    // The PlantIDs of the selected production plants are stored in the first
    // HDFS output folder (one PlantID per line).

    Dataset<Row> failures2020 = failures.filter(
      year(col("Date")).equalTo(2020)
    );

    Dataset<Row> robotsWithNumFailures = failures2020
      .groupBy("RID")
      .agg(count("*").as("NumFailures"))
      .cache();

    Dataset<Row> badRobots = robotsWithNumFailures.filter("NumFailures >= 50");

    Dataset<Row> res1 = robots.join(badRobots, "RID");

    res1.write().csv(args[3]);

    // For each production plant compute the number of robots with at least one
    // failure in year 2020. The application considers only the failures
    // occurred in year 2020 and computes for each production plant the number
    // of its robots associated with at least one failure in year 2020. The
    // application stores in the second HDFS output folder, for each production
    // plant, its PlantID and the computed number of robots with at least one
    // failure in year 2020. Pay attention that the output folder must contain
    // also one line for each of the production plants for which all robots had
    // no failures in year 2020. For those production plants the associated
    // output line is (PlantID, 0).

    Dataset<Row> plantsWithNumRobotsFailed = robots
      .join(robotsWithNumFailures, "RID")
      .groupBy("PlantID")
      .agg(count("RID").as("NumRobots"));

    Dataset<Row> res2 = robots
      .join(plantsWithNumRobotsFailed, "PlantID", "left")
      .withColumn(
        "NumRobots",
        coalesce(col("NumRobots"), lit(0).cast("integer"))
      )
      .select("PlantID", "NumRobots")
      .distinct();

    res2.write().csv(args[4]);

    ss.stop();
  }
}
