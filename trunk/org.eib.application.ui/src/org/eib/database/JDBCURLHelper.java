package org.eib.database;

public class JDBCURLHelper {

	public static String generateURL(String driver, String host, int port, String database) {
	    if (driver.equals(JDBCSqlConsole.DRIVER_ORACLE)) {
	        if (port == -1) {
	            port = 1526;
	        }
	        return "jdbc:oracle:thin:@//" + host + ":" + port + "/" + database;
	    }
	    if (driver.equals(JDBCSqlConsole.DRIVER_MYSQL)) {
	        if (port == -1) {
	            return "jdbc:mysql://" + host + "/" + database;
	        } else {
	            return "jdbc:mysql://" + host + ":" + port + "/" + database;
	        }
	    }
	    if (driver.equals(JDBCSqlConsole.DRIVER_POSTGRESQL)) {
	        if (port == -1) {
	            return "jdbc:postgresql://" + host + "/" + database;
	        } else {
	            return "jdbc:postgresql://" + host + ":" + port + "/" + database;
	        }
	    }
	    if (driver.equals(JDBCSqlConsole.DRIVER_SQLSERVER)) {
	        if (port == -1) {
	            return "jdbc:sqlserver://" + host + ";databaseName=" + database;
	        } else {
	            return "jdbc:sqlserver://" + host + ":" + port + ";databaseName=" + database;
	        }
	    }
	
	    return null;
	}

}