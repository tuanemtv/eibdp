package org.eib.cron;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.eib.common.FolderUtil;
import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QueryJob implements Job{
	private static Logger logger =Logger.getLogger("QueryJob");
	
	
	public void execute(JobExecutionContext context)
			throws JobExecutionException {
		
		JobDataMap data = context.getJobDetail().getJobDataMap();		
		logger.info("_cronNM= " + data.getString("_cronNM"));
		
		
		MainCommon main = new MainCommon();
		
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
		for (int i=0; i< main.get_querycron().length; i++){
			if (data.getString("_cronNM").equals(main.get_querycron()[i].get_cronNM())){
				//logger.info("[i="+i+"] bang roi");
				
				//Tim query
				for (int j=0; j< main.get_querycron()[i].get_queryid().length;j++){//For cai queryid cua Cron
					//logger.info("[j="+j+"] bang roi" +main.get_querycron()[i].get_queryid()[j]);
					
					for (int k=0; k<main.get_query().length; k++){
						
						if (main.get_querycron()[i].get_queryid()[j].equals(main.get_querycron()[i].get_cronNM()+"."+main.get_query()[k].get_queryid())){
							
							logger.info("[k="+k+"] = " +main.get_query()[k].get_queryid());
														
							DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
							Date date = new Date();
							//logger.info(dateFormat.format(date));
							
							//Xet lai ten dung
							main.get_query()[k].set_querynm(dateFormat.format(date)+" - "+main.get_query()[k].get_querynm());
							
							//Connect va chay Query
							//main.get_queryser().connectDatabase();							
							//main.get_query()[k].queryToExcel(main.get_appcommon(), main.getQueryser());
							
							QueryServer _qurser = new QueryServer();
							_qurser = main.getQueryServerFromID(main.get_querycron()[i].get_databaseID());
							_qurser.connectDatabase();
							if (main.get_query()[k].get_queryid().equals("G001") || main.get_query()[k].get_queryid().equals("G002") ){
								main.get_query()[k].queryToStringExcel(main.get_appcommon(), _qurser);
							}else{
								main.get_query()[k].queryToExcel(main.get_appcommon(), _qurser);
							}
							
						}
					}
				}
			}
		}
		
	}
}
