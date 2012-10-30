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
		
		//main.get_query()[3].queryToExcel(main.get_appcommon(), _qurser); //Test query Number
		//main.get_query()[4].queryToFunctions(main.get_appcommon(), _qurser); //Test create Function
	
		main.get_query()[5].queryToAppDefine(main.get_appcommon(), _qurser);//Test get define
		main.get_appcommon().logAppCommon();		
		main.get_query()[5].logQuery();
		main.get_query()[5].set_define(main.get_appcommon().get_define());
		main.get_query()[5].logQuery();
		
	}

}
