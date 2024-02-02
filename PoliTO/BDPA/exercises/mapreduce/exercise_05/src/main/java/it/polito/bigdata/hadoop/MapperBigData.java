package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<LongWritable, Text, Text, FloatWritable> {

    private Text id = new Text();
    private FloatWritable measure = new FloatWritable();

    protected void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {
        String[] fields = value.toString().split(",");

        id.set(fields[0]);
        measure.set(Float.parseFloat(fields[2]));
        context.write(id, measure);
    }
}
