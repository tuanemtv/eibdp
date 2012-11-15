package org.eib.cron.application.views;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;
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
import org.eib.database.Query;
import org.eib.thread.RunMulConScript;

public class AllScriptView extends ViewPart {

	public static final String ID = "org.eib.cron.application.views.AllScriptView"; //$NON-NLS-1$
	public static Combo cboDBA;
	public static Combo cboDefine;
	private static Logger logger =Logger.getLogger("AllScriptView");
	
	
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
		cboDBA.setBounds(62, 7, 149, 23);
		
		Label lblDefine = new Label(container, SWT.NONE);
		lblDefine.setBounds(217, 10, 34, 15);
		lblDefine.setText("Define");
		
		cboDefine = new Combo(container, SWT.NONE);
		cboDefine.setItems(new String[] {"DEF002", "DEF001", "DEF003"});
		cboDefine.setBounds(257, 7, 74, 23);
		
		Button btnAll = new Button(container, SWT.NONE);
		btnAll.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ResourceBundle rbTest = ResourceBundle.getBundle("/resource/app");	
				MainCommon maintest = new MainCommon("/resource/app",rbTest.getString("app_kind"),"all");
				maintest.logQueryCron();				
				maintest.logQueryServer();
				maintest.logQuery();
				logger.info("");
				logger.info("");
				logger.info("Running All Script to Excel---------------------------------");				
				
				String _outZipUrl;
				String _fileNameZip;
				
				ResourceBundle rb = ResourceBundle.getBundle("/resource/app");				
				MainCommon main = new MainCommon("/resource/app",rb.getString("app_kind"),"all");
				
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
		        
		        //Tien hanh chay multi query        
		        RunMulConScript.commandMulQueryExcel(_qurser, main.get_query(), main.get_appcommon());
		      		
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
		btnAll.setBounds(337, 5, 103, 25);
		btnAll.setText("Run All Script");

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
}
