package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData1 extends Mapper<LongWritable, Text, Text, IntWritable> {

  private Text city = new Text();
  private static IntWritable one = new IntWritable(1);

  protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
    String[] fields = value.toString().split(",");

    if (Integer.parseInt(fields[3]) >= 100) return;

    city.set(fields[1]);
    context.write(city, one);
  }
}
