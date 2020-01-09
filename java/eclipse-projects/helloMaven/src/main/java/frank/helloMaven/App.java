package frank.helloMaven;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import sun.security.x509.X500Name;

/**
 * Hello world!
 *
 */
public class App 
{
	static final Logger LOG = LoggerFactory.getLogger(App.class);
    public static void main( String[] args ) throws IOException
    {
    	LOG.info("Hello world!");
        X500Name name = new X500Name("cn=Me");
        LOG.info("the common name is " + name.getCommonName());
    }
}
