package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData1
  extends Reducer<Text, IntWritable, Text, NullWritable> {

  private Text model = new Text();

  @Override
  protected void reduce(
    Text key,
    Iterable<IntWritable> values,
    Reducer<Text, IntWritable, Text, NullWritable>.Context context
  ) throws IOException, InterruptedException {
    int countEU = 0;
    int countNotEU = 0;
    for (IntWritable value : values) {
      if (value.get() == 'T') countEU++; else countNotEU++;
    }

    if (countEU < 10000 || countNotEU < 10000) return;

    model.set(key.toString());
    context.write(model, NullWritable.get());
  }
}
