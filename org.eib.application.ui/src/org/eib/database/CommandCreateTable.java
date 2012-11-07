package org.eib.database;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

public class CommandCreateTable {

	static void commandCreateTable(Connection conn, String query) {
	    Statement stmt = null;
	    try {
	        stmt = conn.createStatement();
	        boolean resp = stmt.execute(query);
	        if (!resp) {
	            return;
	
	        }
	
	        ResultSet rs = stmt.getResultSet();
	        ResultSetMetaData rsmd = rs.getMetaData();
	
	        //System.out.println("CREATE TABLE " + rsmd.getTableName(1) + " (");
	        for (int i = 1; i <= rsmd.getColumnCount(); i++) {
	            //System.out.print("    " + rsmd.getColumnName(i) + "    ");
	            String scale = "";
	            if (rsmd.getScale(i) != 0) {
	                scale = "," + rsmd.getScale(i);
	            }
	            //System.out.print(rsmd.getColumnTypeName(i) + "(" + rsmd.getPrecision(i) + "" + scale + ")");
	            if (i != rsmd.getColumnCount()) {
	                //System.out.print(",");
	            }
	           // System.out.println();
	
	        }
	       // System.out.println(")");
	
	
	    } catch (Exception e) {
	    } finally {
	        try {
	            stmt.close();
	        } catch (SQLException ex) {
	        }
	
	    }
	}

}