package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReducerBigData extends Reducer<NullWritable, DateIncomeWritable, Text, IntWritable> {

    private Text date = new Text();
    private IntWritable income = new IntWritable();

    @Override
    protected void reduce(NullWritable key, Iterable<DateIncomeWritable> values,
            Reducer<NullWritable, DateIncomeWritable, Text, IntWritable>.Context context)
            throws IOException, InterruptedException {

        income.set(Integer.MIN_VALUE);

        for (DateIncomeWritable value : values) {
            if (value.getIncome() > income.get()) {
                date.set(value.getDate());
                income.set(value.getIncome());
            }
        }

        context.write(date, income);
    }
}
