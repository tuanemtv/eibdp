package org.eib.cron;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.eib.common.MainCommon;
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
		//Tim cron dung
		for (int i=0; i< main.get_querycron().length; i++){
			if (data.getString("_cronNM").equals(main.get_querycron()[i].get_cronNM())){
				//logger.info("[i="+i+"] bang roi");
				
				//Tim query
				for (int j=0; j< main.get_querycron()[i].get_queryid().length;j++){//For cai queryid cua Cron
					//logger.info("[j="+j+"] bang roi" +main.get_querycron()[i].get_queryid()[j]);
					
					for (int k=0; k<main.get_query().length; k++){
						
						if (main.get_querycron()[i].get_queryid()[j].equals(main.get_querycron()[i].get_cronNM()+"."+main.get_query()[k].get_queryid())){
							
							//logger.info("[k="+k+"] bang roi = " +main.get_query()[k].get_queryid());
														
							DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
							Date date = new Date();
							//logger.info(dateFormat.format(date));
							
							//Xet lai ten dung
							main.get_query()[k].set_querynm(dateFormat.format(date)+" - "+main.get_query()[k].get_querynm());
							
							//Connect va chay Query
							main.get_queryser().connectDatabase();							
							main.get_query()[k].queryToExcel(main.get_appcommon(), main.getQueryser());
						}
					}
				}
			}
		}
		
	}
}
