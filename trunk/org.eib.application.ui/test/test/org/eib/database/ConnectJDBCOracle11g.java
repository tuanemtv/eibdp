package test.org.eib.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectJDBCOracle11g {

public static void main (String [] args) {
	 String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver"; //oracle.jdbc.OracleDriver //oracle.jdbc.driver.OracleDriver
	 String JDBC_STRING = "jdbc:oracle:thin:@//10.1.36.22:1521/lora11g";	 
	 String USER_NAME = "myquery";
	 String PASSWD = "truongnhom";
	 Connection conn = null;
	 ResultSet rs = null;
	 Statement stmt = null;
	 try {
		 Class.forName (JDBC_DRIVER);
		 conn = DriverManager.getConnection (JDBC_STRING, USER_NAME, PASSWD);
		 stmt = conn.createStatement ();

		 String query = "select * from tbdp_savmst where brcd ='2000' and rownum<10";
		 rs = stmt.executeQuery (query);
		 while (rs.next()) {
             //for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                 //System.out.print(rs.getString(i) + separator);
             //}
             System.out.println("adfd");
		 }
	 } catch (SQLException sqlEx) {
		 sqlEx.printStackTrace ();
	 } catch (ClassNotFoundException e) {
		 e.printStackTrace ();
	 } finally {
		 try {
			 if (rs != null)
				 rs.close ();
			 if (stmt != null) stmt.close ();
			 if (conn != null) conn.close ();
		 } catch (SQLException e) {
			 e.printStackTrace ();
		 }
	 }
}
}