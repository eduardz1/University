package it.polito.bigdata.hadoop;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map.Entry;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

/**
 * Basic MapReduce Project - Mapper
 */
class Mapper1BigData extends Mapper<LongWritable, // Input key type
        Text, // Input value type
        Text, // Output key type
        IntWritable> {// Output value type

    protected void map(
            LongWritable key, // Input key type
            Text value, // Input value type
            Context context) throws IOException, InterruptedException {

        String[] fields = value.toString().split(",");
        String os = fields[2];
        String date = fields[1];

        if (date.compareTo("2021/07/04") >= 0 && date.compareTo("2022/07/03") <= 0) {
            context.write(new Text(os), new IntWritable(1));
        }
    }
}
