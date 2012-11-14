package org.eib.cron.application.views;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eib.common.DateTimeUtil;
import org.eib.common.FTPUtil;
import org.eib.common.FolderUtil;
import org.eib.common.MainCommon;
import org.eib.common.QueryCron;
import org.eib.common.QueryServer;
import org.eib.common.ZipUtil;
import org.eib.cron.application.Activator;
import org.eib.cron.run.QueryJob;
import org.eib.database.Query;
import org.eib.thread.RunMulConScript;
import org.osgi.framework.Bundle;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;

import org.xml.sax.SAXException;

public class CronView extends ViewPart {

	public static final String ID = "org.eib.cron.application.views.CronView"; //$NON-NLS-1$
	private static Logger logger =Logger.getLogger("CronView");	
	
	Scheduler scheduler;
	
	public CronView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		container.setLayout(null);
		
		final Button btnStart = new Button(container, SWT.NONE);
		final Button btnStop = new Button(container, SWT.NONE);
		btnStop.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				btnStart.setEnabled(true);
				btnStop.setEnabled(false);
				
				try {
					scheduler.shutdown();
				} catch (SchedulerException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		
		btnStart.addSelectionListener(new SelectionAdapter() {			
			@Override
			public void widgetSelected(SelectionEvent e) {
				btnStart.setEnabled(false);
				btnStop.setEnabled(true);
				
				//ConsoleDisplayMgr.getDefault().println("Some errodfdfr msg", ConsoleDisplayMgr.MSG_ERROR);
				
				logger.info("");
				logger.info("Load---------------------------------");
				ResourceBundle rb = ResourceBundle.getBundle("/resource/app");	
				
				//System.out.println("app_kind = "+ rb.getString("app_kind"));
				//logger.info("app_kind = "+ rb.getString("app_kind"));
				//System.out.println("app_configure_url = "+ rb.getString("app_configure_url"));
				
				//System.out.println("bbb = ");
				MainCommon main1 = new MainCommon("/resource/app",rb.getString("app_kind"));
				//main1.logQueryCron();
				
				//File dir1 = new File(".");
		        //ResourceBundle rb = ResourceBundle.getBundle("/resource/app");        			
				
				try {					
					for (int i=0; i< main1.get_querycron().length; i++){
						
						//JobDetail job = JobBuilder.newJob(QueryJob.class)
						JobDetail job = JobBuilder.newJob(QueryJob.class)
								.withIdentity(main1.get_querycron()[i].get_jobNM(), main1.get_querycron()[i].get_jobGroup()).build();
				 
						job.getJobDataMap().put("_cronNM", main1.get_querycron()[i].get_cronNM());
						job.getJobDataMap().put("_defineScript", main1.get_querycron()[i].get_defineScript());
						job.getJobDataMap().put("_databaseID", main1.get_querycron()[i].get_databaseID());
						
						logger.info("["+(i+1)+"]");								
						logger.info("_cronNM= "+main1.get_querycron()[i].get_cronNM() );
						logger.info("_defineScript= "+main1.get_querycron()[i].get_defineScript());
						logger.info("_databaseID= "+ main1.get_querycron()[i].get_databaseID());
						logger.info("_triggerSchedule= "+main1.get_querycron()[i].get_triggerSchedule());
						
					//Quartz 1.6.3
				    	//CronTrigger trigger = new CronTrigger();
				    	//trigger.setName("dummyTriggerName");
				    	//trigger.setCronExpression("0/5 * * * * ?");
				 
				    	Trigger trigger = TriggerBuilder
				    			.newTrigger()
				    			.withIdentity(main1.get_querycron()[i].get_triggerNM(), main1.get_querycron()[i].get_triggerNM())
				    			.withSchedule(
							//CronScheduleBuilder.cronSchedule("0/5 * * * * ?"))
							CronScheduleBuilder.cronSchedule(main1.get_querycron()[i].get_triggerSchedule()))
							.build();
				 
				    	//schedule it
				    	scheduler = new StdSchedulerFactory().getScheduler();
				    	scheduler.start();
				    	//scheduler.shutdown();
				    	scheduler.scheduleJob(job, trigger);					  
					}
					//System.out.println("> Load script Done. With= "+_query.length+" scripts");
				} catch (SchedulerException e2) {
					// TODO Auto-generated catch block
					logger.error(e2.getMessage());
					e2.printStackTrace();
				}
					
				/*
				QueryCron[] qur;//luc khoi dau lay duoc gia tri ko?
				QueryCron qur1 = new QueryCron("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\Query To Excel Cron\\Congifure\\test\\cron.xml","Cron");
				qur = new QueryCron[qur1.get_countcron()];
				
				try {
					//qur1.getXMLToCron("E:\\BACKUP\\DROPBOX\\Dropbox\\WORK\\Project\\cron.xml", "Cron", qur); //_app.get_configureurl()+
					qur1.getXMLToCron("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\Query To Excel Cron\\Congifure\\test\\cron.xml", "Cron", qur); //_app.get_configureurl()+
					
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
				} catch (SchedulerException e2) {
					// TODO Auto-generated catch block
					logger.error(e2.getMessage());
					e2.printStackTrace();
				}*/
			}
		});
		btnStart.setBounds(10, 10, 75, 25);
		btnStart.setText("Start");
					
		btnStop.setEnabled(false);
		btnStop.setBounds(91, 10, 75, 25);
		btnStop.setText("Shutdown");		
		
		Button btnTest = new Button(container, SWT.NONE);
		btnTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ResourceBundle rbTest = ResourceBundle.getBundle("/resource/app");	
				MainCommon maintest = new MainCommon("/resource/app",rbTest.getString("app_kind"));
				maintest.logQueryCron();				
				maintest.logQueryServer();
				maintest.logQuery();
			}
		});
		btnTest.setBounds(271, 10, 75, 25);
		btnTest.setText("Test");
		
		Button btnExcel = new Button(container, SWT.NONE);
		btnExcel.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				logger.info("");
				logger.info("");
				logger.info("Running All Script to Excel---------------------------------");				
				
				String _outZipUrl;
				String _fileNameZip;
				
				ResourceBundle rb = ResourceBundle.getBundle("/resource/app2");				
				MainCommon main = new MainCommon("/resource/app2",rb.getString("app_kind"));
				
				Date date1 ;
				DateFormat dateFormat1;
				DateFormat dateFormat2;
				
				dateFormat1 = new SimpleDateFormat("yyyyMMdd");	
				date1= new Date();
				//Set lai duong dan out
				main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat1.format(date1)+"\\");		
				FolderUtil.createFolder(main.get_appcommon().get_outurl());
				
				//set FTP out
				main.get_appcommon().set_ftpUrl(main.get_appcommon().get_ftpUrl()+ dateFormat1.format(date1)+"\\");
				
				_outZipUrl = main.get_appcommon().get_outurl();
				_fileNameZip = dateFormat1.format(date1);
				
				dateFormat2 = new SimpleDateFormat("HHmm");	
				date1= new Date();
				main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat2.format(date1)+"\\");	
				
				_fileNameZip = _fileNameZip +" - " + dateFormat2.format(date1);
				
				//Tao folder
				FolderUtil.createFolder(main.get_appcommon().get_outurl());				
									
				
				QueryServer _qurser = new QueryServer();
		        Query _qur = new Query();
				_qurser = main.getQueryServerFromID("MySQL-test"); //Oralce-AReport , Oralce-ALONE29       MySQL-test          
		        _qurser.connectDatabase();
		        
		        //Lay define cho he thong
		        _qur = main.getQueryFromID("DEF003"); //DEF002: Ngay he thong, DEF003 test
		        _qur.queryToAppDefine(main.get_appcommon(), _qurser);        
		        //main.get_appcommon().logAppCommon();
		        			
								
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
		        
		        //Tien hanh chay multi query        
		        //RunMulConScript.commandMulQueryExcel(_qurser, main.get_query(), main.get_appcommon());
		      		
		        //logger.error("main.get_appcommon().get_outurl()= "+main.get_appcommon().get_outurl());
		        //logger.info("_outZipUrl= "+_outZipUrl);
		       // logger.info("_fileNameZip= "+_fileNameZip);
		        //Tien hanh Zip file
		        
		        //ZipUtil.creatZipFoler("D:\\20121109\\2233\\","D:\\20121109\\","20121109 - 2233");
		        /*
		        ZipUtil.creatZipFoler(main.get_appcommon().get_outurl(),_outZipUrl,_fileNameZip);
		        
		        //Tao foler tren FTP
		        FTPUtil ftp = new FTPUtil();
		        ftp.set_ftpServer(main.get_appcommon().get_ftpServer());
		        ftp.set_user(main.get_appcommon().get_ftpUsr());
		        ftp.set_password(main.get_appcommon().get_ftpPass());
		        ftp.set_port(21);
		               
		        ftp.createFolder(main.get_appcommon().get_ftpUrl());
		                
		        //Dua len FTP
		        //main.get_appcommon().set_ftpFilename(main.get_appcommon().get_ftpFilename()+_fileNameZip+".zip");
		        main.get_appcommon().set_ftpFilename(_fileNameZip+".zip");
		        main.get_appcommon().set_ftpInurl(_outZipUrl+_fileNameZip+".zip");
		        File source = new File(main.get_appcommon().get_ftpInurl());
		        
		        //main.get_appcommon().logAppCommon();
		        
		        try {
					//upload(ftpServer,user,password,fileName,source);
					FTPUtil.upload(ftp.get_ftpServer(),
							ftp.get_user(),
							ftp.get_password(),
							main.get_appcommon().get_ftpUrl()+main.get_appcommon().get_ftpFilename(),
							source);
				} catch (MalformedURLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					logger.error(e.getMessage());		
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					logger.error(e.getMessage());		
				}*/
			}
		});
		btnExcel.setBounds(362, 10, 117, 25);
		btnExcel.setText("All Query to Excel");

		createActions();
		initializeToolBar();
		initializeMenu();
	}

	/**
	 * Create the actions.
	 */
	private void createActions() {
		// Create the actions
	}

	/**
	 * Initialize the toolbar.
	 */
	private void initializeToolBar() {
		IToolBarManager toolbarManager = getViewSite().getActionBars()
				.getToolBarManager();
	}

	/**
	 * Initialize the menu.
	 */
	private void initializeMenu() {
		IMenuManager menuManager = getViewSite().getActionBars()
				.getMenuManager();
	}

	@Override
	public void setFocus() {
		// Set the focus
	}
}
