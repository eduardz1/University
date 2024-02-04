package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData2 extends Mapper<Text, Text, NullWritable, MIDWritable> {

    private MIDWritable largestMeeting;

    @Override
    protected void setup(Mapper<Text, Text, NullWritable, MIDWritable>.Context context)
            throws IOException, InterruptedException {
        largestMeeting = new MIDWritable();
    }

    protected void map(Text key, Text value, Context context)
            throws IOException, InterruptedException {

        int val = Integer.parseInt(value.toString());

        if (val < largestMeeting.getNumParticipants())
            return;

        if (val == largestMeeting.getNumParticipants()) {
            if (key.toString().compareTo(largestMeeting.getMID()) > 0) {
                largestMeeting.setMID(key.toString());
                largestMeeting.setNumParticipants(val);
                return;
            }
        }

        if (val > largestMeeting.getNumParticipants()) {
            largestMeeting.setMID(key.toString());
            largestMeeting.setNumParticipants(val);
        }
    }

    @Override
    protected void cleanup(Mapper<Text, Text, NullWritable, MIDWritable>.Context context)
            throws IOException, InterruptedException {
        context.write(NullWritable.get(), largestMeeting);
    }
}
