package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<Text, Text, NullWritable, DateIncomeWritable> {

    private DateIncomeWritable dateIncome;

    @Override
    protected void setup(Mapper<Text, Text, NullWritable, DateIncomeWritable>.Context context)
            throws IOException, InterruptedException {
        dateIncome = new DateIncomeWritable();
    }

    protected void map(Text key, Text value, Context context)
            throws IOException, InterruptedException {

        int intValue = Integer.parseInt(value.toString());

        if (intValue > dateIncome.getIncome()) {
            dateIncome.setIncome(intValue);
            dateIncome.setDate(key.toString());
        }
    }

    @Override
    protected void cleanup(Mapper<Text, Text, NullWritable, DateIncomeWritable>.Context context)
            throws IOException, InterruptedException {
        context.write(NullWritable.get(), dateIncome);
    }
}
