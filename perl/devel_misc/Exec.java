public class Exec {
	public static void main(String[] args) {
		Process p = Runtime.getRuntime().exec("cmd /C dir");
		InputStream is = p.getInputStream();

		byte[] ba = new byte[1024];
		int len;

		StringBuilder output;
		while ((len = is.read(ba)) >= 0) {
			output += new String(ba, 0, len);
		}
		System.out.println( output );
	}
}

