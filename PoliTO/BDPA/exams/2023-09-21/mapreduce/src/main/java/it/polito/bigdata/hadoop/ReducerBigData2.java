package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData2 extends Reducer<Text, Text, Text, Text> {
    @Override
    protected void reduce(Text key, Iterable<Text> values,
            Reducer<Text, Text, Text, Text>.Context context)
            throws IOException, InterruptedException {

        int numLong = 0;
        int numShort = 0;

        for (Text value : values) {
            if (value.toString().equals("L")) { // long
                numLong++;
            } else { // short
                numShort++;
            }
        }

        context.write(key, new Text(numLong + "," + numShort));
    }
}
