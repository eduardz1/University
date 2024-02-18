package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData2
  extends Reducer<NullWritable, Text, IntWritable, IntWritable> {

  @Override
  protected void reduce(
    NullWritable key,
    Iterable<Text> values,
    Reducer<NullWritable, Text, IntWritable, IntWritable>.Context context
  ) throws IOException, InterruptedException {
    int maxCount = -1;
    int minYear = Integer.MAX_VALUE;

    for (Text value : values) {
      String[] split = value.toString().split(",");

      int year = Integer.parseInt(split[0]);
      int count = Integer.parseInt(split[1]);

      if (count > maxCount) {
        maxCount = count;
        minYear = year;
      } else if (count == maxCount && minYear > year) {
        minYear = year;
      }
    }

    context.write(new IntWritable(minYear), new IntWritable(maxCount));
  }
}
