package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class ReducerBigData extends Reducer<Text, MinMaxWritable, Text, MinMaxWritable> {

    private MinMaxWritable minmax = new MinMaxWritable();

    @Override
    protected void reduce(Text key, Iterable<MinMaxWritable> values, Context context)
            throws IOException, InterruptedException {

        float min = Float.MAX_VALUE;
        float max = Float.MIN_VALUE;

        for (MinMaxWritable value : values) {
            if (value.getMax() > max)
                max = value.getMax();
            if (value.getMin() < min)
                min = value.getMin();
        }

        minmax.setMax(max);
        minmax.setMin(min);
        context.write(key, minmax);
    }
}
