package org.eib.common;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eib.database.CommandQuery;
import org.eib.database.Query;
import org.quartz.CronScheduleBuilder;
import org.quartz.Job;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;
import org.xml.sax.SAXException;

import test.org.eib.ArrayQuartz.Job1;
import test.org.eib.ArrayQuartz.JobQuery;

public class MainCommon {
	
	private static Logger logger =Logger.getLogger("MainCommon");
	
	private AppCommon _appcommon;
	private QueryServer _queryser;
	private QueryCron[] _querycron;
	private Query[] _query;
	
	
	public QueryServer get_queryser() {
		return _queryser;
	}
	public void set_queryser(QueryServer _queryser) {
		this._queryser = _queryser;
	}		
	
	public QueryCron[] get_querycron() {
		return _querycron;
	}
	public void set_querycron(QueryCron[] _querycron) {
		this._querycron = _querycron;
	}
	public AppCommon get_appcommon() {
		return _appcommon;
	}
	public void set_appcommon(AppCommon _appcommon) {
		this._appcommon = _appcommon;
	}
	public QueryServer getQueryser() {
		return _queryser;
	}
	public void setQueryser(QueryServer queryser) {
		this._queryser = queryser;
	}
	public Query[] get_query() {
		return _query;
	}
	public void set_query(Query[] _query) {
		this._query = _query;
	}
	
	//Khoi tao
	public MainCommon(){
		
		File dir1 = new File(".");
		ResourceBundle rb = ResourceBundle.getBundle("app");
		//ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
				
		try {
			logger.info("congifureUrl = "+ dir1.getCanonicalPath()+rb.getString("congifureUrl"));
			logger.info("scriptUrl = "+ dir1.getCanonicalPath()+rb.getString("scriptUrl"));
			
			Query qur = new Query(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"script.xml","Query");
			qur.logQuery();
			
			QueryCron qurcron = new QueryCron(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"cron.xml","Cron");
			qurcron.logQueryCron();
			
			_queryser =new QueryServer();
			_appcommon = new AppCommon();	
			_appcommon.set_scriptUrl(dir1.getCanonicalPath()+rb.getString("scriptUrl"));
			_appcommon.set_logUrl(dir1.getCanonicalPath()+rb.getString("logtUrl"));
			
			
			_querycron = new QueryCron[qurcron.get_countcron()];		
			_query = new Query[qur.get_countquery()];//Tong so query			
						
			_appcommon.getAppCom(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"app.xml","Common1");
			_appcommon.logAppCommon();
			
			_queryser.getServer(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"database.xml",_appcommon.get_servernm());
			_queryser.logQueryServer();
			_queryser.connectDatabase();//Tien hanh connect
			
			
			qur.getXMLToScript(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"script.xml", "Query", _query);			
			for (int i=0; i< _query.length; i++){
				System.out.println("["+i+"]");
				
				//Tien hanh query
				//_query[i].queryToExcel(_appcommon, _queryser);							
			}
			
			
			qurcron.getXMLToCron(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"cron.xml","Cron",_querycron);
			for (int j=0; j< _querycron.length; j++){
				System.out.println("["+j+"]");
				_querycron[j].logQueryCron();
				//_query[i].setquery();
				//_query[i].set_queryouturl(_appcommon.get_outurl_excel(_query[i].get_querynm()));
				
				/*
				JobDetail job = JobBuilder.newJob(JobQuery.class)
						.withIdentity(_querycron[j].get_jobNM(), _querycron[j].get_jobGroup()).build();
				 
					//Quartz 1.6.3
				    	//CronTrigger trigger = new CronTrigger();
				    	//trigger.setName("dummyTriggerName");
				    	//trigger.setCronExpression("0/5 * * * * ?");
						
				    	Trigger trigger = TriggerBuilder
						.newTrigger()
						.withIdentity(_querycron[j].get_triggerNM(), _querycron[j].get_triggerNM())
						.withSchedule(
							//CronScheduleBuilder.cronSchedule("0/5 * * * * ?"))
							CronScheduleBuilder.cronSchedule(_querycron[j].get_triggerSchedule()))
						.build();
				 
				    	//schedule it
				    	Scheduler scheduler;
						try {
							scheduler = new StdSchedulerFactory().getScheduler();
							scheduler.start();
					    	scheduler.scheduleJob(job, trigger);		
						} catch (SchedulerException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
				   */ 				
				    	
			}
			
			
			//thuc thi 
			
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block			
			logger.error(e.getMessage());
			e.printStackTrace();
			return;	
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
			return;	
		} catch (IOException e) {
			// TODO Auto-generated catch block			
			logger.error(e.getMessage());
			e.printStackTrace();
			return;	
		}
	}
	
	
	
	
}
