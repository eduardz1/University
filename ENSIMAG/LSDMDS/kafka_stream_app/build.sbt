name := "kafka-stream-app"

version := "1.0"

scalaVersion := "2.12.10"

resolvers += "spark-packages" at "https://dl.bintray.com/spark-packages/maven/"
val SPARK_VERSION = "3.0.1"

libraryDependencies += "org.apache.spark" %% "spark-streaming" % SPARK_VERSION % "provided"

libraryDependencies += "org.apache.spark" %% "spark-streaming-kafka-0-10" % SPARK_VERSION
