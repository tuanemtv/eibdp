package org.eib.application.dialog;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eib.database.CommandQuery;
import org.eib.database.Query;

public class RunScriptProgressBar implements IRunnableWithProgress{
	
	private static Logger logger =Logger.getLogger("RunScriptProgressBar");
	private static Query query;
	private Connection conn = null;
	private static long rowexcel;
	private static String outfileurl;
  

  public static Query getQuery() {
	return query;
  }

  public static void setQuery(Query query) {
	  RunScriptProgressBar.query = query;
  }
  
  public RunScriptProgressBar(Connection _conn, Query _query, long _rowexcel, String _outfileurl) {
    this.conn = _conn;
    RunScriptProgressBar.query = _query;
    RunScriptProgressBar.rowexcel = _rowexcel;
    RunScriptProgressBar.outfileurl = _outfileurl;
  }

  public void run(IProgressMonitor monitor) throws InvocationTargetException, InterruptedException {
	 monitor.beginTask(query.get_querynm(), true ? IProgressMonitor.UNKNOWN: 100); //true la chay ko biet thoi gian dung
	 try {
		CommandQuery.set_Excelrow(rowexcel);
		CommandQuery.commandQueryExcel(conn, query.get_exquery(),true,false, outfileurl);
		
		//monitor.subTask(CommandQuery.get_message()); //hien thi thong diep ben duoi
	} catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		logger.error(e.getMessage());
		e.printStackTrace();		
	} catch (IOException e) {
		// TODO Auto-generated catch block
		logger.error(e.getMessage());
		e.printStackTrace();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		logger.error(e.getMessage());
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
    
    if (monitor.isCanceled()){
    	//Phai stop query luon
      throw new InterruptedException(query.get_querynm() + " -> running operation was cancelled");
    }
  }
}
