package org.eib.database;

import java.io.FileOutputStream;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.*;
import org.eib.common.AppCommon;
import org.eib.common.DateTimeUtil;

public class CommandMultiQuery extends Thread{
	
	Connection _conn;
	Query _query;  
	AppCommon _app;
	private static Logger logger =Logger.getLogger("CommandMultiQuery");
	
	
	public void run()
    {
		try {
			commandMulQueryExcel(_conn,_query,_app,true,false);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			//System.out.println(" Loi o script: "+_query.get_querynm());
			logger.error(_query.get_querynm());
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
    public static void commandMulQueryExcel(Connection conn, 
    										Query query,
    										AppCommon _app,
            boolean showHeaders, boolean showMetaData) throws InterruptedException {
        Statement stmt = null;        
        try {
        	
        	//Bat dau chay set status = 1
        	query.set_status("1");
        	System.out.println(" >>Run script= "+query.get_queryid()+", name="+query.get_querynm()+", status= "+query.get_status());
        	
        	Date date1 ;
        	Date date2 ;
    		DateFormat dateFormat;
    		
    		int i1, i2;
    		
    		Calendar ca1 = Calendar.getInstance();
    		
        	dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");	        	
    		date1= new Date();
    		query.set_startDate(dateFormat.format(date1));    		
    		ca1.setTime(date1);
    		i1= ca1.get(Calendar.DATE);
    		logger.info("i1="+i1);
    		
        	//ResourceBundle rb = ResourceBundle.getBundle("database");		
        	//_Excelrow = Long.parseLong(rb.getString("excelrows"));   
        	//System.out.println("_Excelrow= "+_Excelrow);
        	
        	HSSFWorkbook book = new HSSFWorkbook();
        	HSSFSheet sheet = null;
        	            
            stmt = conn.createStatement();
            long rowPos = 0;
            long _rownguyen = 0;
            long _rowbu=0;
            
            boolean resp = stmt.execute(query.get_exquery());
            if (resp) {            	
                ResultSet rs = stmt.getResultSet();
                ResultSetMetaData rsmd = rs.getMetaData();               
                                           		                                             
                //Show du lieu
                //_excelrow = rs.next()/65636; //Phan phan nguyen cong 1                
                while (rs.next()) {                	
                	_rownguyen =rowPos/_app.get_excelrows();//_Excelrow; //65636
                	_rowbu=rowPos%_app.get_excelrows();
                	if (_rowbu ==0){
                		sheet = book.createSheet(String.valueOf(_rownguyen+1));
                		 //Tao phan header
    	                if (showHeaders) {
    	                	HSSFRow row = sheet.createRow((int) _rowbu);
    	                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
    	                    	HSSFCell cell = row.createCell(i - 1);
    	                        cell.setCellValue(rsmd.getColumnName(i));
    	                    }
    	                    rowPos++;
    	                }
    	                if (showMetaData) {
    	                	HSSFRow row = sheet.createRow((int) _rowbu);
    	                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
    	                    	HSSFCell cell = row.createCell(i - 1);
    	                        int scale = rsmd.getScale(i);
    	                        cell.setCellValue(rsmd.getColumnTypeName(i) + "("
    	                                + rsmd.getPrecision(i) + " " + scale + ")");
    	
    	                    }
    	                    rowPos++;
    	                }
    	                
    	                //insert them 1 dong 1
    	                HSSFRow	 row = sheet.createRow((int) 1);	                   	                   
	                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
	                    	HSSFCell cell = row.createCell(i - 1);
	                    	
	                    	if (rsmd.getColumnType(i) == java.sql.Types.CHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.VARCHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.NCHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.LONGVARCHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.LONGNVARCHAR) {      
	                            cell.setCellValue(rs.getString(i));
	                            //logger.info("getString: "+rs.getString(i));
	                       }
	                       else if (rsmd.getColumnType(i) == java.sql.Types.DOUBLE) {
	                    	   //cell.setCellValue(rs.getString(i));
	                            cell.setCellValue(rs.getDouble(i));
	                            //logger.info("DOUBLE - getDouble: "+rs.getDouble(i));                                                  
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.DECIMAL) { //Thuong vo kieu nay
	                            cell.setCellValue( rs.getDouble(i));
	                    	   //cell.setCellValue( rs.getString(i));//Dung
	                            //logger.info("[1]DECIMAL - getDouble: "+rs.getDouble(i));  
	                            //logger.info("[2]DECIMAL - getString: "+rs.getString(i));  
	                            //logger.info("[3]DECIMAL - getBigDecimal: "+rs.getBigDecimal(i));                              
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.FLOAT ){
	                           cell.setCellValue(rs.getDouble(i));
	                    	   //cell.setCellValue( rs.getString(i));
	                          // logger.info("FLOAT - getFloat: "+rs.getFloat(i));  
	                           //logger.info("FLOAT - getDouble: "+rs.getDouble(i));
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.NUMERIC ){
	                           cell.setCellValue(rs.getDouble(i));
	                    	   //cell.setCellValue(rs.getString(i)); //Dung
	                           //logger.info("[1]NUMERIC  - getLong: "+rs.getLong(i));  
	                           //logger.info("[2]NUMERIC  - getDouble: "+rs.getDouble(i)); //Oracle sai
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.INTEGER ){
	                           cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                           //logger.info("INTEGER  - getLong: "+rs.getLong(i));  
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.SMALLINT ){
	                           cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                           //logger.info("SMALLINT - getLong: "+rs.getLong(i));  
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.BIGINT ){ //Thuong vo kieu nay
	                           cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                          // logger.info("[1]BIGINT - getLong: "+rs.getLong(i));  
	                           //logger.info("[2]BIGINT - getBigDecimal: "+rs.getBigDecimal(i));                                                      
	                       }
	                       else if ( rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
	                            cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                           //logger.info(" TINYINT: "+rs.getLong(i));                                                        
	                       } 
	                       else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
	                            java.util.Date d = new java.util.Date();
	                            d.setTime(rs.getDate(i).getTime());
	                            cell.setCellValue(d);
	                       } 
	                       else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
	                            java.util.Date d = new java.util.Date();
	                            d.setTime(rs.getTimestamp(i).getTime());
	                            cell.setCellValue(d);
	                       } 
	                       else {
	                            cell.setCellValue("" + rs.getString(i));
	                       } 
	                    }
                	}
                	else
                	{
                		//if (_rowbu<6)
                			//System.out.println("_rownguyen= "+_rownguyen+" _rowbu= "+ _rowbu+" rowPos= "+rowPos);                                	
                		HSSFRow	 row = sheet.createRow((int) _rowbu);	                   	                   
	                   
	                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
	                    	HSSFCell cell = row.createCell(i - 1);
	                    	
	                    	if (rsmd.getColumnType(i) == java.sql.Types.CHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.VARCHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.NCHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.LONGVARCHAR
	                                || rsmd.getColumnType(i) == java.sql.Types.LONGNVARCHAR) {      
	                            cell.setCellValue(rs.getString(i));
	                            //logger.info("getString: "+rs.getString(i));
	                       }
	                       else if (rsmd.getColumnType(i) == java.sql.Types.DOUBLE) {
	                    	   //cell.setCellValue(rs.getString(i));
	                            cell.setCellValue(rs.getDouble(i));
	                            //logger.info("DOUBLE - getDouble: "+rs.getDouble(i));                                                  
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.DECIMAL) { //Thuong vo kieu nay
	                            cell.setCellValue( rs.getDouble(i));
	                    	   //cell.setCellValue( rs.getString(i));//Dung
	                            //logger.info("[1]DECIMAL - getDouble: "+rs.getDouble(i));  
	                            //logger.info("[2]DECIMAL - getString: "+rs.getString(i));  
	                            //logger.info("[3]DECIMAL - getBigDecimal: "+rs.getBigDecimal(i));                              
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.FLOAT ){
	                           cell.setCellValue(rs.getDouble(i));
	                    	   //cell.setCellValue( rs.getString(i));
	                          // logger.info("FLOAT - getFloat: "+rs.getFloat(i));  
	                           //logger.info("FLOAT - getDouble: "+rs.getDouble(i));
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.NUMERIC ){
	                           cell.setCellValue(rs.getDouble(i));
	                    	   //cell.setCellValue(rs.getString(i)); //Dung
	                           //logger.info("[1]NUMERIC  - getLong: "+rs.getLong(i));  
	                           //logger.info("[2]NUMERIC  - getDouble: "+rs.getDouble(i)); //Oracle sai
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.INTEGER ){
	                           cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                           //logger.info("INTEGER  - getLong: "+rs.getLong(i));  
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.SMALLINT ){
	                           cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                           //logger.info("SMALLINT - getLong: "+rs.getLong(i));  
	                       }
	                       else if(rsmd.getColumnType(i) == java.sql.Types.BIGINT ){ //Thuong vo kieu nay
	                           cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                          // logger.info("[1]BIGINT - getLong: "+rs.getLong(i));  
	                           //logger.info("[2]BIGINT - getBigDecimal: "+rs.getBigDecimal(i));                                                      
	                       }
	                       else if ( rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
	                            cell.setCellValue(rs.getLong(i));
	                    	   //cell.setCellValue(rs.getString(i));
	                           //logger.info(" TINYINT: "+rs.getLong(i));                                                        
	                       } 
	                       else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
	                            java.util.Date d = new java.util.Date();
	                            d.setTime(rs.getDate(i).getTime());
	                            cell.setCellValue(d);
	                       } 
	                       else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
	                            java.util.Date d = new java.util.Date();
	                            d.setTime(rs.getTimestamp(i).getTime());
	                            cell.setCellValue(d);
	                       } 
	                       else {
	                            cell.setCellValue("" + rs.getString(i));
	                       } 
	                    }
                	}
                    rowPos++;
                }
                //book.write(new FileOutputStream(query.get_queryouturl()));
                date2= new Date();        		
        		//Calendar ca2 = Calendar.getInstance();
        		query.set_endDate(dateFormat.format(date2));
        		ca1.setTime(date2);
        		i2= ca1.get(Calendar.DATE);
        		logger.info("i2="+i2);
        		//query.set_endDate(DateTimeUtil.getDateTime());
        		
                //book.write(new FileOutputStream(_app.get_outurl_excel("["+query.get_startDate()+"]["+query.get_endDate()+"]"+query.get_querynm())));
        		book.write(new FileOutputStream(_app.get_outurl_excel(" ["+query.get_startDate()+"]["+query.get_endDate()+"]"+query.get_querynm()+"["+ String.valueOf(i2-i1)+"s]")));
            } else {
                stmt.getUpdateCount();
            }  
            
            query.set_status("8");//OK            
    		query.set_endDate(DateTimeUtil.getDateTime());
    		
            logger.info(">Done. STARTDT["+ query.get_startDate()+"] ENDDT[" + query.get_endDate() +"] status["+query.get_status()+"] script= "+query.get_queryid()+", name="+query.get_querynm());
            conn.close();//dong connect lai
            //System.out.println(" >>script= "+query.get_queryid()+": OK ");
        } catch (Exception e) {
            e.printStackTrace();
            query.set_status("3");//Fail 
            
            //Set thoi gian ket thuc           
    		query.set_endDate(DateTimeUtil.getDateTime());
    		
            logger.info(">Done. STARTDT["+ query.get_startDate()+"] ENDDT[" + query.get_endDate() +"] status["+query.get_status()+"] script= "+query.get_queryid()+", name="+query.get_querynm());
            logger.error(e.getMessage());                                    
        }finally {
            try {
                if (stmt != null) {
                    stmt.close();
                    //query.set_status("8");//OK
                    conn.close();//dong connect lai                                                           
                }
            } catch (SQLException ex) {
            	query.set_status("3");
            	
            	 //Set thoi gian ket thuc                 
        		query.set_endDate(DateTimeUtil.getDateTime());
        		
                logger.info(">Done. STARTDT["+ query.get_startDate()+"] ENDDT[" + query.get_endDate() +"] status["+query.get_status()+"] script= "+query.get_queryid()+", name="+query.get_querynm());
                logger.error(ex.getMessage());
            }
        }
        
        //Set thoi gian ket thuc 
        /*
        DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss,dd/MM/yyyy");
		Date date = new Date();
		query.set_endDate(dateFormat.format(date));
		
        logger.info(">Done. STARTDT["+ query.get_startDate()+"] ENDDT[" + query.get_endDate() +"] status["+query.get_status()+"] script= "+query.get_queryid()+", name="+query.get_querynm());
        */
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
