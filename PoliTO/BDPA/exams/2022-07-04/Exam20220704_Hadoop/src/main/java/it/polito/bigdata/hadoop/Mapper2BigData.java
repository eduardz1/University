package it.polito.bigdata.hadoop;

import java.io.IOException;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

/**
 * Basic MapReduce Project - Mapper
 */
class Mapper2BigData extends Mapper<Text, // Input key type
		Text, // Input value type
		NullWritable, // Output key type
		Text> {// Output value type

	protected void map(Text key, // Input key type
			Text value, // Input value type
			Context context) throws IOException, InterruptedException {

		context.write(NullWritable.get(), new Text(key.toString() + "_" + value.toString()));
	}
}
