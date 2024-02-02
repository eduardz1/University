package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<LongWritable, Text, Text, MinMaxWritable> {

    private Text id = new Text();
    private MinMaxWritable minmax = new MinMaxWritable();

    protected void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {
        String[] fields = value.toString().split(",");

        id.set(fields[0]);
        minmax.setMax(Float.parseFloat(fields[2]));
        minmax.setMin(Float.parseFloat(fields[2]));
        context.write(id, minmax);
    }
}
