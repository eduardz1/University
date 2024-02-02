package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<Text, Text, Text, Text> {

    private Text id = new Text();
    private Text date = new Text();
    private final static int PM10Threshold = 50;

    protected void map(Text key, Text value, Context context) throws IOException, InterruptedException {
        String[] fields = key.toString().split(",");

        if (new Double(value.toString()) > PM10Threshold) {
            id.set(fields[0]);
            date.set(fields[1]);
            context.write(id, date);
        }
    }
}
