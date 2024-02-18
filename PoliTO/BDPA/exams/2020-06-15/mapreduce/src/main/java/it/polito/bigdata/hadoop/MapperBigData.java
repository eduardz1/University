package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<LongWritable, Text, Text, NullWritable> {

  private Text customer_book = new Text();

  protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
    String[] fields = value.toString().split(",");
    String date = fields[2];

    if (!date.matches("^2018.*")) return; // equivalent to .startsWith("2018")

    customer_book.set("" + fields[0] + "," + fields[1]);

    context.write(customer_book, NullWritable.get());
  }
}
