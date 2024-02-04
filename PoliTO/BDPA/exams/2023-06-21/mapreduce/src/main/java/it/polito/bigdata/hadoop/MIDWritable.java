package it.polito.bigdata.hadoop;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import org.apache.hadoop.io.Writable;

class MIDWritable implements Writable {
    private String MID = "AAA";
    private int numParticipants = -1;

    public String getMID() {
        return MID;
    }

    public void setMID(String mID) {
        MID = mID;
    }

    public int getNumParticipants() {
        return numParticipants;
    }

    public void setNumParticipants(int numParticipants) {
        this.numParticipants = numParticipants;
    }

    @Override
    public void write(DataOutput out) throws IOException {
        out.writeInt(numParticipants);
        out.writeUTF(MID);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        numParticipants = in.readInt();
        MID = in.readUTF();
    }

}
