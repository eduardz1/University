package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

class ReducerBigData extends Reducer<Text, AverageWritable, Text, AverageWritable> {

    private AverageWritable average = new AverageWritable();

    @Override
    protected void reduce(Text key, Iterable<AverageWritable> values,
            Reducer<Text, AverageWritable, Text, AverageWritable>.Context context)
            throws IOException, InterruptedException {
        int count = 0;
        float sum = 0;

        for (AverageWritable value : values) {
            count += value.getCount();
            sum += value.getSum();
        }

        average.setCount(count);
        average.setSum(sum);

        context.write(key, average);
    }
}
