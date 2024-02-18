package it.polito.bigdata.spark;

import static org.apache.spark.sql.functions.*;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.expressions.Window;
import org.apache.spark.sql.expressions.WindowSpec;

public class SparkDriver {

  public static void main(String[] args) {
    BasicConfigurator.configure();

    // The following two lines are used to switch off some verbose log messages
    Logger.getLogger("org").setLevel(Level.OFF);
    Logger.getLogger("akka").setLevel(Level.OFF);

    SparkSession ss = SparkSession
      .builder()
      .appName("exam_2020-06-16 spark")
      .master("local[12]")
      .config("spark.executor.memory", "3G")
      .config("spark.driver.memory", "12G")
      .getOrCreate();

    Dataset<Row> books = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[0]);

    Dataset<Row> purchases = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[1]);

    purchases = purchases.withColumn("Date", to_date(col("Date"), "yyyyMMdd"));

    books.printSchema();
    purchases.printSchema();

    // Maximum number of daily purchases per book in year 2018. Consider only
    // the purchases of years 2018 and only the books with at least one purchase
    // in year 2018. The application computes the maximum number of daily
    // purchases for each book. The application stores in the first HDFS output
    // folder for each book its identifier and its maximum number of daily
    // purchases (one pair (BID, maximum number of daily purchases) per line).

    Dataset<Row> purchases2018 = purchases
      .filter(year(col("date")).equalTo(2018))
      .cache();

    WindowSpec windowSpec = Window.partitionBy("Date", "BID");

    Dataset<Row> res1 = purchases2018
      .withColumn("NumOfDailyPurchases", count("*").over(windowSpec))
      .groupBy("BID")
      .agg(max("NumOfDailyPurchases"));

    res1.write().mode("overwrite").csv(args[2]);

    // Windows of three consecutive days with many purchases. Consider only the
    // purchases of years 2018. The application must select, for each book, all
    // the windows of three consecutive dates such that each date of the window
    // is characterized by a number of purchases that is greater than 10% of the
    // purchases of the considered book in year 2018. Specifically, given a book
    // and a window of three consecutive dates, that window of three consecutive
    // dates is selected for that book if and only if in each of those three
    // dates the number of purchases of that book is greater than 0.1*total
    // number of purchases of that book in year 2018. The application stores
    // the result in the second HDFS output folder. Specifically, each of the
    // selected combinations (book, window of three consecutive dates) is stored
    // in one output line and the used format is the following: (BID of the
    // selected book, first date of the selected window of three consecutive
    // dates).
    //
    // NOTE: that you can have overlapped windows of three consecutive dates
    // among the selected windows.

    // partition by date, order by date and select the range -1 to 1
    // (groups of 3 days at a time)
    WindowSpec windowSpec2 = Window
      .partitionBy("BID", "Date")
      .orderBy(col("Date"))
      .rowsBetween(-1, 1); // rangeBetween() can only be used
                           // with int on the order by

    WindowSpec windowSpec3 = Window.partitionBy(col("BID"), year(col("Date")));

    Dataset<Row> res2 = purchases2018
      .withColumn("Sum3Days", sum("Price").over(windowSpec2))
      .withColumn("SumYear", sum("Price").over(windowSpec3).as("SumYear"))
      .withColumn("FirstDay", first("Date").over(windowSpec2))
      .filter(col("Sum3Days").gt(col("SumYear").multiply(0.1)))
      .select("BID", "FirstDay");

    res2.write().mode("overwrite").csv(args[3]);

    ss.stop();
  }
}
