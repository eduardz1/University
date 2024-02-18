package it.polito.bigdata.hadoop;

import java.io.IOException;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<LongWritable, Text, Text, Text> {

  private Text movie = new Text();
  private Text username = new Text();

  protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
    String[] fields = value.toString().split(",");
    String[] date = fields[2].split("/");

    int year = Integer.parseInt(date[0]);

    if (year != 2019) return;

    movie.set(fields[1]);
    username.set(fields[0]);

    context.write(movie, username); // inverted index
  }
}
