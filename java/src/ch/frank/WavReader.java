package ch.frank;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.channels.FileChannel;

public class WavReader {
	interface DataReceiver {
		Number get(ByteBuffer sampleBuf);
	}
	
	static class DataReceiver8 implements DataReceiver {
		@Override
		public Number get(ByteBuffer sampleBuf) {
			return sampleBuf.get();
		}
	}
	static class DataReceiver16 implements DataReceiver {
		@Override
		public Number get(ByteBuffer sampleBuf) {
			return sampleBuf.getShort();
		}
	}
	static class DataReceiver32 implements DataReceiver {
		@Override
		public Number get(ByteBuffer sampleBuf) {
			return sampleBuf.getInt();
		}
	}
	private static DataReceiver getDataReceiver(int bitsPerSample) {
		switch(bitsPerSample) {
		case 8:
			return new DataReceiver8();
		case 16:
			return new DataReceiver16();
		case 32:
			return new DataReceiver32();
		default:
			throw new IllegalArgumentException("unsupported bits per sample: " + bitsPerSample);
		}
	}
	
	public static void main(String[] args) throws IOException {
		String filename;
		if (args.length > 0) {
			filename = args[0];
		} else {
			filename = "adios.wav";
		}
		try (RandomAccessFile raf = new RandomAccessFile(filename, "r")) {
			FileChannel fc = raf.getChannel();
			ByteBuffer bb = ByteBuffer.allocate(36).order(ByteOrder.LITTLE_ENDIAN);
			fc.read(bb);
			bb.position(0);
			byte[] chunkId = new byte[4];
			bb.get(chunkId);
			String chunkIdStr = new String(chunkId);
			if (!"RIFF".equals(chunkIdStr)) {
				throw new IllegalArgumentException("not a RIFF file");
			}
			int chunkSize = bb.getInt();
			System.out.println("chunk size is " + chunkSize);
			byte[] format = new byte[4];
			bb.get(format);
			if (!"WAVE".equals(new String(format))) {
				throw new IllegalArgumentException("not a WAVE file");
			}
			bb.get(format);
			if (!"fmt ".equals(new String(format))) {
				throw new IllegalArgumentException("no fmt sub-chunk");
			}
			int subchunk1Size = bb.getInt();
			System.out.println("subchunk1Size is " + subchunk1Size);
			short audioFormat = bb.getShort();
			if (audioFormat != 1) {
				throw new IllegalArgumentException("unsupported audio format " + audioFormat);
			}
			int numChannels = bb.getShort();
			System.out.println("numChannels=" + numChannels);
			int sampleRate = bb.getInt();
			System.out.println("sample rate=" + sampleRate);
			int byteRate = bb.getInt();
			System.out.println("byte rate=" + byteRate);
			int bytesPerSample = bb.getShort();
			System.out.println("bytes per sample (all channels)=" + bytesPerSample);
			int bitsPerSample = bb.getShort();
			System.out.println("bits per sample=" + bitsPerSample);
			
			bb = ByteBuffer.allocate(8).order(ByteOrder.LITTLE_ENDIAN);
			fc.read(bb);
			bb.position(0);
			bb.get(format);
			System.out.println("data chunk:" + new String(format));
			int dataSize = bb.getInt();
			System.out.println("data size=" + dataSize);
			ByteBuffer sampleBuf = ByteBuffer.allocate(bytesPerSample);
			DataReceiver dataReceiver = getDataReceiver(bitsPerSample);
			for (int i=0; i<dataSize; i++) {
				sampleBuf.clear();
				fc.read(sampleBuf);
				sampleBuf.position(0);
				for (int c=0; c<numChannels; c++) {
					Number data = dataReceiver.get(sampleBuf);
					System.out.println("sample " + i + ", channel " + c + ": " + data);
				}
			}
			
		}
	}
}
