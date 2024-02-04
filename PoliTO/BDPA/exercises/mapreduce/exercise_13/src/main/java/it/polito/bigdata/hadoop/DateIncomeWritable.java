package it.polito.bigdata.hadoop;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import org.apache.hadoop.io.Writable;

class DateIncomeWritable implements Writable {
    private String date = null;
    private int income = Integer.MIN_VALUE;

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getIncome() {
        return income;
    }

    public void setIncome(int income) {
        this.income = income;
    }

    @Override
    public void write(DataOutput out) throws IOException {
        out.writeUTF(date);
        out.writeInt(income);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        date = in.readUTF();
        income = in.readInt();
    }
}
