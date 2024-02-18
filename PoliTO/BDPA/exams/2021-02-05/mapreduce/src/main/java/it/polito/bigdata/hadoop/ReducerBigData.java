package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData
  extends Reducer<Text, NullWritable, IntWritable, NullWritable> {

  private int count;

  @Override
  protected void setup(
    Reducer<Text, NullWritable, IntWritable, NullWritable>.Context context
  ) throws IOException, InterruptedException {
    count = 0;
  }

  @Override
  protected void reduce(
    Text key,
    Iterable<NullWritable> values,
    Reducer<Text, NullWritable, IntWritable, NullWritable>.Context context
  ) throws IOException, InterruptedException {
    count++;
  }

  @Override
  protected void cleanup(
    Reducer<Text, NullWritable, IntWritable, NullWritable>.Context context
  ) throws IOException, InterruptedException {
    context.write(new IntWritable(count), NullWritable.get());
  }
}
