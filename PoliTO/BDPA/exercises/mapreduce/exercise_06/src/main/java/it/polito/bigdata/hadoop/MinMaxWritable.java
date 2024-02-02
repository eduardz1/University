package it.polito.bigdata.hadoop;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import org.apache.hadoop.io.Writable;

public class MinMaxWritable implements Writable {

    private float min = Float.MAX_VALUE;
    private float max = Float.MIN_VALUE;

    public float getMin() {
        return min;
    }

    public void setMin(float min) {
        this.min = min;
    }

    public float getMax() {
        return max;
    }

    public void setMax(float max) {
        this.max = max;
    }

    @Override
    public void write(DataOutput out) throws IOException {
        out.writeFloat(min);
        out.writeFloat(max);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        min = in.readFloat();
        max = in.readFloat();
    }

    @Override
    public String toString() {
        return "max=" + max + "_min=" + min;
    }

}
