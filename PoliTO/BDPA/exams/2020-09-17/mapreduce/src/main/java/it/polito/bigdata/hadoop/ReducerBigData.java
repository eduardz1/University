package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData extends Reducer<Text, Text, Text, NullWritable> {

  @Override
  protected void reduce(
    Text key,
    Iterable<Text> values,
    Reducer<Text, Text, Text, NullWritable>.Context context
  ) throws IOException, InterruptedException {
    String first_user = values.iterator().next().toString();

    for (Text value : values) {
      if (!value.toString().equals(first_user)) return;
    }

    context.write(key, NullWritable.get());
  }
}
