package org.eib.cron.run;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;
import java.util.concurrent.Semaphore;

import org.apache.log4j.Logger;
import org.eib.common.FolderUtil;
import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.eib.database.CommandMultiQuery;
import org.eib.database.Query;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QueryToExcelJob implements Job{
	
	
	private static Logger logger =Logger.getLogger("QueryToExcelJob");		
	private String _databaseID;
	private MainCommon main;
	private Query[] _runQuery;
	private Query _query;
	private Date _date1, _date2;
	private DateFormat _dateFormat1, _dateFormat2;
	
	public void execute(JobExecutionContext context)
			throws JobExecutionException {
		
		
		logger.info("");
		logger.info("");
		logger.info("Running All Script to Excel---------------------------------");
		JobDataMap data = context.getJobDetail().getJobDataMap();		
		logger.info("_cronNM= " + data.getString("_cronNM"));	
		logger.info("_defineScript= " + data.getString("_defineScript"));
		logger.info("_databaseID= " + data.getString("_databaseID"));
		
		ResourceBundle rb = ResourceBundle.getBundle("/resource/app");				
		main = new MainCommon("/resource/app",rb.getString("app_kind"),"all");
		
		_databaseID = data.getString("_databaseID");
		
		Date date1 ;
		DateFormat dateFormat1, dateFormat2;
		
		dateFormat1 = new SimpleDateFormat("yyyyMMdd");	
		date1= new Date();
		//Set lai duong dan out
		main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat1.format(date1)+"\\");		
		FolderUtil.createFolder(main.get_appcommon().get_outurl());
		
		//Tao folder
		dateFormat2 = new SimpleDateFormat("HHmm");	
		date1= new Date();
		main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat2.format(date1)+"\\");			
		FolderUtil.createFolder(main.get_appcommon().get_outurl());		
		
		QueryServer _qurser = new QueryServer();
        Query _qur = new Query();
		_qurser = main.getQueryServerFromID(data.getString("_databaseID")); //Oralce-AReport , Oralce-ALONE29       MySQL-test          
        _qurser.connectDatabase();
		
        //Lay define cho he thong
        _qur = main.getQueryFromID(data.getString("_defineScript")); //DEF002: Ngay he thong, DEF003 test
        _qur.queryToAppDefine(main.get_appcommon(), _qurser);  
        
        //Sort lai query theo thu tu uu tien
		main.sortQueryWithPriority();	
		
		//set cac thong tin cua Query
        for (int j=0; j<main.get_query().length;j++)
        {        	
        	main.get_query()[j].set_querynm(main.get_appcommon().get_define().get("01h_trdt")+"_"+main.get_query()[j].get_querynm());
        	main.get_query()[j].set_fileurl(main.get_appcommon().get_scriptUrl()+main.get_query()[j].get_fileurl());
    		//doc file
        	main.get_query()[j].readScript();    	
    		//this.logQuery();
        	main.get_query()[j].set_define(main.get_appcommon().get_define());
        	main.get_query()[j].setquery();        	
        	//main.get_query()[j].logQuery();
        } 
        
            	
        //Thoi gian bat dau			        
       	_dateFormat1 = new SimpleDateFormat("yyyyMMdd_HHmmss");	        	
		_date1= new Date();
		
		
		_runQuery = main.getRunQuery(main.get_query());
		
		
		Runnable limitedCall = new Runnable() {		
            final Semaphore available = new Semaphore(main.get_appcommon().get_scriptnums());
            int count = 0;	
            
            public void run()
            {               
                int num = count++; //Dung cho mang		                
                try
                {
                    available.acquire();                    
                    for (int l=0; l<_runQuery.length;l++){
                    	if (l == num){
                    	   //numScript = num;
                    		  
                    	   QueryServer _qurser = new QueryServer();						
 		            	  _qurser = main.getQueryServerFromID(_databaseID);
 		            	  _qurser.connectDatabase();
 		            	  
 		            	  _query = new Query();
 		            	  _query = _runQuery[l];
 		            	   
 		            	   logger.info(">> Run " + num+" = "+_runQuery[l].get_querynm());
 		            	   //txtCnt.setText(String.valueOf(num + 1));
 		            	   
 		            	   CommandMultiQuery cq1 = new CommandMultiQuery(_qurser.get_conn(),_query,main.get_appcommon());
 		            	   cq1.run(); 		            	  		 		            	  
                    	}
                    }
                    
                    
                    //Kiem khi nao xong
                    
                    while (main.chekFinishQuery(_runQuery) == 1){
                    	_dateFormat2 = new SimpleDateFormat("yyyyMMdd_HHmmss");	
                        _date2= new Date();
                        
                        Thread.sleep(30000);//30s
                        
                        logger.info("");
                        logger.info("Thoi gian chay -------------------");
                        logger.info("Bat dau : " +_dateFormat1.format(_date1));
                        logger.info("Ket thuc: " +_dateFormat2.format(_date2));
                        logger.info("Tong tg : " + String.valueOf(Math.abs(_date2.getTime() - _date1.getTime())/1000)+"s");
                        //Thong tin
                        logger.info("");
                        logger.info("Chi tiet Thoi gian -------------------");
                        main.logQuerySumReport(_runQuery);
                        main.logQuerySumReport(_runQuery,"DP");
                        main.logQuerySumReport(_runQuery,"LN");
                        main.logQuerySumReport(_runQuery,"GL");
                        main.logQuerySumReport(_runQuery,"TF");
                        main.logQuerySumReport(_runQuery,"DL");
                        main.logQuerySumReport(_runQuery,"EI");
                        main.logQuerySumReport(_runQuery,"CS");
                        logger.info("");
                        logger.info("Chi tiet Script -------------------");
                        main.logShowScript(_runQuery);   
                        
                        return;
					}
                    
                    
                    available.release();
                }
                catch (InterruptedException intEx)
                {
                    intEx.printStackTrace();
                }
            }		            		           
        };
        
        for (int i=0; i<_runQuery.length; i++)
            new Thread(limitedCall).start();
		
                
		
	}
}
