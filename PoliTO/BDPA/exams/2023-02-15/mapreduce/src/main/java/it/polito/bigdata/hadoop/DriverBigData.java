package it.polito.bigdata.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.log4j.BasicConfigurator;

/**
 * MapReduce program
 */
public class DriverBigData extends Configured implements Tool {

  @Override
  public int run(String[] args) throws Exception {
    Path inputPath = new Path(args[1]);
    Path outputDir = new Path(args[2]);
    Path outputDirFinal = new Path(args[3]);

    Configuration conf = this.getConf();

    Job job1 = Job.getInstance(conf, "exam 2023-02-15 pass 1");

    FileInputFormat.addInputPath(job1, inputPath);
    FileOutputFormat.setOutputPath(job1, outputDir);

    job1.setJarByClass(getClass());

    job1.setInputFormatClass(TextInputFormat.class);
    job1.setOutputFormatClass(TextOutputFormat.class);

    job1.setMapperClass(MapperBigData1.class);
    job1.setMapOutputKeyClass(Text.class);
    job1.setMapOutputValueClass(IntWritable.class);

    job1.setReducerClass(ReducerBigData1.class);
    job1.setOutputKeyClass(Text.class);
    job1.setOutputValueClass(IntWritable.class);

    job1.setNumReduceTasks(Integer.parseInt(args[0]));

    if (!job1.waitForCompletion(true)) return 1;

    Job job2 = Job.getInstance(conf, "exam 2023-02-15 pass 2");

    FileInputFormat.addInputPath(job2, outputDir);
    FileOutputFormat.setOutputPath(job2, outputDirFinal);

    job2.setJarByClass(getClass());

    job2.setInputFormatClass(KeyValueTextInputFormat.class);
    job2.setOutputFormatClass(TextOutputFormat.class);

    job2.setMapperClass(MapperBigData2.class);
    job2.setMapOutputKeyClass(NullWritable.class);
    job2.setMapOutputValueClass(Text.class);

    job2.setReducerClass(ReducerBigData2.class);
    job2.setOutputKeyClass(Text.class);
    job2.setOutputValueClass(IntWritable.class);

    job2.setNumReduceTasks(1);

    return job2.waitForCompletion(true) ? 0 : 1;
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
