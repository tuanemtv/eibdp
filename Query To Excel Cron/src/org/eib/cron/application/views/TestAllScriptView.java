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
import org.eclipse.swt.widgets.DirectoryDialog;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Combo;
import org.eib.common.FolderUtil;
import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.eib.database.Query;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;

public class TestAllScriptView extends ViewPart {

	public static final String ID = "org.eib.cron.application.views.TestAllScriptView"; //$NON-NLS-1$
	public static Combo cboDBA;
	public static Combo cboDefine;
	public static Combo cboScript;
	private static Logger logger =Logger.getLogger("TestAllScriptView");
	
	private MainCommon main;
	private Text txtOutFolder;

	public TestAllScriptView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(final Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		{
			Label label = new Label(container, SWT.NONE);
			label.setText("Database");
			label.setBounds(10, 13, 48, 15);
		}
		{
			cboDBA = new Combo(container, SWT.NONE);
			cboDBA.setItems(new String[] {"Oralce-ALONE29", "Oralce-AReport", "Oralce-ALive", "MySQL-test"});
			cboDBA.setBounds(62, 10, 119, 23);
			cboDBA.setText("Oralce-ALONE29");
		}
		{
			cboDefine = new Combo(container, SWT.NONE);
			cboDefine.setItems(new String[] {"DEF002", "DEF001", "DEF003"});
			cboDefine.setBounds(238, 10, 74, 23);
			cboDefine.setText("DEF002");
		}
		{
			Label label = new Label(container, SWT.NONE);
			label.setText("Define");
			label.setBounds(197, 13, 34, 15);
		}
		
		cboScript = new Combo(container, SWT.NONE);
		cboScript.setBounds(10, 43, 467, 23);
		{
			Label label = new Label(container, SWT.NONE);
			label.setText("Out Folder");
			label.setBounds(10, 112, 62, 15);
		}
		{
			txtOutFolder = new Text(container, SWT.BORDER);
			txtOutFolder.setEnabled(false);
			txtOutFolder.setBounds(75, 106, 364, 21);
		}
		{
			Button btnOutFolder = new Button(container, SWT.NONE);
			btnOutFolder.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(SelectionEvent e) {
					DirectoryDialog dlg = new DirectoryDialog(parent.getShell());

				      // Set the initial filter path according
				      // to anything they've selected or typed in
				      dlg.setFilterPath(txtOutFolder.getText());
				      // Change the title bar text
				      dlg.setText("Chon folder luu file excel");
				      // Customizable message displayed in the dialog
				      //dlg.setMessage("Chon duong dan.");

				      // Calling open() will open and run the dialog.
				      // It will return the selected directory, or
				      // null if user cancels
				      String dir = dlg.open();
				      if (dir != null) {
				        // Set the text box to the new selection
				    	  txtOutFolder.setText(dir);
				      }
				}
			});
			btnOutFolder.setText("...");
			btnOutFolder.setBounds(445, 104, 36, 25);
		}
		{
			Button btnRun = new Button(container, SWT.NONE);
			btnRun.setText("Run");
			btnRun.setBounds(10, 72, 75, 25);
		}

		createActions();
		initializeToolBar();
		initializeMenu();
	}

	/**
	 * Create the actions.
	 */
	private void createActions() {
		// Create the actions
		
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
		//FolderUtil.createFolder(main.get_appcommon().get_outurl());
		
		//set FTP out
		//main.get_appcommon().set_ftpUrl(main.get_appcommon().get_ftpUrl()+ dateFormat1.format(date1)+"\\");
		
		_outZipUrl = main.get_appcommon().get_outurl();
		_fileNameZip = dateFormat1.format(date1);
		
		dateFormat2 = new SimpleDateFormat("HHmm");	
		date1= new Date();
		main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat2.format(date1)+"\\");	
		
		//_fileNameZip = _fileNameZip +" - " + dateFormat2.format(date1);
		
		//Tao folder
		//FolderUtil.createFolder(main.get_appcommon().get_outurl());				
		

		//QueryServer _qurser = new QueryServer();
        //Query _qur = new Query();
		//_qurser = main.getQueryServerFromID(cboDBA.getText()); //Oralce-AReport , Oralce-ALONE29       MySQL-test          
       // _qurser.connectDatabase();
        
               
        //Lay define cho he thong
        //_qur = main.getQueryFromID(cboDefine.getText()); //DEF002: Ngay he thong, DEF003 test
        //_qur.queryToAppDefine(main.get_appcommon(), _qurser);        
        //main.get_appcommon().logAppCommon();
        
        //show ra cac script
        for(int k=0; k<main.get_query().length;k++){
        	logger.info("["+k+"]="+main.get_query()[k].get_queryid()+" - "+main.get_query()[k].get_querynm());
        }
        
		//Sort lai query theo thu tu uu tien
		main.sortQueryWithPriority();				

		
        //set cac thong tin cua Query
        for (int j=0; j<main.get_query().length;j++)
        {        
        	if (main.get_query()[j].get_module().equals("AA")){
        		
        	}else{
        		//main.get_query()[j].set_querynm(main.get_appcommon().get_define().get("01h_trdt")+"_"+main.get_query()[j].get_querynm());
	        	main.get_query()[j].set_fileurl(main.get_appcommon().get_scriptUrl()+main.get_query()[j].get_fileurl());
	    		//doc file
	        	main.get_query()[j].readScript();    	
	    		//this.logQuery();
	        	main.get_query()[j].set_define(main.get_appcommon().get_define());
	        	main.get_query()[j].setquery();        	
	        	//main.get_query()[j].logQuery();
        	}			        	
        } 
        
        //add vao
        for (int k=0; k<main.get_query().length;k++){
        	cboScript.add(main.get_query()[k].get_querynm(), k);
        }
        
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
