package test.org.eib.swt.progressBar;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.dialogs.ProgressMonitorDialog;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.window.ApplicationWindow;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eib.common.AppCommon;
import org.eib.common.QueryServer;
import org.eib.database.CommandQuery;
import org.eib.database.JDBCURLHelper;
import org.eib.database.Query;
import org.xml.sax.SAXException;

public class MainClass extends ApplicationWindow {
	private AppCommon _app;
	private QueryServer queryser;
	private Connection _conn = null; 
	private Query _query;
	private static Logger logger =Logger.getLogger("MainClass");
	
	
  public MainClass() {
    super(null);
  }

  public void run() {
    setBlockOnOpen(true);
    open();
    Display.getCurrent().dispose();
  }

  protected void configureShell(Shell shell) {
    super.configureShell(shell);
    shell.setText("Show Progress");
  }

  protected Control createContents(Composite parent) {
    Composite composite = new Composite(parent, SWT.NONE);
    composite.setLayout(new GridLayout(1, true));

    final Button indeterminate = new Button(composite, SWT.CHECK);
    indeterminate.setText("Indeterminate");
    Button showProgress = new Button(composite, SWT.NONE);
    showProgress.setText("Show Progress");

    final Shell shell = parent.getShell();

    showProgress.addSelectionListener(new SelectionAdapter() {
      public void widgetSelected(SelectionEvent event) {
    	  
    	 getApp();
    	 getConnectDatabase();
    	 
    	_query = new Query();
    	_query.set_querynm("Tran van tuan Em");
    	_query.set_exquery("select * from athena.daily_stocks_transaction");
        try {
          new ProgressMonitorDialog(shell).run(true, true, new LongRunningOperation(_conn, _query));
        } catch (InvocationTargetException e) {
          MessageDialog.openError(shell, "Error", e.getMessage());
        } catch (InterruptedException e) {
          MessageDialog.openInformation(shell, "Cancelled", e.getMessage());
        }
      }
    });

    parent.pack();
    return composite;
  }

  public static void main(String[] args) {
    new MainClass().run();
  }
  
  public void getApp(){
		//lay thong tin
		_app = new AppCommon();		
		try {
			//ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
			//_app.getAppCom("D:\\Query to Excel\\Congifure\\app.xml", "Common2");
			_app.getAppCom("D:\\Query to Excel\\Congifure\\app.xml","Common2");
			
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
  
  	public void getConnectDatabase(){
		queryser =new QueryServer();
		try {
			queryser.getServer(_app.get_configureurl()+"database.xml",_app.get_servernm());
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
		queryser.setUrl(JDBCURLHelper.generateURL(queryser.getDriver(), queryser.getHost(), queryser.getPort(), queryser.getDatabase()));
		logger.info("url = "+queryser.getUrl());
      	
		try {
			Class.forName(queryser.getDriver()).newInstance();
			_conn = DriverManager.getConnection(queryser.getUrl(), queryser.getUser(), queryser.getPassword());
			//System.out.println("Connect Successful !!!");
			logger.info("Connect Successful !!!");
      } catch (Exception e2) {		
			logger.error("Unable to load driver " + queryser.getDriver());
			logger.error("ERROR " + e2.getMessage());    
			return;		        
      }
	}
  
}

class LongRunningOperation implements IRunnableWithProgress {

  private static Query query;
  private Connection conn = null;
  

  public static Query getQuery() {
	return query;
  }

  public static void setQuery(Query query) {
	LongRunningOperation.query = query;
  }
  
  public LongRunningOperation(Connection _conn, Query _query) {
    this.conn = _conn;
    LongRunningOperation.query = _query;
  }

  public void run(IProgressMonitor monitor) throws InvocationTargetException, InterruptedException {
	 monitor.beginTask(query.get_querynm(), true ? IProgressMonitor.UNKNOWN: 100);
	 //monitor.subTask("aa");
	 try {
		CommandQuery.set_Excelrow(6000);
		CommandQuery.commandQueryExcel(conn, query.get_exquery(),true,false, "D:\\a.xls");
		
		monitor.subTask(CommandQuery.get_message());
		//Thread.sleep(INCREMENT);
		//monitor.internalWorked(70);
		//Thread.sleep(INCREMENT);
	} catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		System.out.println(e.getMessage());
		e.printStackTrace();		
	} catch (IOException e) {
		// TODO Auto-generated catch block
		System.out.println(e.getMessage());
		e.printStackTrace();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		System.out.println(e.getMessage());
		e.printStackTrace();
	}
	// Thread.sleep(INCREMENT);
	 /*
    for (int total = 0; total < TOTAL_TIME && !monitor.isCanceled(); total += INCREMENT) {
      Thread.sleep(INCREMENT);
      monitor.worked(INCREMENT);
      if (total == TOTAL_TIME / 2)
        monitor.subTask("Doing second half");
    }*/
    monitor.done();
    if (monitor.isCanceled())
      throw new InterruptedException(query.get_querynm() + " -> running operation was cancelled");
  }
}
    