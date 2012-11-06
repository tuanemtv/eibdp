package org.eib.cron;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.eib.common.FolderUtil;
import org.eib.common.MainCommon;
import org.eib.common.QueryCron;
import org.eib.common.QueryServer;
import org.eib.database.Query;
import org.eib.thread.RunMulConScript;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 * Dung de test MySQL
 * @author GOGO Tran
 *
 */
public class QueryJobTest implements Job{
	
	private static Logger logger =Logger.getLogger("QueryJobTest");	
	
	public void execute(JobExecutionContext context)
			throws JobExecutionException {
		
		JobDataMap data = context.getJobDetail().getJobDataMap();		
		logger.info("_cronNM= " + data.getString("_cronNM"));
		
		
		MainCommon main = new MainCommon("app");
		//main.get_querycron()[0].logQueryCron();
		//main.get_querycron()[1].logQueryCron();
		
		Date date1 ;
		DateFormat dateFormat1;
		DateFormat dateFormat2;
		
		dateFormat1 = new SimpleDateFormat("yyyyMMdd");	
		date1= new Date();
		//Set lai duong dan out
		main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat1.format(date1)+"\\");		
		FolderUtil.createFolder(main.get_appcommon().get_outurl());
		
		dateFormat2 = new SimpleDateFormat("HHmm");	
		date1= new Date();
		main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat2.format(date1)+"\\");				
		//Tao folder
		FolderUtil.createFolder(main.get_appcommon().get_outurl());
				
		
		//Tim cron dung
		//QueryCron _quecron = new QueryCron();
		//_quecron = main.getQueryCronFromName(data.getString("_cronNM"));
		//_quecron.logQueryCron();
		
		
		String [] a= null;
		a = main.getQueryIDFromName(data.getString("_cronNM"));
		

		Query[] _arrQueryTemp = new Query[a.length];
		
		_arrQueryTemp = main.getQueryFromQueryID(a);
		
		for(int l=0; l<_arrQueryTemp.length; l++){
			_arrQueryTemp[l].logQuery();
		}
		
		//main.logQuery();
		main.set_query(_arrQueryTemp);
		
		//logger.info("\n\n Sau");
		//main.logQuery();
		
		//Chay multi
		
		main.sortQueryWithPriority();
		
		//logger.info("\n\n Sort lai");
		//main.logQuery();
		
		
		QueryServer _qurser = new QueryServer();
        Query _qur = new Query();
		_qurser = main.getQueryServerFromID("Oralce-ALONE29"); //Oralce-AReport , Oralce-ALONE29       MySQL-test          
        _qurser.connectDatabase();
        
        /*
        _qur = main.getQueryFromID("DEF001");
        _qur.queryToAppDefine(main.get_appcommon(), _qurser);
        */
        //a.get_appcommon().logAppCommon();
        
        //Tien hanh chay query
        //set cac thong tin cua Query
        for (int j=0; j<main.get_query().length;j++){
        	main.get_query()[j].set_fileurl(main.get_appcommon().get_scriptUrl()+main.get_query()[j].get_fileurl());
    		//doc file
        	main.get_query()[j].readScript();    	
    		//this.logQuery();
        	main.get_query()[j].set_define(main.get_appcommon().get_define());
        	main.get_query()[j].setquery();        	
        	//a.get_query()[j].logQuery();
        }
        
        
        RunMulConScript.commandMulQueryExcel(_qurser, main.get_query(), main.get_appcommon());
      
		
	}
}
