package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class Reducer2BigData extends Reducer<NullWritable, // Input key type
        Text, // Input value type
        Text, // Output key type
        IntWritable> { // Output value type

    @Override
    protected void reduce(
            NullWritable key, // Input key type
            Iterable<Text> values, // Input value type
            Context context) throws IOException, InterruptedException {

        String maxOs = "";
        int maxCount = 0;

        // this for cycle should be iterated just once
        for (Text i : values) {
            String t = i.toString();
            String[] fields = t.split("_");
            String os = fields[0];
            int count = Integer.parseInt(fields[1]);

            if (maxCount == 0 ||
                    (maxCount == count && os.compareTo(maxOs) < 0) ||
                    count > maxCount) {
                maxCount = count;
                maxOs = os;
            }
        }

        context.write(new Text(maxOs), new IntWritable(maxCount));

    }
}
