package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData2 extends Mapper<Text, Text, Text, FloatWritable> {

    private Text date = new Text();
    private FloatWritable amount = new FloatWritable();

    protected void map(Text key, Text value, Context context)
            throws IOException, InterruptedException {

        String[] fields = key.toString().split("-");
        date.set(String.format(fields[0]));

        amount.set(Float.parseFloat(value.toString()));

        context.write(date, amount);
    }
}
