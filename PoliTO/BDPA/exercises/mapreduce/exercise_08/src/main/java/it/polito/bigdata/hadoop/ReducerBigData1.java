package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class ReducerBigData1 extends Reducer<Text, FloatWritable, Text, FloatWritable> {

    private FloatWritable total = new FloatWritable();

    @Override
    protected void reduce(Text key, Iterable<FloatWritable> values, Context context)
            throws IOException, InterruptedException {

        float sum = 0;

        for (FloatWritable value : values) {
            sum += value.get();
        }

        total.set(sum);
        context.write(key, total);
    }
}
