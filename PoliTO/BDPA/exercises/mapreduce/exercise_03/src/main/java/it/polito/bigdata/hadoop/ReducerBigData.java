package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class ReducerBigData extends Reducer<Text, IntWritable, Text, IntWritable> {

    private IntWritable occurrences = new IntWritable();

    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws IOException, InterruptedException {

        for (IntWritable value : values) {
            occurrences.set(occurrences.get() + value.get());
        }

        context.write(key, occurrences);
    }
}
