package test.org.eib.log;

import java.io.File;
import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.Logger;


public class GetLog4j {
	static Logger log = Logger.getLogger("GetLog4j");

	public static void main(String[] args) {
			
	        //String homeDir = context.getRealPath("/");
	        //File propertiesFile = new File(homeDir, "WEB-INF/log4j.properties");
		File propertiesFile = new File( "test/log4j.properties");
	        PropertyConfigurator.configure(propertiesFile.toString());
	        log.info("This is a test");
	   
	}

}
