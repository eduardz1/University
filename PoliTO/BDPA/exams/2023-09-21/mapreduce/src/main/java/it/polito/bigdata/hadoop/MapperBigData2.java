package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData2 extends Mapper<LongWritable, Text, Text, Text> {

    // @Override
    // protected void setup(Mapper<Text, Text, NullWritable,
    // DateIncomeWritable>.Context context)
    // throws IOException, InterruptedException {
    // dateIncome = new DateIncomeWritable();
    // }

    protected void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {

        String[] fields = value.toString().split(",");

        context.write(
                new Text(fields[0]),
                new Text(fields[2]));
    }

    // @Override
    // protected void cleanup(Mapper<Text, Text, Text, Text>.Context context)
    // throws IOException, InterruptedException {
    // context.write(NullWritable.get(), dateIncome);
    // }
}
