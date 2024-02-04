package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData2 extends Reducer<NullWritable, MIDWritable, Text, Text> {

    private MIDWritable result = new MIDWritable();

    @Override
    protected void reduce(NullWritable key, Iterable<MIDWritable> values,
            Reducer<NullWritable, MIDWritable, Text, Text>.Context context)
            throws IOException, InterruptedException {

        int max = -1;
        for (MIDWritable value : values) {
            int curr = value.getNumParticipants();

            if (curr > max) {
                max = curr;
                result.setMID(value.getMID());
                result.setNumParticipants(curr);
            }

            if (curr == max) {
                if (value.getMID().compareTo(result.getMID()) > 0) {
                    result.setMID(value.getMID());
                }
            }
        }

        context.write(
                new Text(result.getMID()),
                new Text(String.format("" + result.getNumParticipants())));
    }
}
