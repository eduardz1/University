package it.polito.bigdata.hadoop;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * Basic MapReduce Project - Reducer
 */
class ReducerBigData extends Reducer<Text, Text, Text, Text> {

    private Text text = new Text();

    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context)
            throws IOException, InterruptedException {

        ArrayList<String> sentences = new ArrayList<>();

        for (Text value : values) {
            sentences.add(value.toString());
        }

        text.set(sentences.toString());
        context.write(key, text);
    }
}
