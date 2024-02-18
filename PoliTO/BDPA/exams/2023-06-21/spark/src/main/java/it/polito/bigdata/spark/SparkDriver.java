package it.polito.bigdata.spark;

import static org.apache.spark.sql.functions.*;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;

public class SparkDriver {

  public static void main(String[] args) {
    Logger.getLogger("org").setLevel(Level.OFF);
    Logger.getLogger("akka").setLevel(Level.OFF);

    String neObjectData;
    String observationData;
    String outputPath1;
    String outputPath2;

    neObjectData = "exam_ex2_data/NEObject.txt";
    observationData = "exam_ex2_data/Observations.txt";

    outputPath1 = "outPart1/";
    outputPath2 = "outPart2/";

    SparkSession ss = SparkSession
      .builder()
      .appName("Exam20240205 Spark")
      .master("local")
      .getOrCreate();

    Dataset<Row> neos = ss
      .read()
      .format("csv")
      .option("header", true)
      .option("inferSchema", true)
      .load(neObjectData);

    Dataset<Row> observations = ss
      .read()
      .format("csv")
      .option("header", true)
      .option("inferSchema", true)
      .load(observationData);

    // Number of observations for the Most Relevant NEOs from 2023. Considering
    // only the observations starting from 2023, the application aims to
    // calculate the number of observations associated with the Most Relevant NEOs.
    // The Most Relevant NEOs are the NEOs that (i) have not already fallen and
    // (ii) are characterized by a dimension exceeding the average dimension
    // considering all the registered NEOs in the “NEObjects.txt” file. Calculate
    // the number of observations starting from 2023 for each Most Relevant NEO,
    // sort the result by this number in descending order, and store the result
    // in the first HDFS output folder. Consider only the Most Relevant NEOs that
    // have been observed at least one time starting from 2023 in this first part
    // of the application. The first HDFS output folder must contain information
    // in the format "NEOID,Number of observations starting from 2023" for
    // the Most Relevant NEOs (one line for each Most Relevant NEO).

    Dataset<Row> avgDimension = neos.agg(avg("Dimension").as("AvgDim"));

    Dataset<Row> mostRelNEOs = neos
      .join(avgDimension, neos.col("Dimension").gt(avgDimension.col("AvgDim")))
      .filter(neos.col("alreadyFallen").equalTo(false))
      .select("NEOID")
      .cache();

    Dataset<Row> observationsFrom2023 = observations
      .filter(year(observations.col("ObsDateTime")).geq(2023))
      .select("NEOID", "ObservatoryID")
      .cache();

    Dataset<Row> res1 = observationsFrom2023
      .join(
        mostRelNEOs,
        observationsFrom2023.col("NEOID").equalTo(mostRelNEOs.col("NEOID"))
      )
      .groupBy("NEOID")
      .agg(count("*").as("ObservationCount"))
      .orderBy(desc("ObservationCount"));

    res1.write().format("csv").option("header", false).save(outputPath1);

    // The most relevant NEOs observed by a few observatories starting from 2023.
    // The second part of this application considers only the Most Relevant NEOs
    // observed by less than 10 unique observatories starting from the year 2023.
    // For each Most Relevant NEO of that subset, store in the second HDFS output
    // folder its identifier (NEOID) and the identifiers (ObservatoryIDs) of the
    // unique observatories that observed it starting from the year 2023
    // (one pair (NEOID, ObservatoryID) per output line). If a NEOD For each of
    // the selected Most Relevant NEOs never observed starting from 2023, store
    // the pair (NEOID, "NONE") in the output folder. The output format of each
    // output line is “NEOID, ObservatoryID”. Report the string "NONE" instead
    // of the ObservatoryID for each of the selected Most Relevant NEOs
    // never observed starting from 2023.
    Dataset<Row> res2 = mostRelNEOs
      .join(
        observationsFrom2023,
        mostRelNEOs.col("NEOID").equalTo(observationsFrom2023.col("NEOID")),
        "left_outer"
      )
      .groupBy("NEOID")
      .agg(countDistinct("ObservatoryID").as("count"))
      .filter(col("count").lt(10))
      .select(
        col("NEOID"),
        // coalesce returns the first column that is not null, or null if all
        // inputs are null. lit creates a Column of literal value.
        coalesce(col("ObservatoryID"), lit("NONE")).as("ObservatoryID")
      );

    res2.write().format("csv").option("header", false).save(outputPath2);

    ss.stop();
  }
}
