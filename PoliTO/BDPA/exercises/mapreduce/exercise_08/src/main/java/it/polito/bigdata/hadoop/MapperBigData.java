package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

class MapperBigData extends Mapper<Text, Text, Text, Text> {

    protected void map(Text key, Text value, Context context)
            throws IOException, InterruptedException {
        String[] words = value.toString().split("\\s+");

        for (String word : words) {
            if (word.equals("not") || word.equals("or") || word.equals("and"))
                continue;

            context.write(new Text(word.toLowerCase()), key);
        }

    }
}
