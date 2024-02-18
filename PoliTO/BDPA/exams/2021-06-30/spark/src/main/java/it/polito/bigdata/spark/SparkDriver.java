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
      .appName("exam_2021-06-30 spark")
      .master("local")
      .getOrCreate();

    Dataset<Row> bikeModels = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[0]);

    Dataset<Row> sales = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[1]);

    sales = sales.withColumn("Date", to_date(sales.col("Date"), "yyyy/MM/dd"));

    sales.printSchema();
    bikeModels.printSchema();

    // Motorbike models with a “large” variation in terms of sale price in the
    // year 2020. The application considers only the European sales (EU=“T”)
    // related to the year 2020 and selects the motorbike models with a sale
    // price variation greater than 5000 euro. For each motorbike model, its
    // sale price variation in the year 2020 is given by the difference between
    // the maximum sale price of all sales related to that motorbike model in
    // the year 2020 and the minimum sale price of all sales related to the same
    // motorbike model in the year 2020. The identifiers (ModelIDs) of the
    // selected motorbike models are stored in the first HDFS output folder
    // (one ModelID of the selected motorbike models per line).

    Dataset<Row> euSales = sales.filter(col("EU").equalTo("T"));
    Dataset<Row> euSales2020 = euSales.filter(year(col("Date")).equalTo(2020));

    Dataset<Row> modelsWithSalePriceVariation = euSales2020
      .groupBy("ModelID")
      .agg(max(col("Price")).as("MaxPrice"), min(col("Price")).as("MinPrice"))
      .withColumn("SalePriceVariation", col("MaxPrice").minus(col("MinPrice")));

    Dataset<Row> res1 = modelsWithSalePriceVariation
      .filter("SalePriceVariation > 5000")
      .select("ModelID");
    res1.write().csv(args[2]);

    // Manufacturers with many unsold or infrequently sold models. The
    // application considers all sales and selects the manufacturers that are
    // associated with many unsold or infrequently sold models. A motorbike
    // model is categorized as an unsold model if it has never been sold.
    // A motorbike model is categorized as an infrequently sold model if it has
    // been sold at least one time but at most 10 times. Specifically, the
    // application selects a manufacturer if (globally) at least 15 of its
    // models are unsold or infrequently sold models. The manufactures that
    // satisfy the reported constraint are stored in the second output folder.
    // For each of the selected manufactures, the following information
    // is stored in the second output folder: manufacturer, number of unsold
    // models+number of infrequently sold models (one of the selected
    // manufactures and the associated information per output line).

    Dataset<Row> unsoldModels = bikeModels
      .join(sales, "ModelID", "left_anti")
      .select("ModelID");

    Dataset<Row> infrequentlySoldModels = sales
      .groupBy("ModelID")
      .agg(count("*").as("TotSales"))
      .filter("TotSales <= 10")
      .select("ModelID");

    Dataset<Row> unsoldOrInfreqeuntlySoldModels = unsoldModels.union(
      infrequentlySoldModels
    );

    Dataset<Row> res2 = bikeModels
      .join(unsoldOrInfreqeuntlySoldModels, "ModelID")
      .groupBy("Manufacturer")
      .agg(count("*").as("NumUnsoldOrInfrequentlySold"))
      .filter("NumUnsoldOrInfrequentlySold >= 15");

    res2.write().csv(args[3]);

    ss.stop();
  }
}
