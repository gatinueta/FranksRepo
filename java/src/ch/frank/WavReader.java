package ch.frank;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class WavReader {
	public static void main(String[] args) throws IOException {
		String filename;
		if (args.length > 0) {
			filename = args[0];
		} else {
			filename = "adios.wav";
		}
		try (RandomAccessFile f = new RandomAccessFile(filename, "r")) {
			byte[] header = new byte[36];
			f.readFully(header);
			ByteBuffer bb = ByteBuffer.wrap(header).order(ByteOrder.LITTLE_ENDIAN);
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
			
			byte[] dataDesc = new byte[8];
			f.read(dataDesc);
			bb = ByteBuffer.wrap(dataDesc).order(ByteOrder.LITTLE_ENDIAN);
			bb.get(format);
			System.out.println("data chunk:" + new String(format));
			int dataSize = bb.getInt();
			System.out.println("data size=" + dataSize);
			
			
		}
	}
}
