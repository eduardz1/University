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
import org.apache.spark.sql.types.DataTypes;

public class SparkDriver {

  public static void main(String[] args) {
    BasicConfigurator.configure();

    // The following two lines are used to switch off some verbose log messages
    Logger.getLogger("org").setLevel(Level.OFF);
    Logger.getLogger("akka").setLevel(Level.OFF);

    SparkSession ss = SparkSession
      .builder()
      .appName("exam_2020-09-17 spark")
      .master("local[12]")
      .config("spark.executor.memory", "3G")
      .config("spark.driver.memory", "12G")
      .getOrCreate();

    Dataset<Row> users = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[0]);

    Dataset<Row> watchedMovies = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[1]);

    Dataset<Row> movies = ss
      .read()
      .option("header", true)
      .option("inferSchema", true)
      .csv(args[2]);

    users =
      users.withColumn("YearOfBirth", to_date(col("YearOfBirth"), "yyyy"));
    watchedMovies =
      watchedMovies
        .withColumn(
          "StartTimestamp",
          to_timestamp(col("StartTimestamp"), "yyyy/MM/dd_HH:mm")
        )
        .withColumn(
          "EndTimestamp",
          to_timestamp(col("EndTimestamp"), "yyyy/MM/dd_HH:mm")
        );
    movies =
      movies.withColumn(
        "ReleaseDate",
        to_date(col("ReleaseDate"), "yyyy/MM/dd")
      );

    users.printSchema();
    watchedMovies.printSchema();
    movies.printSchema();

    // Movies that have been watched frequently but only in one year in the last
    // five years. Considering only the lines of WatchedMovies.txt related to
    // the last five years (i.e., the lines with StartTimestamp in the range
    // September 17, 2015 - September 16, 2020), the application selects the
    // movies that (i) have been watched only in one of those 5 years and (ii)
    // at least 1000 times in that year. For each of the selected movies, the
    // application stores in the first HDFS output folder its identifier (MID)
    // and the single year in which it has been watched at least 1000 times
    // (one pair (MID, year) per line).
    //
    // NOTE: The value of StartTimestamp is used to decide in which year a user
    // watched a specific movie. Do not consider the value of EndTimestamp.

    Dataset<Row> watchedInLast5Years = watchedMovies.where(
      col("StartTimestamp")
        .between(
          lit("2015-09-18 00:00:00").cast(DataTypes.TimestampType),
          lit("2020-09-16 23:59:59").cast(DataTypes.TimestampType)
        )
    );

    Dataset<Row> res1 = watchedInLast5Years
      .withColumn("Year", year(col("StartTimestamp")))
      .groupBy("MID")
      .agg(
        count_distinct(col("Year")).as("DifferentYearsCount"),
        count("*").as("TimesWatched"),
        first("Year").as("Year")
      )
      .filter("DifferentYearsCount == 1")
      .filter("TimesWatched >= 1000")
      .select("MID", "Year");

    res1.write().mode("overwrite").csv(args[3]);

    // Most popular movie in at least two years. Considering all the lines of
    // WatchedMovies.txt (i.e., all years), the application selects the movies
    // that have been the most popular movie in at least two years. The annual
    // popularity of a movie in a specific year is given by the number of
    // distinct users who watched that movie in that specific year. A movie is
    // the most popular movie in a specific year if it is associated with the
    // highest annual popularity of that year. The application stores in the
    // second HDFS output folder the identifiers (MIDs) of the selected movies
    // (one MID per line).
    //
    // NOTE: The value of StartTimestamp is used to decide in which year a user
    // watched a specific movie. Do not consider the value of EndTimestamp.

    Dataset<Row> moviesWithNumDistinctUsersPerYear = watchedMovies
      .withColumn("Year", year(col("StartTimestamp")))
      .groupBy("MID", "Year")
      .agg(count_distinct(col("Username")).as("NumDistinctUsers"));

    // use window when you need to partition without discarding the other
    // columns of the record
    WindowSpec windowSpec = Window
      .partitionBy("Year")
      .orderBy(col("NumDistinctUsers").desc());

    Dataset<Row> mostPopularMovies = moviesWithNumDistinctUsersPerYear
      // can also use row_number() instead of rank() to only select the first
      .withColumn("Rank", rank().over(windowSpec))
      .filter(col("Rank").equalTo(1));

    Dataset<Row> res2 = mostPopularMovies
      .groupBy("MID")
      .agg(count(col("Year")).as("NumYears"))
      .filter("NumYears >= 2")
      .select("MID");

    res2.write().mode("overwrite").csv(args[4]);

    ss.stop();
  }
}
