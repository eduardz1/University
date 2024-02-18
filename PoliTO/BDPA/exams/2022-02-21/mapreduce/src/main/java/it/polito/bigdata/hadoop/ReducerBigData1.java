package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData1
  extends Reducer<IntWritable, IntWritable, IntWritable, IntWritable> {

  private IntWritable year = new IntWritable();
  private IntWritable count = new IntWritable();

  private int maxCount;
  private int minYear;

  @Override
  protected void setup(
    Reducer<IntWritable, IntWritable, IntWritable, IntWritable>.Context context
  ) throws IOException, InterruptedException {
    maxCount = -1;
    minYear = Integer.MAX_VALUE;
  }

  @Override
  protected void reduce(
    IntWritable key,
    Iterable<IntWritable> values,
    Reducer<IntWritable, IntWritable, IntWritable, IntWritable>.Context context
  ) throws IOException, InterruptedException {
    int accumulator = 0;
    for (IntWritable value : values) {
      accumulator += value.get();
    }

    if (accumulator > maxCount) {
      maxCount = accumulator;
      minYear = key.get();
    } else if (accumulator == maxCount && minYear > key.get()) {
      minYear = key.get();
    }
  }

  @Override
  protected void cleanup(
    Reducer<IntWritable, IntWritable, IntWritable, IntWritable>.Context context
  ) throws IOException, InterruptedException {
    year.set(minYear);
    count.set(maxCount);
    context.write(year, count);
  }
}
