package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData1
  extends Reducer<Text, IntWritable, Text, IntWritable> {

  private Text city = new Text();
  private IntWritable count = new IntWritable();

  @Override
  protected void reduce(
    Text key,
    Iterable<IntWritable> values,
    Reducer<Text, IntWritable, Text, IntWritable>.Context context
  ) throws IOException, InterruptedException {
    city.set(key);
    int accumulator = 0;
    for (IntWritable value : values) {
      accumulator++;
    }
    count.set(accumulator);
    context.write(city, count);
  }
}
