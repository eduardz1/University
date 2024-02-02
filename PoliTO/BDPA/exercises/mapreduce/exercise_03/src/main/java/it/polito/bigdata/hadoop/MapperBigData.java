package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<Text, Text, Text, IntWritable> {

    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();
    private final static int PM10Threshold = 50;

    protected void map(Text key, Text value, Context context) throws IOException, InterruptedException {
        String[] fields = key.toString().split(",");

        if (new Double(value.toString()) > PM10Threshold) {
            word.set(fields[0]);
            context.write(word, one);
        }
    }
}
