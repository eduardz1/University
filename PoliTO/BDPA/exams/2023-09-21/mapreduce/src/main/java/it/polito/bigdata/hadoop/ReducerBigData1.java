package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData1 extends Reducer<Text, NullWritable, NullWritable, Text> {
    @Override
    protected void reduce(Text key, Iterable<NullWritable> values,
            Reducer<Text, NullWritable, NullWritable, Text>.Context context)
            throws IOException, InterruptedException {

        int numEpisodes = 0;
        for (@SuppressWarnings("unused")
        NullWritable value : values) {
            numEpisodes++;
        }

        context.write(
                NullWritable.get(),
                new Text(key.toString() + "," + (numEpisodes > 10 ? "L" : "S")));
    }
}
