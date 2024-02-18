package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData1
  extends Mapper<LongWritable, Text, IntWritable, IntWritable> {

  private IntWritable year = new IntWritable();
  private static IntWritable one = new IntWritable(1);

  protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
    String[] fields = value.toString().split(",");
    String[] date = fields[0].split("/");

    year.set(Integer.parseInt(date[0]));
    context.write(year, one);
  }
}
