package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData extends Reducer<Text, NullWritable, Text, Text> {

  private Text customer = new Text();
  private Text book = new Text();

  @Override
  protected void reduce(
    Text key,
    Iterable<NullWritable> values,
    Reducer<Text, NullWritable, Text, Text>.Context context
  ) throws IOException, InterruptedException {
    int count = 0;

    while (values.iterator().hasNext()) {
      count++;
      values.iterator().next();
    }

    if (count < 2) return;

    String[] customer_book = key.toString().split(",");
    customer.set(customer_book[0]);
    book.set(customer_book[1]);

    context.write(customer, book);
  }
}
