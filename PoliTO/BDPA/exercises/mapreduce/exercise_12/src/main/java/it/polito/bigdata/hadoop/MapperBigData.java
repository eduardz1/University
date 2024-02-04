package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<Text, Text, Text, FloatWritable> {

    private static float threshold;

    @Override
    protected void setup(Mapper<Text, Text, Text, FloatWritable>.Context context)
            throws IOException, InterruptedException {
        threshold = Float.parseFloat(context.getConfiguration().get("threshold"));
    }

    private FloatWritable reading = new FloatWritable();

    protected void map(Text key, Text value, Context context)
            throws IOException, InterruptedException {

        float floatValue = Float.parseFloat(value.toString());

        if (floatValue < threshold) {
            reading.set(floatValue);
            context.write(key, reading);
        }
    }
}
