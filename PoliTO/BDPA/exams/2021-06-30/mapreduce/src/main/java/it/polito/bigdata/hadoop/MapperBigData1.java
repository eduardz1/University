package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData1 extends Mapper<LongWritable, Text, Text, IntWritable> {

  private Text model = new Text();
  private static IntWritable EU = new IntWritable('T');
  private static IntWritable notEU = new IntWritable('F');

  protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
    String[] fields = value.toString().split(",");
    String[] date = fields[3].split("/");

    if (Integer.parseInt(date[0]) != 2020) return;

    model.set(fields[2]);

    if (fields[6].equalsIgnoreCase("T")) {
      context.write(model, EU);
    } else {
      context.write(model, notEU);
    }
  }
}
