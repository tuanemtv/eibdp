package org.eib.thread;

import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.eib.database.Query;

public class MultiQueryToExcel {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		//Lay thong tin
		MainCommon a =new MainCommon("app2");
		/*
		for (int i=0; i<a.get_query().length; i++){
			System.out.println("["+i+"]-----------------");
			a.get_query()[i].logQuery();
		}*/
		
		//System.out.println("\n");
		
		//Sap xep lai query
		a.sortQueryWithPriority();
		/*
		for (int i=0; i<a.get_query().length; i++){
			System.out.println("["+i+"]-----------------");
			a.get_query()[i].logQuery();
		}*/
		
		//Lay define tu he thong
		QueryServer _qurser = new QueryServer();
        Query _qur = new Query();

		_qurser = a.getQueryServerFromID("Oralce-ALONE29"); //Oralce-AReport    //            

		//_qurser = a.getQueryServerFromID("MySQL-test"); //Oralce-AReport , Oralce-ALONE29                

        _qurser.connectDatabase();
        
        _qur = a.getQueryFromID("DEF001");
        _qur.queryToAppDefine(a.get_appcommon(), _qurser);
        //a.get_appcommon().logAppCommon();
        
        //Tien hanh chay query
        //set cac thong tin cua Query
        for (int j=0; j<a.get_query().length;j++){
        	a.get_query()[j].set_fileurl(a.get_appcommon().get_scriptUrl()+a.get_query()[j].get_fileurl());
    		//doc file
        	a.get_query()[j].readScript();    	
    		//this.logQuery();
        	a.get_query()[j].set_define(a.get_appcommon().get_define());
        	a.get_query()[j].setquery();        	
        	//a.get_query()[j].logQuery();
        }
        
        //RunMulConScript.commandMulQueryExcel(_qurser, a.get_query(), a.get_appcommon());
        
        //Chay thu 1 script
        //_qur = a.getQueryFromID("DP005");
        //_qur.logQuery();
        
        //_qur.queryToExcel(a.get_appcommon(), _qurser);
        
	}

}
