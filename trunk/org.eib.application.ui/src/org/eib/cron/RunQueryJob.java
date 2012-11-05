package org.eib.cron;

import java.io.File;
import java.io.IOException;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
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

import test.org.eib.ArrayQuartz.Job1;

public class RunQueryJob {
	
	private static Logger logger =Logger.getLogger("RunQueryJob");
	
	/**
	 * @param args
	 */
	public static void main(String[] args)  throws SchedulerException {
		// TODO Auto-generated method stub
		QueryCron[] qur;//luc khoi dau lay duoc gia tri ko?
		QueryCron qur1 = new QueryCron();
		
		File dir1 = new File(".");
        ResourceBundle rb = ResourceBundle.getBundle("app");        			
		
		try {
			QueryCron qurcron = new QueryCron(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"cron.xml","Cron");			
			qur = new QueryCron[qurcron.get_countcron()];
			
			qur1.getXMLToCron("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\GG  Report to Excel\\Congifure\\test\\cron.xml", "Cron", qur); //_app.get_configureurl()+
			//qur1.getXMLToCron("D:\\Report to Excel\\Workplace\\Report to Excel\\GG  Report to Excel\\Congifure\\cron\\cron.xml", "Cron", qur); //_app.get_configureurl()+
			
			for (int i=0; i< qur.length; i++){
				
				//JobDetail job = JobBuilder.newJob(QueryJob.class)
				JobDetail job = JobBuilder.newJob(QueryJobTest.class)
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
		} catch (ParserConfigurationException e1) {
			// TODO Auto-generated catch block
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		} catch (SAXException e1) {
			// TODO Auto-generated catch block
			
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		} catch (SchedulerException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	}

}
