package it.polito.bigdata.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.log4j.BasicConfigurator;

// Customers who bought the same book at least two times in year 2018. The
// application considers only the purchases of year 2018 and selects the
// identifiers of the customers who bought the same book at least two times in
// year 2018. For each of the selected customers store in the output HDFS folder
// one line for each of the books he/she bought at least two times in year 2018.
// Each output line has the format Customerid\tBID.

/**
 * MapReduce program
 */
public class DriverBigData extends Configured implements Tool {

  @Override
  public int run(String[] args) throws Exception {
    Path inputPath = new Path(args[1]);
    Path outputDir = new Path(args[2]);

    Configuration conf = this.getConf();

    Job job1 = Job.getInstance(conf, "exam 2020-06-16");

    FileInputFormat.addInputPath(job1, inputPath);
    FileOutputFormat.setOutputPath(job1, outputDir);

    job1.setJarByClass(getClass());

    job1.setInputFormatClass(TextInputFormat.class);
    job1.setOutputFormatClass(TextOutputFormat.class);

    job1.setMapperClass(MapperBigData.class);
    job1.setMapOutputKeyClass(Text.class);
    job1.setMapOutputValueClass(NullWritable.class);

    job1.setReducerClass(ReducerBigData.class);
    job1.setOutputKeyClass(Text.class);
    job1.setOutputValueClass(Text.class);

    job1.setNumReduceTasks(Integer.parseInt(args[0]));

    return job1.waitForCompletion(true) ? 0 : 1;
  }

  /**
   * Main of the driver
   */
  public static void main(String[] args) throws Exception {
    BasicConfigurator.configure();
    // Exploit the ToolRunner class to "configure" and run the Hadoop application
    int res = ToolRunner.run(new Configuration(), new DriverBigData(), args);

    System.exit(res);
  }
}
