package it.polito.bigdata.hadoop;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class ReducerBigData extends Reducer<Text, Text, Text, Text> {

    private Text occurrences = new Text();

    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context)
            throws IOException, InterruptedException {

        ArrayList<String> dates = new ArrayList<String>();

        for (Text date : values) {
            dates.add(date.toString());
        }

        occurrences.set(dates.toString());
        context.write(key, occurrences);
    }
}
