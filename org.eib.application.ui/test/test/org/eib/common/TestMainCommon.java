package test.org.eib.common;

import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.eib.database.Query;
import org.eib.thread.ThreadPoolRunQuery;

public class TestMainCommon {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		MainCommon a =new MainCommon("app","1","all");
		
		a.get_appcommon().logAppCommon();
		a.logQuery();
		//a.logQueryCron();
		//a.logQueryServer();
		a.sortQueryWithModule();
		
		a.logTimeQuery(a.get_query());
		/*
		for (int i=0; i<a.get_query().length; i++){
			System.out.println("["+i+"]-----------------");
			a.get_query()[i].logQuery();
		}
		
		System.out.println("\n");
		
		a.sortQueryWithPriority();
		for (int i=0; i<a.get_query().length; i++){
			System.out.println("["+i+"]-----------------");
			a.get_query()[i].logQuery();
		}*/
		
		QueryServer _qurser = new QueryServer();
        Query _qur = new Query();
		_qurser = a.getQueryServerFromID("MySQL-test"); //Oralce-AReport , Oralce-ALONE29       MySQL-test          
        _qurser.connectDatabase();
		
        _qur = a.getQueryFromID("DEF003"); //DEF002: Ngay he thong, DEF003 test
        _qur.queryToAppDefine(a.get_appcommon(), _qurser);  
        
        a.sortQueryWithPriority();	
		
		//set cac thong tin cua Query
        for (int j=0; j<a.get_query().length;j++)
        {        
        	if (a.get_query()[j].get_module().equals("AA")){
        		
        	}else{
	        	a.get_query()[j].set_querynm(a.get_appcommon().get_define().get("01h_trdt")+"_"+a.get_query()[j].get_querynm());
	        	a.get_query()[j].set_fileurl(a.get_appcommon().get_scriptUrl()+a.get_query()[j].get_fileurl());
	    		//doc file
	        	a.get_query()[j].readScript();    	
	    		//this.logQuery();
	        	a.get_query()[j].set_define(a.get_appcommon().get_define());
	        	a.get_query()[j].setquery();        	
	        	//main.get_query()[j].logQuery();
        	}
        } 
        
        
		ThreadPoolRunQuery.RunQueryToExcel(_qurser, a.get_query(), a.get_appcommon());
	}

}
