package org.eib.database;

import java.sql.*;
import java.util.ResourceBundle;

/**
 *
 * @author juriel
 */
public class JDBCSqlConsole {

    public final static int CMD_QUERY = 1;
    public final static int CMD_EXPORT_CSV = 2;
    public final static int CMD_EXPORT_EXCEL = 3;
    public final static int CMD_GENERATE_CREATE_TABLE = 4;
    public final static int CMD_GENERATE_CREATE_CLASS = 5;
    
    
    public static final String DRIVER_MYSQL = "com.mysql.jdbc.Driver";
    public static final String DRIVER_ORACLE = "oracle.jdbc.driver.OracleDriver";
    public static final String DRIVER_POSTGRESQL = "org.postgresql.Driver";
    public static final String DRIVER_SQLSERVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    
    private static int CMD = -1;

    private static String host = null;
    private static int port = -1;
    private static String database = null;
    private static String driver = null;
    private static String url = null;
    private static String user = null;
    private static String password = null;
    private static String separator = "\t";
    private static String query = null;
    private static String filename = null;
    private static boolean showHeaders = true;
    private static boolean showMetaData = false;
    private static boolean showSummary = false;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
       /* if (args.length == 0) {
            usage();
            return;
        }*/
        parseArgs(args);

        if (query == null || query.trim().length() == 0) {
            System.out.println("NO QUERY."+query);
            return;
        }

        if (url == null) {        	
            url = JDBCURLHelper.generateURL(driver, host, port, database);
            System.out.println("url = "+url);
        }

        try {
            Class.forName(driver);
        } catch (Exception e) {
            System.out.println("Unable to load driver " + driver);
            System.out.println("ERROR " + e.getMessage());
            return;
        }
        java.sql.Connection conn = null;
        try {        	
            conn = DriverManager.getConnection(url, user, password);
        } catch (SQLException ex) {
            System.out.println("Unable to create connection " + url);
            System.out.println("ERROR " + ex.getMessage());
            return;
        }
        if (CMD == -1) {
            CMD = CMD_QUERY;
        }
        if (CMD == CMD_QUERY) {
            CommandQuery.commandQuery(conn,query,showHeaders, separator, showMetaData);
        } else if (CMD == CMD_GENERATE_CREATE_TABLE) {
            CommandCreateTable.commandCreateTable(conn,query);
        }
        else if (CMD == CMD_GENERATE_CREATE_CLASS) {
            CommandCreateClass.commandCreateClass(conn, query);
        }
        else if (CMD == CMD_EXPORT_EXCEL){
        	CommandQuery.commandQueryExcel(conn, query,showHeaders,showMetaData, filename);
        	
        }
        try {
        	System.out.println("Da dong ket noi");
            conn.close();
        } catch (SQLException ex) {
        }
    }

    public static void parseArgs(String[] args) throws NumberFormatException {
        int size = args.length - 1;
        int count_cmds = 0;
        int ii;
        for (ii = 0; ii < size; ii++) {
            String str = args[ii];
            if (str.equals("-url")) {
                ii++;
                url = args[ii];
            }
            else if (str.equals("-oracle")) {
                driver = DRIVER_ORACLE;
            }
            else if (str.equals("-mysql")) {
                driver = DRIVER_MYSQL;
            }
            else if (str.equals("-sqlserver")) {
                driver = DRIVER_SQLSERVER;
            }
            else if (str.equals("-postgresql")) {
                driver = DRIVER_POSTGRESQL;
            } else if (str.equals("-host")) {
                ii++;
                host = args[ii];
            } else if (str.equals("-port")) {
                ii++;
                port = Integer.parseInt(args[ii]);
            } else if (str.equals("-database") || str.equals("-sid")) {
                ii++;
                database = args[ii];
            } else if (str.equals("-driver")) {
                ii++;
                driver = args[ii];
            } else if (str.equals("-user")) {
                ii++;
                user = args[ii];
            } else if (str.equals("-password")) {
                ii++;
                password = args[ii];
            } else if (str.equals("-separator")) {
                ii++;
                separator = args[ii];
            } else if (str.equals("-hide-headers")) {

                showHeaders = false;
            } else if (str.equals("-show-metadata")) {

                showMetaData = true;

            } else if (str.equals("-query")) {
                CMD = CMD_QUERY;
                count_cmds++;
            } else if (str.equals("-export-to-cvs")) {
                CMD = CMD_EXPORT_CSV;
                count_cmds++;
            } else if (str.equals("-export-to-excel")) {
                CMD = CMD_EXPORT_EXCEL;
                count_cmds++;
            } else if (str.equals("-generate-create-table")) {
                CMD = CMD_GENERATE_CREATE_TABLE;
                count_cmds++;
            }
            else if (str.equals("-generate-create-class")) {
                CMD = CMD_GENERATE_CREATE_CLASS;
                count_cmds++;
            }
            else if (str.equals("-filename")) {
                ii++;
                filename = args[ii];
            } 
            else {
                return;
            }
        }
        if (ii == args.length - 1) {
            query = args[ii];
        }
        
        ResourceBundle rb = ResourceBundle.getBundle("database");		
        driver = rb.getString("driver");   
        System.out.println("driver="+driver);
        host = rb.getString("host");
        port = Integer.valueOf(rb.getString("port"));
        database = rb.getString("database"); 
        user = rb.getString("user"); 
        password = rb.getString("password");
        query = rb.getString("query"); 
        CMD = Integer.valueOf(rb.getString("CMD")); 
        filename = rb.getString("filename"); 
       
        //driver = DRIVER_MYSQL;
        //host = "127.0.0.1";
        //port = 3306;
        //database="athena";
        //user ="root";
        //password = "";
        //query = "SELECT * FROM athena.daily_stocks_transaction order by IDStockTransaction";
        //CMD = 3;
        //filename = "D:\\a.xls";
    }

    private static void usage() {

        System.out.println("Main commands:");
        System.out.println("-query             Execute query (this is the default command)");
        System.out.println("-export-to-cvs     Generate text file");
        System.out.println("-export-to-excel   Generate Microsoft Excel File");
        System.out.println("-generate-create-table   Generate create table");
        System.out.println("-generate-create-class    Generate java class");
        System.out.println();
        System.out.println("JDBC Drivers:");
        System.out.println("-driver     JDBC driver i.e: com.mysql.jdbc.Driver");
        System.out.println("-oracle     to use Oracle driver");
        System.out.println("-mysql      to use mysql driver");
        System.out.println("-sqlserver  to use Microsoft SQLServer driver");
        System.out.println("-postgresql to use Postgresql driver");
        System.out.println();
        System.out.println("URL:");
        System.out.println("-url       JDBC Url");
        System.out.println("-host       server host if not url ");
        System.out.println("-port       server port (optional) if not url");
        System.out.println("-database   database if not url");
        System.out.println("-sid        SID if not url");
        System.out.println();
        System.out.println("Authentication:");
        System.out.println("-user       user to connnect to database");
        System.out.println("-password   password to connnect to database");
        System.out.println();
        System.out.println("Options:");
        System.out.println("-separator  column separator for output (text file o stdout");
        System.out.println("-hide-headers  hide headers on text output");
        System.out.println("-show-metadata show additional row with metadata");
        System.out.println("-filename name of file");
    }
    
}