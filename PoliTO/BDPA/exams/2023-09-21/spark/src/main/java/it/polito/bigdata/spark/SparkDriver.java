package it.polito.bigdata.spark;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;

public class SparkDriver {
    public static void main(String[] args) {
        BasicConfigurator.configure();

        // The following two lines are used to switch off some verbose log messages
        Logger.getLogger("org").setLevel(Level.ALL);
        Logger.getLogger("akka").setLevel(Level.ALL);

        String customerPath = args[0];
        String TVSeriesPath = args[1];
        String EpisodesPath = args[2];
        String CustomerWatchedPath = args[3];
        String outputPath1 = args[4];
        String outputPath2 = args[5];

        // Create a configuration object and set the name of the application
        SparkSession ss = SparkSession.builder().appName("exam_2023-09-21 spark").master("local").getOrCreate();

        Dataset<Row> customers = ss.read().format("txt").option("header", false).option("inferSchema", true)
                .load(customerPath)
                .withColumnRenamed("_c0", "CID")
                .withColumnRenamed("_c1", "Name")
                .withColumnRenamed("_c2", "Surname")
                .withColumnRenamed("_c3", "City")
                .withColumnRenamed("c_4", "Country");
        customers.createOrReplaceTempView("customers");

        Dataset<Row> tvSeries = ss.read().format("txt").option("header", false).option("inferSchema", true)
                .load(TVSeriesPath)
                .withColumnRenamed("_c0", "SID")
                .withColumnRenamed("_c1", "Series")
                .withColumnRenamed("_c2", "Genre");
        tvSeries.createOrReplaceTempView("tvSeries");

        Dataset<Row> episodes = ss.read().format("txt").option("header", false).option("inferSchema", true)
                .load(EpisodesPath)
                .withColumnRenamed("_c0", "SID")
                .withColumnRenamed("_c1", "Season")
                .withColumnRenamed("_c2", "Episode")
                .withColumnRenamed("_c3", "Title")
                .withColumnRenamed("_c4", "DatePublished");
        episodes.createOrReplaceTempView("episodes");

        Dataset<Row> customerWatched = ss.read().format("txt").option("header", false).option("inferSchema", true)
                .load(CustomerWatchedPath)
                .withColumnRenamed("_c0", "CID")
                .withColumnRenamed("_c1", "DateWatched")
                .withColumnRenamed("_c2", "SID")
                .withColumnRenamed("_c3", "Season")
                .withColumnRenamed("_c4", "Episode");
        customerWatched.createOrReplaceTempView("customerWatched");

        // @formatter:off
        Dataset<Row> avgNumEpisodes = ss.sql(
            "SELECT SID, AVG(NumEpisodes)" +
            "FROM (" +
                "SELECT SID, COUNT(*) AS NumEpisodes" +
                "FROM Episodes" +
                "GROUP BY SID, Season" +
            ")" +
            "GROUP BY SID"
        );

        avgNumEpisodes.write().format("txt").option("header", false).save(outputPath1);

        Dataset<Row> distinctEpisodesForSIDSeasonCID = ss.sql(
            "SELECT CID, SID, Season, COUNT(DISTINCT Episode) AS NumWatched" +
            "FROM customerWatched" +
            "GROUP BY CID, SID, Season"
        );
        distinctEpisodesForSIDSeasonCID.createOrReplaceTempView("distinctEpisodesForSIDSeasonCID");
        
        Dataset<Row> numEpisodesForSIDSeason = ss.sql(
            "SELECT SID, Season, COUNT(*) AS NumEpisodes" +
            "FROM episodes" +
            "GROUP BY SID, Season"
        ); 
        numEpisodesForSIDSeason.createOrReplaceTempView("numEpisodesForSIDSeason");

        Dataset<Row> customersWhoWatchedAtLeastOneEpisodeOfEachSeason = ss.sql(
            "SELECT SID, CID" +
            "FROM distinctEpisodesForSIDSeasonCID a, numEpisodesForSIDSeason b" +
            "WHERE a.SID == b.SID AND a.CID == b.CID AND a.NumWatched >= b.NumEpisodes"
        );
        // @formatter:on

        customersWhoWatchedAtLeastOneEpisodeOfEachSeason.write().format("txt").option("header", false)
                .save(outputPath2);

        ss.stop();
    }
}
