package ch.frank.helloBoof;

import boofcv.io.image.UtilImageIO;
import boofcv.struct.image.GrayU8;

public class HelloBoofCv {
	public static void main(String[] args) {
		GrayU8 image = new GrayU8(100, 150);
		String fileName = "gray.png";
		UtilImageIO.saveImage(image, fileName);
		
	}
}
