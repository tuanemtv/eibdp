package test.org.eib.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class Main {

	public static void main(String[] argv) throws Exception {
	    String driverName = "oracle.jdbc.driver.OracleDriver";
	    Class.forName(driverName);

	    String serverName = "//10.1.36.22";
	    String portNumber = "1521";
	    String sid = "/lora11g"; //live11g lora11g
	    //String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
	    String url = "jdbc:oracle:thin:@//10.1.36.22:1521/lora11g";
	    String username = "myquery";
	    String password = "truongnhom";
	    Connection connection = DriverManager.getConnection(url, username, password);

	    Statement stmt = connection.createStatement();
	    String function = "CREATE OR REPLACE FUNCTION myfuncout(x OUT VARCHAR) RETURN VARCHAR IS "
	        + "BEGIN " + "x:= 'outvalue'; " + "RETURN 'a returned string'; " + "END;";
	    stmt.executeUpdate(function);

	  }

}
