package org.eib.database;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.Reader;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.*;
import org.eib.common.AppCommon;
import org.eib.common.DateTimeUtil;
import org.eib.common.FolderUtil;

import com.ibatis.common.jdbc.ScriptRunner;

/**
 * Dung de chay script file
 * @author GOGO Tran
 *
 */
public class CommandMultiQuery extends Thread{
	
	Connection _conn;
	Query _query;  
	AppCommon _app;
	private static Logger logger =Logger.getLogger("CommandMultiQuery");
	
	
	public void run()
    {
		try {
			commandMulQuery(_conn,_query,_app,true,false);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			logger.error(_query.get_querynm());
			_query.set_status("3");      
			e.printStackTrace();
		}
    }
	
    /**
     * Chay script tu doi tuong script
     * @param conn
     * @param query
     * @param showHeaders
     * @param showMetaData
     * @param filename
     */
    public static void commandMulQuery(Connection conn, 
    										Query query,
    										AppCommon _app,
       boolean showHeaders, boolean showMetaData) throws InterruptedException {      
        try {
        	
        	//Bat dau chay set status = 1
        	query.set_status("1");
        	//System.out.println(" >>Run script= "+query.get_queryid()+", name="+query.get_querynm()+", status= "+query.get_status());
        	logger.info("Run ["+query.get_queryid()+"] - "+query.get_querynm());
        	Date date1, date2;
    		DateFormat dateFormat, dateFormat2;
    		
    		//int i1, i2;    		
    		//Calendar ca1 = Calendar.getInstance();
    		
        	dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");	        	
    		date1= new Date();
    		query.set_startDate(dateFormat.format(date1));   
    		
        	ScriptRunner sr = new ScriptRunner(conn, false, false);            
        	Reader reader = new BufferedReader( new FileReader(query.get_fileurl()));
			// Exctute script
			sr.runScript(reader);        
            
            query.set_status("8");//OK                		
            dateFormat2 = new SimpleDateFormat("yyyyMMdd_HHmmss");	
            date2= new Date();        		
            query.set_endDate(dateFormat2.format(date2));    
            
            logger.info(">Done. S["+ query.get_startDate()+"] E[" + query.get_endDate() +"] status["+query.get_status()+"]P["+query.get_priority()+"]T["+query.get_times()+"] script= "+query.get_queryid()+", name= "+query.get_querynm());
            conn.close();//dong connect lai
            //System.out.println(" >>script= "+query.get_queryid()+": OK ");
        } catch (Exception e) {
            
            query.set_status("3");//Fail             
            //Set thoi gian ket thuc           
    		query.set_endDate(DateTimeUtil.getDateYYYYMMDD());
    		
            logger.info(">Fail. S["+ query.get_startDate()+"] E[" + query.get_endDate() +"] status["+query.get_status()+"]P["+query.get_priority()+"]T["+query.get_times()+"] script= "+query.get_queryid()+", name= "+query.get_querynm());
            logger.error("Error= "+ e.getMessage());
            e.printStackTrace();            
        }
        
        
    }

	public CommandMultiQuery(Connection _conn, Query _query, AppCommon _app) {
		super();
		this._conn = _conn;
		this._query = _query;
		this._app = _app;
	}

	public Connection get_conn() {
		return _conn;
	}

	public void set_conn(Connection _conn) {
		this._conn = _conn;
	}

	public Query get_query() {
		return _query;
	}

	public void set_query(Query _query) {
		this._query = _query;
	}

	public AppCommon get_app() {
		return _app;
	}

	public void set_app(AppCommon _app) {
		this._app = _app;
	}
}
