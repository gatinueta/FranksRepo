import java.security.SignedObject;

public class sign {
	public static void main(String[] args) {
		String algorithm = "SHA1withDSA";
		String provider = null; //default
		Signature signingEngine = 
			Signature.getInstance( algorithm );

		signingEngine.initSign( new PrivateKey( "hrzwngl" ));

		signingEngine.update(new byte[]("oh when the saints"));
		byte[] ba = signingEngine.sign();
	}
}





