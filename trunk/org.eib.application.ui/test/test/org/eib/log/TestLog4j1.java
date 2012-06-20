package test.org.eib.log;

import org.apache.log4j.Logger;

public class TestLog4j1 {
	private static Logger logger =Logger.getLogger("GG");
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		 logger.info("Unable to disconnect from FTP server " + "after server refused connection. "+"Tuan em");
		  logger.info("\n");
		  logger.error("Error ne");
		  logger.error("Error ne2");
		  /*
		  for(int i=1 ; i<10000; i++) {
              System.out.println("Counter = " + i);
              logger.debug("This is my debug message. Counter = " + i);
              logger.info("This is my info message. Counter = " + i);
              logger.warn("This is my warn message. Counter = " + i);
              logger.error("This is my error message. Counter = " + i);
              logger.fatal("This is my fatal message.Counter = " + i);
           }*/
	}

}
