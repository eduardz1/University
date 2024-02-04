package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import it.polito.bigdata.hadoop.DriverBigData.MY_COUNTERS;

class MapperBigData extends Mapper<LongWritable, Text, NullWritable, NullWritable> {

    protected void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {

        context.getCounter(MY_COUNTERS.TOTAL_RECORDS).increment(1);
    }
}
