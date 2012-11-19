package org.eib.cron.application.views;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.ResourceBundle;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

import org.apache.log4j.Logger;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;

import org.eclipse.ui.part.ViewPart;

import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eib.common.FolderUtil;
import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.eib.cron.run.QueryToExcelJob;
import org.eib.database.CommandMultiQuery;
import org.eib.database.Query;
import org.eclipse.swt.widgets.Text;
import org.eclipse.wb.swt.SWTResourceManager;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.List;

public class AllScriptView extends ViewPart {

	public static final String ID = "org.eib.cron.application.views.AllScriptView"; //$NON-NLS-1$
	public static Combo cboDBA;
	public static Combo cboDefine;
	public static Button btnRun;
	public static Button btnStart;
	public static Button btnShutdown;
	private static Logger logger =Logger.getLogger("AllScriptView");
	private MainCommon main;
	private String _serID = "";
	private QueryServer _qurser;
	private Query _query;
	private Text txtSum;
	private Text txtCnt;
	private static int numScript = 0;
	
	private Date _date1, _date2;
	private	DateFormat _dateFormat1, _dateFormat2;
	private Text txtStatus;
	private Query[] _runQuery;
	
	private Scheduler scheduler;
	private Button btnShow;
	private List listShow;
	
	public AllScriptView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		container.setLayout(null);
		
		Label lblDatabase = new Label(container, SWT.NONE);
		lblDatabase.setBounds(10, 10, 48, 15);
		lblDatabase.setText("Database");
		
		cboDBA = new Combo(container, SWT.NONE);
		cboDBA.setItems(new String[] {"Oralce-ALONE29", "Oralce-AReport", "Oralce-ALive", "MySQL-test"});
		cboDBA.setBounds(62, 7, 119, 23);
		
		Label lblDefine = new Label(container, SWT.NONE);
		lblDefine.setBounds(10, 35, 34, 15);
		lblDefine.setText("Define");
		
		cboDefine = new Combo(container, SWT.NONE);
		cboDefine.setItems(new String[] {"DEF002", "DEF001", "DEF003"});
		cboDefine.setBounds(62, 31, 74, 23);
		
		btnRun = new Button(container, SWT.NONE);
		btnRun.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			
				logger.info("numScript= "+numScript);
				if (numScript ==0){ //Chua thuc hien					
					
					ResourceBundle rb = ResourceBundle.getBundle("/resource/app");				
					main = new MainCommon("/resource/app",rb.getString("app_kind"),"all");
					
					logger.info("");
					logger.info("");
					logger.info("Running All Script to Excel---------------------------------");				
					
					String _outZipUrl;
					String _fileNameZip;				
					
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
					_qurser = main.getQueryServerFromID(cboDBA.getText()); //Oralce-AReport , Oralce-ALONE29       MySQL-test          
			        _qurser.connectDatabase();
			        
			        _serID = cboDBA.getText();
			        
			        //Lay define cho he thong
			        _qur = main.getQueryFromID(cboDefine.getText()); //DEF002: Ngay he thong, DEF003 test
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
			        
			       // main.logQuery();
			        
			        //Thoi gian bat dau			        
			       	_dateFormat1 = new SimpleDateFormat("yyyyMMdd_HHmmss");	        	
		    		_date1= new Date();
		    			    							
					//Cau query chay
		    		_runQuery = main.getRunQuery(main.get_query());
					
					//Set thong tin				
					txtSum.setText(String.valueOf(_runQuery.length));
					txtCnt.setText(String.valueOf(main.get_appcommon().get_scriptnums()));
					
					//btnRun.setEnabled(false);
					cboDBA.setEnabled(false);
					cboDefine.setEnabled(false);
					
					txtStatus.setText("Run");
					btnRun.setText("Run Back");
					
					//Chay
					runAllScript();
					
					Job job = new Job("Run All Scripts") {
						@Override
						protected IStatus run(IProgressMonitor monitor) {
							// Set total number of work units
							monitor.beginTask("Total script: "+(_runQuery.length), _runQuery.length);
							//for (int i = 0; i < main.get_query().length; i++) {
							
							monitor.worked(_runQuery.length/2);
							// Sleep a second
							//TimeUnit.SECONDS.sleep(1);	
							//while((numScript + 1) != main.get_query().length){
							while (main.chekFinishQuery(_runQuery) != 1){
								//logger.info("numScript = "+numScript);
								monitor.subTask(" Run scriptID: " + (numScript+1)+ " with name= "+_runQuery[numScript].get_querynm());				     
								// Report that 20 units are done
								//if (numScript>2)
									//monitor.worked(numScript);									
								//monitor.worked(20);
								//txtCnt.setText(String.valueOf(numScript));
							}
							
							//Doi 2s
							try {
								Thread.sleep(3000);//3s
							} catch (InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
							showResult();
							monitor.done();
							return Status.OK_STATUS;
					  }
					 };
					job.schedule();
					
				}else{
					if ((numScript + 1) == _runQuery.length){
						//Da chay xong
						numScript = 0;
						txtStatus.setText("Running back");
						cboDBA.setEnabled(true);
						cboDefine.setEnabled(true);
						btnRun.setText("Run");
						txtSum.setText("");
						txtCnt.setText("");
					}else{
						txtStatus.setText("Running");
					}
				}
														        
		        //btnRun.setEnabled(true);
			}
		});
		
		btnRun.setBounds(10, 103, 75, 25);
		btnRun.setText("Run");
		
		txtSum = new Text(container, SWT.BORDER);
		txtSum.setForeground(SWTResourceManager.getColor(SWT.COLOR_DARK_BLUE));
		txtSum.setEnabled(false);
		txtSum.setBounds(79, 56, 57, 21);
		
		txtCnt = new Text(container, SWT.BORDER);
		txtCnt.setEnabled(false);
		txtCnt.setForeground(SWTResourceManager.getColor(SWT.COLOR_DARK_BLUE));
		txtCnt.setBounds(206, 56, 57, 21);
		
		Label lblNewLabel = new Label(container, SWT.NONE);
		lblNewLabel.setBounds(10, 59, 72, 15);
		lblNewLabel.setText("Total Scripts");
		
		Label lblNewLabel_1 = new Label(container, SWT.NONE);
		lblNewLabel_1.setBounds(138, 59, 66, 15);
		lblNewLabel_1.setText("Run Scripts");
		
		txtStatus = new Text(container, SWT.BORDER);
		txtStatus.setForeground(SWTResourceManager.getColor(SWT.COLOR_RED));
		txtStatus.setBounds(10, 80, 253, 21);
		
		btnStart = new Button(container, SWT.NONE);
		btnStart.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				btnStart.setEnabled(false);
				btnShutdown.setEnabled(true);				
				
				logger.info("");
				logger.info("Load---------------------------------");
				ResourceBundle rb = ResourceBundle.getBundle("/resource/app");	
				MainCommon main1 = new MainCommon("/resource/app",rb.getString("app_kind"),"all");
				
				try {					
					for (int i=0; i< main1.get_querycron().length; i++){
						
						JobDetail job = JobBuilder.newJob(QueryToExcelJob.class)
								.withIdentity(main1.get_querycron()[i].get_jobNM(), main1.get_querycron()[i].get_jobGroup()).build();
				 
						job.getJobDataMap().put("_cronNM", main1.get_querycron()[i].get_cronNM());
						job.getJobDataMap().put("_defineScript", main1.get_querycron()[i].get_defineScript());
						job.getJobDataMap().put("_databaseID", main1.get_querycron()[i].get_databaseID());
						
						logger.info("["+(i+1)+"]");								
						logger.info("_cronNM= "+main1.get_querycron()[i].get_cronNM() );
						logger.info("_defineScript= "+main1.get_querycron()[i].get_defineScript());
						logger.info("_databaseID= "+ main1.get_querycron()[i].get_databaseID());
						logger.info("_triggerSchedule= "+main1.get_querycron()[i].get_triggerSchedule());						
				 
				    	Trigger trigger = TriggerBuilder
				    			.newTrigger()
				    			.withIdentity(main1.get_querycron()[i].get_triggerNM(), main1.get_querycron()[i].get_triggerNM())
				    			.withSchedule(						
							CronScheduleBuilder.cronSchedule(main1.get_querycron()[i].get_triggerSchedule()))
							.build();
				 
				    	//schedule it
				    	scheduler = new StdSchedulerFactory().getScheduler();
				    	scheduler.start();				    
				    	scheduler.scheduleJob(job, trigger);					  
					}					
				} catch (SchedulerException e2) {
					// TODO Auto-generated catch block
					logger.error(e2.getMessage());
					e2.printStackTrace();
				}			
			}
		});
		btnStart.setBounds(10, 377, 75, 25);
		btnStart.setText("Start");
		
		btnShutdown = new Button(container, SWT.NONE);
		btnShutdown.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				btnStart.setEnabled(true);
				btnShutdown.setEnabled(false);
				
				try {
					scheduler.shutdown();
				} catch (SchedulerException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		btnShutdown.setBounds(87, 377, 75, 25);
		btnShutdown.setText("Shutdown");
		
		btnShow = new Button(container, SWT.NONE);
		btnShow.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				listShow.removeAll();
				String[] show = main.getStatusQuery(_runQuery);
				for (int i=0; i <show.length; i++)
					listShow.add(show[i]);
			}
		});
		
		
		btnShow.setBounds(87, 103, 75, 25);
		btnShow.setText("Show");
		
		listShow = new List(container, SWT.BORDER);
		listShow.setBounds(10, 131, 253, 240);

		createActions();
		initializeToolBar();
		initializeMenu();
	}

	/**
	 * Create the actions.
	 */
	private void createActions() {
		// Create the actions
		cboDBA.setText("Oralce-ALONE29");
		cboDefine.setText("DEF002");
				
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
	
	
	
	public void runScript(){		
		CommandMultiQuery cq1 = new CommandMultiQuery(_qurser.get_conn(),_query,main.get_appcommon());
		cq1.run();
	}
	
	
	public void runAllScript(){
		
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
                    	   numScript = num;
                    		  
                    	  _qurser = new QueryServer();						
 		            	  _qurser = main.getQueryServerFromID(_serID);
 		            	  _qurser.connectDatabase();
 		            	  
 		            	  _query = new Query();
 		            	  _query = _runQuery[l];
 		            	   
 		            	   logger.info(">> Run " + num+" = "+_runQuery[l].get_querynm());
 		            	   //txtCnt.setText(String.valueOf(num + 1));
 		            	   runScript();
 		            	  		 		            	  
                    	}
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
	
	public void showResult(){
		//Thong ke thoi gian chay
		//btnRun.setEnabled(true);
		
		//Chay lai neu bi Fail		
		//logger.info("So luong script bi fail: "+coutRunFailQuery(main.get_query()));
		
		_dateFormat2 = new SimpleDateFormat("yyyyMMdd_HHmmss");	
        _date2= new Date();
        
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
        //kiem tra script fail de chay lai
        
	}
}
