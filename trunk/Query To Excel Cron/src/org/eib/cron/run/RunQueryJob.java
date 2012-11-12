package org.eib.cron.run;

import java.io.IOException;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eib.common.MainCommon;
import org.eib.common.QueryCron;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;
import org.xml.sax.SAXException;

public class RunQueryJob {
	
	private static Logger logger =Logger.getLogger("RunQueryJob");
	
	/**
	 * @param args
	 */
	public static void main(String[] args)  throws SchedulerException {
		// TODO Auto-generated method stub
		ResourceBundle rb = ResourceBundle.getBundle("app");
		MainCommon main = new MainCommon("app","1");
		
		QueryCron[] qur;//luc khoi dau lay duoc gia tri ko?
		QueryCron qur1 = new QueryCron("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\Query To Excel Cron\\Congifure\\cron\\cron.xml","Cron");
		qur = new QueryCron[qur1.get_countcron()];
		
		try {
			//qur1.getXMLToCron("E:\\BACKUP\\DROPBOX\\Dropbox\\WORK\\Project\\cron.xml", "Cron", qur); //_app.get_configureurl()+
			qur1.getXMLToCron("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\Query To Excel Cron\\Congifure\\cron\\cron.xml", "Cron", qur); //_app.get_configureurl()+
			
			for (int i=0; i< qur.length; i++){
				
				JobDetail job = JobBuilder.newJob(QueryJob.class)
						.withIdentity(qur[i].get_jobNM(), qur[i].get_jobGroup()).build();
		 
				job.getJobDataMap().put("_cronNM", qur[i].get_cronNM());
				
			//Quartz 1.6.3
		    	//CronTrigger trigger = new CronTrigger();
		    	//trigger.setName("dummyTriggerName");
		    	//trigger.setCronExpression("0/5 * * * * ?");
		 
		    	Trigger trigger = TriggerBuilder
		    			.newTrigger()
		    			.withIdentity(qur[i].get_triggerNM(), qur[i].get_triggerNM())
		    			.withSchedule(
					//CronScheduleBuilder.cronSchedule("0/5 * * * * ?"))
					CronScheduleBuilder.cronSchedule(qur[i].get_triggerSchedule()))
					.build();
		 
		    	//schedule it
		    	Scheduler scheduler = new StdSchedulerFactory().getScheduler();
		    	scheduler.start();
		    	scheduler.scheduleJob(job, trigger);					
			}
			//System.out.println("> Load script Done. With= "+_query.length+" scripts");
		} catch (SchedulerException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	}

}
