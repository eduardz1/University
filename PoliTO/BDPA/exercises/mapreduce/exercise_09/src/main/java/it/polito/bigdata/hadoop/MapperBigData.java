package it.polito.bigdata.hadoop;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<LongWritable, Text, Text, IntWritable> {

    private Map<String, Integer> words;

    @Override
    protected void setup(Mapper<LongWritable, Text, Text, IntWritable>.Context context)
            throws IOException, InterruptedException {
        words = new HashMap<>();
    }

    private Text word = new Text();
    private IntWritable count = new IntWritable();

    protected void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {

        String[] wordList = value.toString().split("\\s+");

        for (String wordInstance : wordList) {
            words.put(wordInstance.toLowerCase(), words.getOrDefault(wordInstance, 0) + 1);
        }
    }

    @Override
    protected void cleanup(Mapper<LongWritable, Text, Text, IntWritable>.Context context)
            throws IOException, InterruptedException {
        for (Entry<String, Integer> entry : words.entrySet()) {
            word.set(entry.getKey());
            count.set(entry.getValue());
            context.write(word, count);
        }
    }
}
