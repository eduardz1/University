package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<LongWritable, Text, Text, NullWritable> {

  protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
    String[] fields = value.toString().split(",");

    if (!fields[1].equals("FCode122")) return;

    context.write(new Text(fields[0]), NullWritable.get());
  }
}
