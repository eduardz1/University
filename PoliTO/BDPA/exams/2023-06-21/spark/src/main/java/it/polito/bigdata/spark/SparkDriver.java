// package it.polito.bigdata.spark;

// import static org.apache.spark.sql.functions.*;

// import org.apache.spark.api.java.JavaSparkContext;
// import org.apache.spark.sql.*;

// public class SparkDriver {

//   public static void main(String[] args) {
//     SparkSession spark = SparkSession
//       .builder()
//       .appName("MeetingStatistics")
//       .getOrCreate();
//     JavaSparkContext sc = new JavaSparkContext(spark.sparkContext());

//     // Load the data
//     Dataset<Row> users = spark.read().option("header", "true").csv(args[0]);
//     Dataset<Row> meetings = spark.read().option("header", "true").csv(args[1]);
//     Dataset<Row> invitations = spark
//       .read()
//       .option("header", "true")
//       .csv(args[2]);

//     // Filter for users with a Business pricing plan who organized at least one
//     // meeting
//     Dataset<Row> businessUsers = users.filter(
//       col("PricingPlan").equalTo("Business")
//     );
//     Dataset<Row> businessMeetings = meetings.join(
//       businessUsers,
//       meetings.col("OrganizerUID").equalTo(businessUsers.col("UID"))
//     );

//     // Group by user ID and calculate statistics
//     Dataset<Row> result1 = businessMeetings
//       .groupBy("UID")
//       .agg(
//         avg("Duration").as("AverageDuration"),
//         max("Duration").as("MaxDuration"),
//         min("Duration").as("MinDuration")
//       );

//     // Store the result to HDFS
//     result1.write().csv(args[3]);

//     // Calculate the distribution of the number of invitations per organized
//     // meeting
//     Dataset<Row> invitationCounts = invitations.groupBy("MID").count();
//     Dataset<Row> meetingsWithCounts = businessMeetings.join(
//       invitationCounts,
//       businessMeetings.col("MID").equalTo(invitationCounts.col("MID"))
//     );

//     // Classify meetings by size
//     Dataset<Row> result2 = meetingsWithCounts.withColumn(
//       "MeetingSize",
//       when(col("count").gt(20), "large")
//         .when(col("count").between(5, 20), "medium")
//         .otherwise("small")
//     );

//     // Count the number of each size of meeting per user
//     result2 = result2.groupBy("UID", "MeetingSize").count();

//     // Store result to HDFS
//     result2.write().csv(args[4]);

//     sc.close();
//   }
// }

import static org.apache.spark.sql.functions.*;

import org.apache.spark.sql.*;
import org.apache.spark.sql.expressions.Window;
import org.apache.spark.sql.expressions.WindowSpec;

public class HouseWaterConsumption {

  public static void main(String[] args) {
    SparkSession spark = SparkSession
      .builder()
      .appName("HouseWaterConsumption")
      .getOrCreate();

    // Read the input files
    Dataset<Row> houses = spark
      .read()
      .format("csv")
      .option("header", "false")
      .load(args[0]);
    houses =
      houses.withColumnRenamed("_c0", "HID").withColumnRenamed("_c1", "City");

    Dataset<Row> consumption = spark
      .read()
      .format("csv")
      .option("header", "false")
      .load(args[1]);
    consumption =
      consumption
        .withColumnRenamed("_c0", "HID")
        .withColumnRenamed("_c1", "Date")
        .withColumnRenamed("_c2", "M3");

    // Calculate the water consumption per trimester for each house for the years 2021 and 2022
    consumption =
      consumption
        .withColumn("Year", year(to_date(col("Date"), "yyyy/MM")))
        .withColumn("Trimester", quarter(to_date(col("Date"), "yyyy/MM")))
        .groupBy("HID", "Year", "Trimester")
        .agg(sum("M3").alias("M3"));

    WindowSpec windowSpec = Window
      .partitionBy("HID", "Trimester")
      .orderBy("Year");
    consumption =
      consumption
        .withColumn("PrevM3", lag("M3", 1).over(windowSpec))
        .withColumn(
          "Increased",
          when(col("M3").gt(col("PrevM3")), 1).otherwise(0)
        );

    // Count the number of trimesters with increased consumption in 2022
    Dataset<Row> increasedConsumption = consumption
      .filter("Year = 2022")
      .groupBy("HID")
      .agg(sum("Increased").alias("CountIncreased"));

    // Filter the houses that have an increased consumption in at least three trimesters in 2022
    Dataset<Row> selectedHouses = increasedConsumption.filter(
      "CountIncreased >= 3"
    );

    // Join with the houses DataFrame and save the result to the first HDFS output folder
    Dataset<Row> result = houses
      .join(selectedHouses, "HID")
      .select("HID", "City");
    result.write().format("csv").save(args[2]);

    // Calculate the annual water consumption for each house
    Dataset<Row> annualConsumption = consumption
      .groupBy("HID", "Year")
      .agg(sum("M3").alias("AnnualM3"));

    WindowSpec windowSpec2 = Window.partitionBy("HID").orderBy("Year");
    annualConsumption =
      annualConsumption
        .withColumn("PrevAnnualM3", lag("AnnualM3", 1).over(windowSpec2))
        .withColumn(
          "Decreased",
          when(col("AnnualM3").lt(col("PrevAnnualM3")), 1).otherwise(0)
        );

    // Count the number of houses with at least one annual consumption decrease for each city
    Dataset<Row> decreasedConsumption = annualConsumption
      .filter("Decreased = 1")
      .groupBy("HID")
      .agg(count("Decreased").alias("CountDecreased"));
    Dataset<Row> housesWithDecreasedConsumption = houses.join(
      decreasedConsumption,
      "HID"
    );
    Dataset<Row> countDecreased = housesWithDecreasedConsumption
      .groupBy("City")
      .agg(count("HID").alias("CountHouses"));

    // Filter the cities with at most 2 houses with at least one annual consumption decrease
    Dataset<Row> selectedCities = countDecreased.filter("CountHouses <= 2");

    // Save the result to the second HDFS output folder
    selectedCities.select("City").write().format("csv").save(args[3]);

    spark.stop();
  }
}
