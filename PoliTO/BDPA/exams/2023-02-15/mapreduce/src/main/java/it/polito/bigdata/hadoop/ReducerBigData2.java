package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData2
  extends Reducer<NullWritable, Text, Text, IntWritable> {

  @Override
  protected void reduce(
    NullWritable key,
    Iterable<Text> values,
    Reducer<NullWritable, Text, Text, IntWritable>.Context context
  ) throws IOException, InterruptedException {
    int max = -1;
    String city = "";

    for (Text value : values) {
      String[] split = value.toString().split(",");

      String name = split[0];
      int count = Integer.parseInt(split[1]);

      if (count > max) {
        max = count;
        city = name;
      } else if (count == max && name.compareTo(city) < 0) {
        city = name;
      }
    }

    context.write(new Text(city), new IntWritable(max));
  }
}
