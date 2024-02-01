package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class Reducer1BigData extends Reducer<Text, // Input key type
        IntWritable, // Input value type
        Text, // Output key type
        IntWritable> { // Output value type

    private String maxOs;
    private int maxCount;

    @Override
    protected void setup(Context context) throws IOException, InterruptedException {
        this.maxOs = "";
        this.maxCount = 0;
    }

    @Override
    protected void reduce(
            Text key, // Input key type
            Iterable<IntWritable> values, // Input value type
            Context context) throws IOException, InterruptedException {

        String k = key.toString();
        int sum = 0;
        for (IntWritable val : values) {
            sum += val.get();
        }

        if (this.maxCount == 0 ||
                (this.maxCount == sum && k.compareTo(this.maxOs) < 0) ||
                sum > this.maxCount) {
            this.maxCount = sum;
            this.maxOs = k;
        }
    }

    @Override
    protected void cleanup(Context context) throws IOException, InterruptedException {
        context.write(new Text(this.maxOs), new IntWritable(maxCount));
    }
}
