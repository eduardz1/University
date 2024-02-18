package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData2 extends Mapper<Text, Text, NullWritable, Text> {

  private Text city_count = new Text();

  protected void map(Text key, Text value, Context context)
    throws IOException, InterruptedException {
    city_count.set("" + key + "," + value);
    context.write(NullWritable.get(), city_count);
  }
}
