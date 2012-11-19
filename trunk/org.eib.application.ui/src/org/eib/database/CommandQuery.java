package org.eib.database;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.TreeMap;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.RichTextString;
import org.eib.common.JavaUtil;

public class CommandQuery {
       
        private static Logger logger =Logger.getLogger("CommandQuery");
        private static long  _Excelrow = 50000; //65636
        private static int _dperComplete; //Phan tram thuc hien script
        private static String _message;
       
       
        public static String get_message() {
                return _message;
        }

        public void set_message(String _message) {
                CommandQuery._message = _message;
        }

        public static double get_dperComplete() {
                return _dperComplete;
        }

        public static void set_dperComplete(int _dperComplete) {
                CommandQuery._dperComplete = _dperComplete;
        }

        public static long get_Excelrow() {
                return _Excelrow;
        }

        public static void set_Excelrow(long _Excelrow) {
                CommandQuery._Excelrow = _Excelrow;
        }

        /**
         * Lay gia tri cua cac bien dau vao
         * @param conn
         * @param query
         */
        public static TreeMap<String, String> queryGetVar(Connection conn, String query){
                Statement stmt = null;  
                TreeMap<String, String> tMap = new TreeMap<String, String>();  
        try {
            stmt = conn.createStatement();
            boolean resp = stmt.execute(query);
           
            if (resp) {
                ResultSet rs = stmt.getResultSet();
                ResultSetMetaData rsmd = rs.getMetaData();                                      
               
                while (rs.next()) {
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        //System.out.println("A = "+rsmd.getColumnName(i) + ":"+rs.getString(i)+" --> "+String.valueOf(rsmd.getColumnName(i)).toLowerCase());                        
                        //Day vao tri treemap, , TreeMap tMa
                        //System.out.print(rs.getString(i));
                       
                        //toan chu thuong
                        if (String.valueOf(rsmd.getColumnName(i)).toLowerCase().equals("h_trdt"))
                                tMap.put("01"+String.valueOf(rsmd.getColumnName(i)).toLowerCase(), String.valueOf(rs.getString(i)));
                        else if (String.valueOf(rsmd.getColumnName(i)).toLowerCase().equals("h_startdt"))
                                tMap.put("02"+String.valueOf(rsmd.getColumnName(i)).toLowerCase(), String.valueOf(rs.getString(i)));
                        else if (String.valueOf(rsmd.getColumnName(i)).toLowerCase().equals("h_enddt"))
                                tMap.put("03"+String.valueOf(rsmd.getColumnName(i)).toLowerCase(), String.valueOf(rs.getString(i)));
                        else if (String.valueOf(rsmd.getColumnName(i)).toLowerCase().equals("h_bstartdt"))
                                tMap.put("04"+String.valueOf(rsmd.getColumnName(i)).toLowerCase(), String.valueOf(rs.getString(i)));
                        else if (String.valueOf(rsmd.getColumnName(i)).toLowerCase().equals("h_predt"))
                                tMap.put("05"+String.valueOf(rsmd.getColumnName(i)).toLowerCase(), String.valueOf(rs.getString(i)));
                        else
                                tMap.put(String.valueOf(rsmd.getColumnName(i)).toLowerCase(), String.valueOf(rs.getString(i)));                                                    
                    }
                    //System.out.println();
                }
            } else {
                stmt.getUpdateCount();
            }
        } catch (Exception e) {
                logger.error(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                //JavaUtil.showHashMap(tMap);
                stmt.close();              
            } catch (SQLException ex) {
            	logger.error(ex.getMessage());			
            }
        }
        //System.out.println("A = ");
        //JavaUtil.showHashMap(tMap);
                return tMap;            
        }
       
        /**
         *
         * @param conn
         * @param query
         * @param showHeaders
         * @param separator
         * @param showMetaData
         */
    public static void commandQuery(Connection conn, String query,
            boolean showHeaders, String separator, boolean showMetaData) {
        Statement stmt = null;
        try {
            stmt = conn.createStatement();
            boolean resp = stmt.execute(query);
            if (resp) {
                ResultSet rs = stmt.getResultSet();
                ResultSetMetaData rsmd = rs.getMetaData();
                if (showHeaders) {
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        //System.out.print(rsmd.getColumnName(i) + separator);
                    }
                    //System.out.println();
                }
                if (showMetaData) {
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        String scale = "";
                        if (rsmd.getScale(i) != 0) {
                            scale = "," + rsmd.getScale(i);
                        }
                        //System.out.print(rsmd.getColumnTypeName(i) + "("
                        //        + rsmd.getPrecision(i) + "" + scale + ")"
                        //        + separator);
                    }
                    //System.out.println();
                }
                while (rs.next()) {
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        //System.out.print(rs.getString(i) + separator);
                    }
                    //System.out.println();
                }
            } else {
                stmt.getUpdateCount();
            }
        } catch (Exception e) {
                logger.error(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                stmt.close();
            } catch (SQLException ex) {
            	logger.error(ex.getMessage());			
            }
        }
    }
   
   
    /**
     * Thuc thi Functions or create Table
     * @param conn
     * @param query
     */
    public static void commandFunctions(Connection conn, String query) {
        Statement stmt = null;
        try {
            stmt = conn.createStatement();
            boolean resp = stmt.execute(query);
            if (resp) {
                //Ko lam gi                
               
            } else {
                stmt.getUpdateCount();
            }
        } catch (Exception e) {
                logger.error(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                stmt.close();
            } catch (SQLException ex) {
            	logger.error(ex.getMessage());			
            }
        }
    }
   

    /*
    public static void commandQueryExcel(Connection conn, String query,
            boolean showHeaders, boolean showMetaData, String filename) {
        Statement stmt = null;
        long _excelrow=0;
        long _rowtemp=0;
        try {

            SXSSFWorkbook book = new SXSSFWorkbook();
            SXSSFSheet sheet = (SXSSFSheet) book.createSheet("1"); //Tao sheet 1
           
            stmt = conn.createStatement();
            long rowPos = 0;
            boolean resp = stmt.execute(query);
            if (resp) {
                ResultSet rs = stmt.getResultSet();
                ResultSetMetaData rsmd = rs.getMetaData();
                if (showHeaders) {
                    Row row = sheet.createRow((int) rowPos);
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        Cell cell = row.createCell(i - 1);
                        cell.setCellValue(rsmd.getColumnName(i));
                    }
                    rowPos++;
                }
                if (showMetaData) {
                    Row row = sheet.createRow((int) rowPos);
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        Cell cell = row.createCell(i - 1);
                        int scale = rsmd.getScale(i);
                        cell.setCellValue(rsmd.getColumnTypeName(i) + "("
                                + rsmd.getPrecision(i) + " " + scale + ")");

                    }
                    rowPos++;
                }
                //_excelrow = rs.next()/65636; //Phan phan nguyen cong 1
                while (rs.next()) {                    
                        Row row = sheet.createRow((int) rowPos);                                        
                    System.out.println("_excelrow= "+_excelrow+" rowPos= "+ rowPos+" _rowtemp= "+_rowtemp);
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        Cell cell = row.createCell(i - 1);
                        if (rsmd.getColumnType(i) == java.sql.Types.CHAR
                                || rsmd.getColumnType(i) == java.sql.Types.VARCHAR
                                || rsmd.getColumnType(i) == java.sql.Types.NCHAR
                                || rsmd.getColumnType(i) == java.sql.Types.LONGVARCHAR
                                || rsmd.getColumnType(i) == java.sql.Types.LONGNVARCHAR) {

                            cell.setCellValue(rs.getString(i));
                        } else if (rsmd.getColumnType(i) == java.sql.Types.DOUBLE
                                || rsmd.getColumnType(i) == java.sql.Types.FLOAT) {

                            cell.setCellValue(rs.getDouble(i));
                        } else if (rsmd.getColumnType(i) == java.sql.Types.NUMERIC
                                || rsmd.getColumnType(i) == java.sql.Types.DECIMAL
                                || rsmd.getColumnType(i) == java.sql.Types.INTEGER
                                || rsmd.getColumnType(i) == java.sql.Types.SMALLINT
                                || rsmd.getColumnType(i) == java.sql.Types.BIGINT
                                || rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
                            cell.setCellValue(rs.getLong(i));
                        } else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {

                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getDate(i).getTime());
                            cell.setCellValue(d);
                        } else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getTimestamp(i).getTime());
                            cell.setCellValue(d);
                        } else {
                            cell.setCellValue("" + rs.getString(i));
                        }
                    }
                    rowPos++;
                }

                book.write(new FileOutputStream(filename));
            } else {
                stmt.getUpdateCount();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException ex) {
            }

        }

    }*/

    /*
     * Excel 2003
     */
    /*
    public static void commandQueryExcel(Connection conn, String query,
            boolean showHeaders, boolean showMetaData, String filename) {
        Statement stmt = null;
        long _excelrow=0;
        long _rowtemp=0;
        try {
                HSSFWorkbook book = new HSSFWorkbook();
                HSSFSheet sheet = book.createSheet("1");                          
           
            stmt = conn.createStatement();
            long rowPos = 0;
            boolean resp = stmt.execute(query);
            if (resp) {
                ResultSet rs = stmt.getResultSet();
                ResultSetMetaData rsmd = rs.getMetaData();
                if (showHeaders) {
                        HSSFRow row = sheet.createRow((int) rowPos);                                        
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        HSSFCell cell = row.createCell(i - 1);
                        cell.setCellValue(rsmd.getColumnName(i));
                    }
                    rowPos++;
                }
                if (showMetaData) {
                        HSSFRow row = sheet.createRow((int) rowPos);
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        HSSFCell cell = row.createCell(i - 1);
                        int scale = rsmd.getScale(i);
                        cell.setCellValue(rsmd.getColumnTypeName(i) + "("
                                + rsmd.getPrecision(i) + " " + scale + ")");

                    }
                    rowPos++;
                }
                //_excelrow = rs.next()/65636; //Phan phan nguyen cong 1
                while (rs.next()) {                    
                        HSSFRow row = sheet.createRow((int) rowPos);                                        
                    System.out.println("_excelrow= "+_excelrow+" rowPos= "+ rowPos+" _rowtemp= "+_rowtemp);
                    for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                        HSSFCell cell = row.createCell(i - 1);
                        if (rsmd.getColumnType(i) == java.sql.Types.CHAR
                                || rsmd.getColumnType(i) == java.sql.Types.VARCHAR
                                || rsmd.getColumnType(i) == java.sql.Types.NCHAR
                                || rsmd.getColumnType(i) == java.sql.Types.LONGVARCHAR
                                || rsmd.getColumnType(i) == java.sql.Types.LONGNVARCHAR) {

                            cell.setCellValue(rs.getString(i));
                        } else if (rsmd.getColumnType(i) == java.sql.Types.DOUBLE
                                || rsmd.getColumnType(i) == java.sql.Types.FLOAT) {

                            cell.setCellValue(rs.getDouble(i));
                        } else if (rsmd.getColumnType(i) == java.sql.Types.NUMERIC
                                || rsmd.getColumnType(i) == java.sql.Types.DECIMAL
                                || rsmd.getColumnType(i) == java.sql.Types.INTEGER
                                || rsmd.getColumnType(i) == java.sql.Types.SMALLINT
                                || rsmd.getColumnType(i) == java.sql.Types.BIGINT
                                || rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
                            cell.setCellValue(rs.getLong(i));
                        } else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {

                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getDate(i).getTime());
                            cell.setCellValue(d);
                        } else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getTimestamp(i).getTime());
                            cell.setCellValue(d);
                        } else {
                            cell.setCellValue("" + rs.getString(i));
                        }
                    }
                    rowPos++;
                }

                book.write(new FileOutputStream(filename));
            } else {
                stmt.getUpdateCount();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException ex) {
            }

        }

    }
    */
   
   
    /**
     * Thuc hien script voi cau query duoc vao    
     * @param conn
     * @param query
     * @param showHeaders
     * @param showMetaData
     * @param filename
     * @throws FileNotFoundException
     * @throws IOException
     * @throws SQLException
     */
    public static void commandQueryExcel(Connection conn, String query,
            boolean showHeaders, boolean showMetaData, String filename) throws FileNotFoundException, IOException, SQLException {
        Statement stmt = null;                  
       
        HSSFWorkbook book = new HSSFWorkbook();
        HSSFSheet sheet = null;
                   
        stmt = conn.createStatement();
        long rowPos = 0;
        long _rownguyen = 0;
        long _rowbu=0;
       
        _message = "Run Report....";
        boolean resp = stmt.execute(query);
               
        if (resp) {            
            ResultSet rs = stmt.getResultSet();
            ResultSetMetaData rsmd = rs.getMetaData();              
                       
            _message = "Export Excel....";
            //Show du lieu
            //_excelrow = rs.next()/65636; //Phan phan nguyen cong 1                
            while (rs.next()) {                
                _rownguyen =rowPos/_Excelrow;//_Excelrow; //65636
                _rowbu=rowPos%_Excelrow;
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
                        HSSFRow  row = sheet.createRow((int) 1);                                                  
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
                        HSSFRow  row = sheet.createRow((int) _rowbu);                                                                      
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
                            cell.setCellValue(rs.getDouble(i));
                    	   //cell.setCellValue(rs.getString(i));
                            //logger.info("DOUBLE - getDouble: "+rs.getDouble(i));                                                  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.DECIMAL) { //Thuong vo kieu nay
                            cell.setCellValue( rs.getDouble(i));
                    	   //cell.setCellValue( rs.getString(i)); //Dung
                            //logger.info("[1]DECIMAL - getDouble: "+rs.getDouble(i));  
                            //logger.info("[2]DECIMAL - getBigDecimal: "+rs.getBigDecimal(i));                              
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.FLOAT ){
                           cell.setCellValue(rs.getDouble(i));
                    	   //cell.setCellValue( rs.getString(i));
                           //logger.info("FLOAT - getFloat: "+rs.getFloat(i));  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.NUMERIC ){
                           cell.setCellValue(rs.getDouble(i));
                    	   //cell.setCellValue(rs.getString(i)); //Dung
                           //logger.info("NUMERIC  - getLong: "+rs.getLong(i));  
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
                           //logger.info("[1]BIGINT - getLong: "+rs.getLong(i));  
                           //logger.info("[2]BIGINT - getBigDecimal: "+rs.getBigDecimal(i));                                                      
                       }
                       else if ( rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
                            cell.setCellValue(rs.getLong(i));
                    	   //cell.setCellValue(rs.getString(i));
                            //logger.info(" TINYINT: "+rs.getLong(i));                                                        
                        } else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getDate(i).getTime());
                            cell.setCellValue(d);
                        } else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getTimestamp(i).getTime());
                            cell.setCellValue(d);
                        } else {
                            cell.setCellValue("" + rs.getString(i));
                        }
                       
                    }
                }
                rowPos++;
                //System.out.println("rowPos= "+rowPos);
            }
           
            //Bo ket noi file
            FileOutputStream outfile = new FileOutputStream(filename);
            //book.write(new FileOutputStream(filename));
            book.write(outfile);
            outfile.close();
           
        } else {
            stmt.getUpdateCount();
        }  
       
        //System.out.println("--> OK");
        //_dperComplete = 100;
        //logger.info("> OK");
        if (stmt != null) {
                stmt.close();
        }                  
    }
    
    /**
     * 
     * @param conn
     * @param query
     * @param showHeaders
     * @param showMetaData
     * @param filename
     * @throws FileNotFoundException
     * @throws IOException
     * @throws SQLException
     */
    public static void commandQueryStringExcel(Connection conn, String query,
            boolean showHeaders, boolean showMetaData, String filename) throws FileNotFoundException, IOException, SQLException 
    {
        Statement stmt = null;                  
       
        HSSFWorkbook book = new HSSFWorkbook();
        HSSFSheet sheet = null;
                   
        stmt = conn.createStatement();
        long rowPos = 0;
        long _rownguyen = 0;
        long _rowbu=0;
       
        _message = "Run Report....";
        boolean resp = stmt.execute(query);
               
        if (resp) {            
            ResultSet rs = stmt.getResultSet();
            ResultSetMetaData rsmd = rs.getMetaData();              
                       
            _message = "Export Excel....";
            //Show du lieu
            //_excelrow = rs.next()/65636; //Phan phan nguyen cong 1                
            while (rs.next()) {                
                _rownguyen =rowPos/_Excelrow;//_Excelrow; //65636
                _rowbu=rowPos%_Excelrow;
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
                        HSSFRow  row = sheet.createRow((int) 1);                                                  
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
                    	   cell.setCellValue(rs.getString(i));
                           //cell.setCellValue(rs.getDouble(i));
                           //logger.info("DOUBLE - getDouble: "+rs.getDouble(i));                                                  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.DECIMAL) { //Thuong vo kieu nay
                           //cell.setCellValue( rs.getDouble(i));
                    	   cell.setCellValue( rs.getString(i));
                            //logger.info("[1]DECIMAL - getDouble: "+rs.getDouble(i));  
                            //logger.info("[2]DECIMAL - getString: "+rs.getString(i));  
                            //logger.info("[3]DECIMAL - getBigDecimal: "+rs.getBigDecimal(i));                              
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.FLOAT ){
                           //cell.setCellValue(rs.getDouble(i));
                    	   cell.setCellValue( rs.getString(i));
                           //logger.info("FLOAT - getFloat: "+rs.getFloat(i));  
                           //logger.info("FLOAT - getDouble: "+rs.getDouble(i));
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.NUMERIC ){
                           //cell.setCellValue(rs.getDouble(i));
                    	   cell.setCellValue(rs.getString(i));
                           //logger.info("[1]NUMERIC  - getLong: "+rs.getLong(i));  
                           //logger.info("[2]NUMERIC  - getDouble: "+rs.getDouble(i)); //Oracle sai
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.INTEGER ){
                           //cell.setCellValue(rs.getLong(i));
                    	   cell.setCellValue(rs.getString(i));
                           //logger.info("INTEGER  - getLong: "+rs.getLong(i));  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.SMALLINT ){
                           //cell.setCellValue(rs.getLong(i));
                    	   cell.setCellValue(rs.getString(i));
                           //logger.info("SMALLINT - getLong: "+rs.getLong(i));  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.BIGINT ){ //Thuong vo kieu nay
                           //cell.setCellValue(rs.getLong(i));
                    	   cell.setCellValue(rs.getString(i));
                           //logger.info("[1]BIGINT - getLong: "+rs.getLong(i));  
                           //logger.info("[2]BIGINT - getBigDecimal: "+rs.getBigDecimal(i));                                                      
                       }
                       else if ( rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
                           //cell.setCellValue(rs.getLong(i));
                    	   cell.setCellValue(rs.getString(i));
                           //logger.info(" TINYINT: "+rs.getLong(i));                                                        
                        } else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getDate(i).getTime());
                            cell.setCellValue(d);
                        } else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getTimestamp(i).getTime());
                            cell.setCellValue(d);
                        } else {
                            cell.setCellValue("" + rs.getString(i));
                        }                       
                    }
                }
                else
                {
                        //if (_rowbu<6)
                                //System.out.println("_rownguyen= "+_rownguyen+" _rowbu= "+ _rowbu+" rowPos= "+rowPos);                                
                        HSSFRow  row = sheet.createRow((int) _rowbu);                                                                      
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
                            cell.setCellValue(rs.getString(i));
                    	   //cell.setCellValue(rs.getString(i));
                            //logger.info("DOUBLE - getDouble: "+rs.getDouble(i));                                                  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.DECIMAL) { //Thuong vo kieu nay
                            //cell.setCellValue( rs.getDouble(i));
                    	   cell.setCellValue( rs.getString(i));
                            //logger.info("[1]DECIMAL - getDouble: "+rs.getDouble(i));  
                            //logger.info("[2]DECIMAL - getBigDecimal: "+rs.getBigDecimal(i));                              
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.FLOAT ){
                           cell.setCellValue(rs.getString(i));
                    	   //cell.setCellValue( rs.getString(i));
                           //logger.info("FLOAT - getFloat: "+rs.getFloat(i));  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.NUMERIC ){
                           cell.setCellValue(rs.getString(i));
                    	   //cell.setCellValue(rs.getString(i));
                           //logger.info("NUMERIC  - getLong: "+rs.getLong(i));  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.INTEGER ){
                           cell.setCellValue(rs.getString(i));
                    	   //cell.setCellValue(rs.getString(i));
                           //logger.info("INTEGER  - getLong: "+rs.getLong(i));  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.SMALLINT ){
                           cell.setCellValue(rs.getString(i));
                    	   //cell.setCellValue(rs.getString(i));
                           //logger.info("SMALLINT - getLong: "+rs.getLong(i));  
                       }
                       else if(rsmd.getColumnType(i) == java.sql.Types.BIGINT ){ //Thuong vo kieu nay
                           cell.setCellValue(rs.getString(i));
                    	   //cell.setCellValue(rs.getString(i));
                           //logger.info("[1]BIGINT - getLong: "+rs.getLong(i));  
                           //logger.info("[2]BIGINT - getBigDecimal: "+rs.getBigDecimal(i));                                                      
                       }
                       else if ( rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
                            cell.setCellValue(rs.getString(i));
                    	   //cell.setCellValue(rs.getString(i));
                            //logger.info(" TINYINT: "+rs.getLong(i));                                                        
                        } else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getDate(i).getTime());
                            cell.setCellValue(d);
                        } else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
                            java.util.Date d = new java.util.Date();
                            d.setTime(rs.getTimestamp(i).getTime());
                            cell.setCellValue(d);
                        } else {
                            cell.setCellValue("" + rs.getString(i));
                        }                       
                    }
                }
                rowPos++;
                //System.out.println("rowPos= "+rowPos);
            }
           
            //Bo ket noi file
            FileOutputStream outfile = new FileOutputStream(filename);
            //book.write(new FileOutputStream(filename));
            book.write(outfile);
            outfile.close();
           
        } else {
            stmt.getUpdateCount();
        }  
       
        //System.out.println("--> OK");
        //_dperComplete = 100;
        //logger.info("> OK");
        if (stmt != null) {
                stmt.close();
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
    public static void commandMulQueryExcel(Connection conn, Query query,
            boolean showHeaders, boolean showMetaData) {
        Statement stmt = null;        
        try {          
                logger.info(" Run script= "+query.get_queryid());
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
                        _rownguyen =rowPos/_Excelrow;//_Excelrow; //65636
                        _rowbu=rowPos%_Excelrow;
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
                        HSSFRow  row = sheet.createRow((int) 1);                                                  
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
                                    cell.setCellValue(rs.getDouble(i));
                                    //logger.info("DOUBLE - getDouble: "+rs.getDouble(i));                                                  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.DECIMAL) { //Thuong vo kieu nay
                                    //cell.setCellValue( rs.getDouble(i));
                            	   cell.setCellValue( rs.getString(i));
                                    //logger.info("[1]DECIMAL - getDouble: "+rs.getDouble(i));  
                                    //logger.info("[2]DECIMAL - getBigDecimal: "+rs.getBigDecimal(i));                              
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.FLOAT ){
                                   //cell.setCellValue(rs.getFloat(i));
                            	   cell.setCellValue( rs.getString(i));
                                   //logger.info("FLOAT - getFloat: "+rs.getFloat(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.NUMERIC ){
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("NUMERIC  - getLong: "+rs.getLong(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.INTEGER ){
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("INTEGER  - getLong: "+rs.getLong(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.SMALLINT ){
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("SMALLINT - getLong: "+rs.getLong(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.BIGINT ){ //Thuong vo kieu nay
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("[1]BIGINT - getLong: "+rs.getLong(i));  
                                   //logger.info("[2]BIGINT - getBigDecimal: "+rs.getBigDecimal(i));                                                      
                               }
                               else if ( rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
                                    cell.setCellValue(rs.getLong(i));
                                    //logger.info(" TINYINT: "+rs.getLong(i));                                                        
                                } else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
                                    java.util.Date d = new java.util.Date();
                                    d.setTime(rs.getDate(i).getTime());
                                    cell.setCellValue(d);
                                } else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
                                    java.util.Date d = new java.util.Date();
                                    d.setTime(rs.getTimestamp(i).getTime());
                                    cell.setCellValue(d);
                                } else {
                                    cell.setCellValue("" + rs.getString(i));
                                }
                               
                            }
                        }
                        else
                        {
                                //if (_rowbu<6)
                                        //System.out.println("_rownguyen= "+_rownguyen+" _rowbu= "+ _rowbu+" rowPos= "+rowPos);                                
                                HSSFRow  row = sheet.createRow((int) _rowbu);                                              
                           
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
                                    cell.setCellValue(rs.getDouble(i));
                                    //logger.info("DOUBLE - getDouble: "+rs.getDouble(i));                                                  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.DECIMAL) { //Thuong vo kieu nay
                                    //cell.setCellValue( rs.getDouble(i));
                            	   cell.setCellValue( rs.getString(i));
                                    //logger.info("[1]DECIMAL - getDouble: "+rs.getDouble(i));  
                                    //logger.info("[2]DECIMAL - getBigDecimal: "+rs.getBigDecimal(i));                              
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.FLOAT ){
                                   //cell.setCellValue(rs.getFloat(i));
                            	   cell.setCellValue( rs.getString(i));
                                   //logger.info("FLOAT - getFloat: "+rs.getFloat(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.NUMERIC ){
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("NUMERIC  - getLong: "+rs.getLong(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.INTEGER ){
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("INTEGER  - getLong: "+rs.getLong(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.SMALLINT ){
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("SMALLINT - getLong: "+rs.getLong(i));  
                               }
                               else if(rsmd.getColumnType(i) == java.sql.Types.BIGINT ){ //Thuong vo kieu nay
                                   cell.setCellValue(rs.getLong(i));
                                   //logger.info("[1]BIGINT - getLong: "+rs.getLong(i));  
                                   //logger.info("[2]BIGINT - getBigDecimal: "+rs.getBigDecimal(i));                                                      
                               }
                               else if ( rsmd.getColumnType(i) == java.sql.Types.TINYINT) {
                                    cell.setCellValue(rs.getLong(i));
                                    //logger.info(" TINYINT: "+rs.getLong(i));                                                        
                                } else if (rsmd.getColumnType(i) == java.sql.Types.DATE) {
                                    java.util.Date d = new java.util.Date();
                                    d.setTime(rs.getDate(i).getTime());
                                    cell.setCellValue(d);
                                } else if (rsmd.getColumnType(i) == java.sql.Types.TIMESTAMP) {
                                    java.util.Date d = new java.util.Date();
                                    d.setTime(rs.getTimestamp(i).getTime());
                                    cell.setCellValue(d);
                                } else {
                                    cell.setCellValue("" + rs.getString(i));
                                }
                            }
                        }
                    rowPos++;
                }
             
                //Bo ket noi file
                FileOutputStream outfile = new FileOutputStream(query.get_queryouturl());
                //book.write(new FileOutputStream(query.get_queryouturl()));
                book.write(outfile);
                outfile.close();
               
            } else {
                stmt.getUpdateCount();
            }            
           
            logger.info("> OK");
        } catch (Exception e) {
                logger.error(e.getMessage());
            e.printStackTrace();
            query.set_status("3");//Fail
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                    query.set_status("8");//OK
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                query.set_status("3");
            }
        }
    }
}
