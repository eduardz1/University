package it.polito.bigdata.spark;

import org.apache.spark.api.java.*;
import org.apache.spark.SparkConf;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import scala.Tuple2;

public class SparkDriver {

    public static void main(String[] args) {

        // The following two lines are used to switch off some verbose log messages
        Logger.getLogger("org").setLevel(Level.OFF);
        Logger.getLogger("akka").setLevel(Level.OFF);

        String serverPath, patchesPath, appliedPatchesPath;
        String outputPath1, outputPath2;

        serverPath = args[0];
        patchesPath = args[1];
        appliedPatchesPath = args[2];
        outputPath1 = args[3];
        outputPath2 = args[4];

        // Create a configuration object and set the name of the application
        SparkConf conf = new SparkConf().setAppName("Spark - Exam20220704");

        // Use the following command to create the SparkConf object if you want to run
        // your application inside Eclipse.
        // Remember to remove .setMaster("local") before running your application on the
        // cluster
        // SparkConf conf=new SparkConf().setAppName("Spark Lab #5").setMaster("local");

        // Create a Spark Context object
        JavaSparkContext sc = new JavaSparkContext(conf);

        // Input format: SID, OS, Model
        JavaRDD<String> serverRDD = sc.textFile(serverPath);
        // Input format: PID, ReleaseDate, OS
        JavaRDD<String> patchesRDD = sc.textFile(patchesPath);
        // Input format: PID, SID, ApplicationDate
        JavaRDD<String> appliedPatchesRDD = sc.textFile(appliedPatchesPath);

        // Part 1
        // Patches of Ubuntu2 OS that were applied on many servers on the same date they
        // were released
        // (many servers = >= 100 servers)

        // First, map the patches RDD into a pair rdd:
        // key = PID
        // value = (OS, ReleaseDate)
        // and then keep only the elements with OS == "Ubuntu2"
        // Then discard the OS information, so that the resulting RDD will be:
        // key = PID
        // value = ReleaseDate
        JavaPairRDD<String, String> pidOsUbuntuRDD = patchesRDD.mapToPair(l -> {
            String[] fields = l.split(",");
            String pid = fields[0];
            String os = fields[2];
            String date = fields[1];
            return new Tuple2<>(pid, new Tuple2<>(os, date));
        })
                .filter(t -> t._2()._1().equals("Ubuntu2"))
                .mapToPair(t -> new Tuple2<>(t._1(), t._2()._2()));

        // from appliedPatches RDD obtain a pair RDD with
        // key = PID
        // value = AppliedDate
        JavaPairRDD<String, String> pidAppliedDateRDD = appliedPatchesRDD.mapToPair(l -> {
            String[] fields = l.split(",");
            String pid = fields[0];
            String applicationDate = fields[2];

            return new Tuple2<>(pid, applicationDate);
        });

        // Join the two RDDs so that (left = appliedPatches, right = patches)
        // key = PID
        // value = (application date, release date)
        // then filter only those lines for which application date == release date
        JavaPairRDD<String, Tuple2<String, String>> patchesAppliedAtRelease = pidAppliedDateRDD
                .join(pidOsUbuntuRDD)
                .filter(t -> t._2()._1().equals(t._2()._2()));

        // Each element in the resulting RDD represent a patch applied on a server with
        // Ubuntu2 OS
        // at the release date
        // Now map all the elements into a pairRDD with
        // key = PID
        // value = 1
        // and use a reduceByKey to count for each patch the number of servers (Ubuntu2)
        // on which
        // the patches were applied at release. Filter and keep only those patches which
        // were applied to
        // 100 servers or more
        JavaPairRDD<String, Integer> res1 = patchesAppliedAtRelease
                .mapToPair(t -> new Tuple2<>(t._1(), 1))
                .reduceByKey((i1, i2) -> i1 + i2)
                .filter(s -> s._2() >= 100);

        res1.keys().saveAsTextFile(outputPath1);

        // Part 2
        // For each server, compute the #months in 2021 without applied patches for each
        // server
        // Starting from applied patches rdd, filter only those patches applied in 2021
        // and map into a pair RDD with
        // key = SID
        // value = month
        // and perform a distinct operation to keep for each server the distinct months
        JavaPairRDD<String, Integer> serverMonthAppliedPatch = appliedPatchesRDD.filter(l -> {
            String[] fields = l.split(",");
            String date = fields[2];
            return date.startsWith("2021");
        })
                .mapToPair(l -> {
                    String[] fields = l.split(",");
                    String sid = fields[1];
                    String date = fields[2];
                    int month = Integer.parseInt(date.split("/")[1]);
                    return new Tuple2<>(sid, month);
                })
                .distinct();

        // Perform a groupByKey to collect in an Iterable all the months in 2021 for
        // each server
        // use a List of 12 elements to mark whether a month was present or not
        // list value == False -> month not present
        // then return as output the number of False elements (= number of missing
        // months per server)
        JavaPairRDD<String, Integer> missingMonthsPerServer = serverMonthAppliedPatch
                .groupByKey()
                .mapValues(it -> {
                    int missingMonths = 12;
                    for (int month : it)
                        missingMonths--;
                    return missingMonths;
                });

        // use serversRDD to gather also information from servers for which no patches
        // were applied
        // prepare a pairRDD with
        // key = SID
        // value = 12 (12 missing months)
        JavaPairRDD<String, Integer> missingServers = serverRDD.mapToPair(l -> {
            String[] fields = l.split(",");
            String sid = fields[0];
            return new Tuple2<>(sid, 12);
        });

        // use a leftOuterJoin to join missingServers with missingMonthsPerServer
        // key = SID
        // value = (12, Optional(missingMonths))
        // if missingMonths value is present, keep that, otherwise substitute it with 12
        JavaPairRDD<String, Integer> res2 = missingServers
                .leftOuterJoin(missingMonthsPerServer)
                .mapValues(t -> t._2().isPresent() ? t._2().get() : t._1());

        res2.saveAsTextFile(outputPath2);

        sc.close();
    }
}
