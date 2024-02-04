package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class ReducerBigData2 extends Reducer<Text, FloatWritable, Text, FloatWritable> {

    private FloatWritable average = new FloatWritable();

    @Override
    protected void reduce(Text key, Iterable<FloatWritable> values, Context context)
            throws IOException, InterruptedException {

        float sum = 0;
        int count = 0;

        for (FloatWritable value : values) {
            sum += value.get();
            count++;
        }

        average.set(sum / count);
        context.write(key, average);
    }
}
