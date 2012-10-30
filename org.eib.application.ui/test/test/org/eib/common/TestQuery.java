package test.org.eib.common;

import org.eib.common.MainCommon;
import org.eib.common.QueryServer;

public class TestQuery {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MainCommon main =new MainCommon();
		
		QueryServer _qurser = new QueryServer();
		
		_qurser = main.getQueryServerFromID("MySQL-test");
		_qurser.connectDatabase();
		
		main.get_query()[3].queryToExcel(main.get_appcommon(), _qurser);
	}

}
