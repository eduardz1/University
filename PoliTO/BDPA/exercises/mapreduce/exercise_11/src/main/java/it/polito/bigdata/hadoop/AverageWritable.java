package it.polito.bigdata.hadoop;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import org.apache.hadoop.io.Writable;

public class AverageWritable implements Writable {
    private float sum = 0;
    private int count = 0;

    public float getSum() {
        return sum;
    }

    public void setSum(float sum) {
        this.sum = sum;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    @Override
    public void write(DataOutput out) throws IOException {
        out.writeInt(count);
        out.writeFloat(sum);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        count = in.readInt();
        sum = in.readFloat();
    }

    @Override
    public String toString() {
        return "" + (float) sum / count;
    }

}
