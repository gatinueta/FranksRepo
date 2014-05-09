import java.awt.*;
import java.awt.image.*;
import javax.imageio.*;
import com.sun.media.imageio.plugins.tiff.TIFFImageWriteParam;
import java.io.File;
import java.util.Locale;
import java.util.Iterator;

public class TiffWriter {
    public static void main(String[] args) {
    }

    protected boolean saveTiff(String filename, BufferedImage image) {
    File tiffFile = new File(filename);
	ImageOutputStream ios = null;
	ImageWriter writer = null;

	try {
		// find an appropriate writer
		Iterator it = ImageIO.getImageWritersByFormatName("TIF");
		if (it.hasNext()) {
			writer = (ImageWriter)it.next();
		} else {
			return false;
		}

		// setup writer
		ios = ImageIO.createImageOutputStream(tiffFile);
		writer.setOutput(ios);
		TIFFImageWriteParam writeParam = new TIFFImageWriteParam(Locale.ENGLISH);
		writeParam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
		// see writeParam.getCompressionTypes() for available compression type strings
		writeParam.setCompressionType("PackBits");

		// convert to an IIOImage
		IIOImage iioImage = new IIOImage(image, null, null);

		// write it!
		writer.write(null, iioImage, writeParam);
	} catch (IOException e) {
		e.printStackTrace();
		return false;
	}
	return true;
    }
}
	
