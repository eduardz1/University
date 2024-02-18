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
      .appName("exam_2022-02-21 spark")
      .master("local")
      .getOrCreate();

    Dataset<Row> customers = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[0]);

    Dataset<Row> itemsCatalog = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[1]);

    Dataset<Row> purchases = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[2]);

    customers =
      customers.withColumn(
        "DateOfBirth",
        to_date(customers.col("DateOfBirth"), "yyyy/MM/dd")
      );
    itemsCatalog =
      itemsCatalog.withColumn(
        "FirstTimeInCatalog",
        to_date(itemsCatalog.col("FirstTimeInCatalog"), "yyyy/MM/dd-HH:mm:ss")
      );
    purchases =
      purchases.withColumn(
        "SaleTimestamp",
        to_date(purchases.col("SaleTimestamp"), "yyyy/MM/dd-HH:mm:ss")
      );

    customers.printSchema();
    itemsCatalog.printSchema();
    purchases.printSchema();

    // Items purchased at least 10K times in 2020 and at least 10K times in
    // 2021. This first part of the application considers all the items included
    // in the catalog and selects the subset of items bought at least 10000
    // times in the year 2020 and at least 10000 times in the year 2021. Only
    // the subset of items that satisfy both conditions are selected. The
    // identifiers of the selected items are stored in the first HDFS output
    // folder (one ItemID per line).

    Dataset<Row> itemsPurchased10KTimes2020 = purchases
      .filter(year(purchases.col("SaleTimestamp")).equalTo(2020))
      .groupBy("ItemID")
      .agg(count("*").as("count"))
      .filter("count >= 10000");

    Dataset<Row> itemsPurchased10KTimes2021 = purchases
      .filter(year(purchases.col("SaleTimestamp")).equalTo(2021))
      .groupBy("ItemID")
      .agg(count("*").as("count"))
      .filter("count >= 10000");

    Dataset<Row> res1 = itemsPurchased10KTimes2020
      .join(itemsPurchased10KTimes2021, "ItemID")
      .select("ItemID");

    res1.write().csv(args[3]);

    // Items included in the catalog before the year 2020 with at least two
    // months in the year 2020 each one with less than 10 distinct customers.
    // This second part of the application considers only the items that were
    // included in the catalog before the year 2020
    // (i.e., the items with FirstTimeInCatalog<’2020/01/01’). Considering only
    // those items, an item is selected if it is characterized by at least two
    // months in the year 2020 such that each of those months has less than 10
    // distinct customers who purchased that item. The identifiers and the
    // categories of the selected items are stored in the second output folder
    // (one pair (ItemID, Category) per output line).
    //
    // NOTE: The months with less than 10 distinct customers can be either
    // consecutive or not consecutive.

    Dataset<Row> itemsIncludedInCatalogBefore2020 = itemsCatalog
      .filter(year(itemsCatalog.col("FirstTimeInCatalog")).lt(2020))
      .select("ItemID");

    Dataset<Row> itemsWithLessThan10CustomersEachMonth = purchases
      .join(itemsIncludedInCatalogBefore2020, "ItemID")
      .withColumn("Year", year(purchases.col("SaleTimestamp")))
      .withColumn("Month", month(purchases.col("SaleTimestamp")))
      .groupBy("Year", "Month", "ItemID")
      .agg(count_distinct(purchases.col("Username")).as("NumCustomers"))
      .filter("NumCustomers < 10");

    Dataset<Row> itemsWithLessThan10CustomersEachMonthInMoreThan2Months = itemsWithLessThan10CustomersEachMonth
      .groupBy("Year", "ItemID")
      .agg(count_distinct(col("Month")).as("NumMonths"))
      .filter("NumMonths >= 2")
      .select("ItemID");

    Dataset<Row> res2 = itemsWithLessThan10CustomersEachMonthInMoreThan2Months
      .join(itemsCatalog, "ItemID")
      .select("ItemID", "Category");

    res2.write().csv(args[4]);

    ss.stop();
  }
}
