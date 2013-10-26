package test.org.eib.database;

import org.eib.common.QueryServer;
import org.eib.database.CommandQuery;

public class TestCommandQuery {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		 
		//String _query= "DELIMITER $$ CREATE FUNCTION hello_world()   RETURNS TEXT   LANGUAGE SQL BEGIN    RETURN 'Hello World'; END; $$ DELIMITER ;";
		
		String _query= "create procedure SHOW_SUPPLIERS() " +
        "begin " +
            "select SUPPLIERS.SUP_NAME, " +
            "COFFEES.COF_NAME " +
            "from SUPPLIERS, COFFEES " +
            "where SUPPLIERS.SUP_ID = " +
            "COFFEES.SUP_ID " +
            "order by SUP_NAME; " +
        "end";
		
		QueryServer queryser =new QueryServer();
		
		queryser.setDatabase("athena");
		queryser.setDriver("com.mysql.jdbc.Driver");
		queryser.setHost("127.0.0.1");
		
		queryser.setPort(3306);
		queryser.setUser("root");
		queryser.setPassword("pmR98uhLhYcm+Ph8jY7djw==");
		
		
		queryser.connectDatabase();
		//queryser.logQueryServer();
		System.out.println(queryser.get_conn());
		
		//CommandQuery.commandFunctions(queryser.get_conn(), _query);
		
		CommandQuery.commandFile(queryser.get_conn(), "D:\\Excel\\Script\\Insert\\MySQL_CreateTable.sql");
		//QueryServer _qurser = new QueryServer();
		//_qurser = main.getQueryServerFromID(data.getString("_databaseID")); 
	}

}
