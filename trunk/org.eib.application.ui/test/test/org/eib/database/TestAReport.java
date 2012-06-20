package test.org.eib.database;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.TreeMap;

import javax.xml.parsers.ParserConfigurationException;

import org.eib.common.AppCommon;
import org.eib.common.QueryServer;
import org.eib.database.CommandQuery;
import org.eib.database.JDBCURLHelper;
import org.eib.database.Query;
import org.eib.thread.RunMulScript;
import org.xml.sax.SAXException;

public class TestAReport {

	/**
	 * @param args
	 * @throws IOException 
	 * @throws SAXException 
	 * @throws ParserConfigurationException 
	 */
	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException {
		// TODO Auto-generated method stub
		QueryServer queryser =new QueryServer();
		queryser.getServer("D:\\20090610_SVN Client\\Local Project\\database.xml","Oralce-AReport");
		
		System.out.println("getDriver : " + queryser.getDriver());
		System.out.println("getDatabase : " + queryser.getDatabase());
		System.out.println("getHost : " + queryser.getHost());
		System.out.println("getPassword : " + queryser.getPassword());
		System.out.println("getPort : " + queryser.getPort());
		
		AppCommon app = new AppCommon();
		app.getAppCom("D:\\20090610_SVN Client\\Local Project\\app.xml", "Common1");
		
		//queryser.setFilename("D:\\ba.xls");
		//queryser.se
        //query = rb.getString("query"); 
        //CMD = Integer.valueOf(rb.getString("CMD"));
		
		//queryser.setQuery(query)
		/*
		Query script1 = new Query();
		
		script1.set_queryid("a");
		script1.set_module("DP");
		script1.set_queryid("script1");
		script1.set_querynm("Test 1");
		script1.set_getquery("select * from athena.daily_stocks_transaction where idstock= h_idstock");
		HashMap<String, String> a1 = new HashMap<String, String>();
		a1.put("h_idstock", "'111'");
		script1.set_define(a1);
		script1.setquery();//map
		
		
		Query[] script = new Query[10]; //new Query[10];
		
		script[0] = new Query();
		script[0].set_module("DP");
		script[0].set_queryid("script1");
		script[0].set_querynm("Tran van tuan em");
		script[0].set_getquery("select * from athena.daily_stocks_transaction where idstock= h_idstock");
		HashMap<String, String> a3 = new HashMap<String, String>();
		a3.put("h_idstock", "'111'");
		script[0].set_define(a3);
		script[0].setquery();//map
		
		
		script[1] = new Query();
		script[1].set_queryid("b");
		script[1].set_module("DP");
		script[1].set_queryid("script2");
		script[1].set_querynm("Ta la ai");
		script[1].set_getquery("select * from athena.daily_stocks_transaction where idstock= h_idstock");
		HashMap<String, String> a2 = new HashMap<String, String>();
		a2.put("h_idstock", "'100'");
		script[1].set_define(a2);
		script[1].setquery();//map
		*/
		
		//Lay script dang ky
		Query qur = new Query();
		Query[] qur2 = new Query[3];
		qur.getXMLToScript("D:\\20090610_SVN Client\\Local Project\\script.xml", "Query", qur2);
		for (int i=0; i< qur2.length; i++){
			System.out.println("\n["+i+"] queryid : " + qur2[i].get_queryid());
			System.out.println("["+i+"] querynm : " + qur2[i].get_querynm());
			System.out.println("["+i+"] module : " + qur2[i].get_module());
			//System.out.println("["+i+"] getquery : " + qur2[i].get_getquery());
			qur2[i].setquery();
			
			
			TreeMap<String, String> hm_temp = new TreeMap<String, String>();
			hm_temp =qur2[i].get_define();
			Set<Entry<String, String>> set = hm_temp.entrySet();
			// Get an iterator
			Iterator<Entry<String, String>> j = set.iterator();
			while(j.hasNext()) {
				Map.Entry me = j.next();
				System.out.print(me.getKey() + ": ");
				System.out.println(me.getValue());
			}
			
			System.out.println("["+i+"] exequery : " + qur2[i].get_exquery());
			
			//Lay duong dan out file
			qur2[i].set_queryouturl(app.get_outurl_excel(qur2[i].get_querynm()));
			System.out.println("["+i+"] out file : " + qur2[i].get_queryouturl());
			
			System.out.println("["+i+"] status : " + qur2[i].get_status());						
		}
		
		//System.out.println("url = "+queryser.getUrl());
		//Lay duong dan
		queryser.setUrl(JDBCURLHelper.generateURL(queryser.getDriver(), queryser.getHost(), queryser.getPort(), queryser.getDatabase()));
        //System.out.println("url = "+queryser.getUrl());
		
		try {
            Class.forName(queryser.getDriver());
        } catch (Exception e) {
            System.out.println("Unable to load driver " + queryser.getDriver());
            System.out.println("ERROR " + e.getMessage());
            return;
        }
        java.sql.Connection conn = null;
        try {        	
            conn = DriverManager.getConnection(queryser.getUrl(), queryser.getUser(), queryser.getPassword());
            //conn = DriverManager.getConnection(url, user, password);
        } catch (SQLException ex) {
            //System.out.println("Unable to create connection " + url);
            System.out.println("ERROR " + ex.getMessage());
            return;
        }
        //CommandQuery.commandQueryExcel(conn, query,showHeaders,showMetaData, filename);
        
        CommandQuery.set_Excelrow(app.get_excelrows());//Set so dong cua excel
        /*
        int k=0;
        while (k < qur2.length)
        {        	
        	if (app.get_scriptnums() == 1){//Chay 1 script
        		CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        		k++;
        	}
        	else if (app.get_scriptnums() == 2){//Chay 2 script
        		System.out.println("Chay 2 script.");
        		if ((qur2.length - k) > 1){//Du 2 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			k = k+2;
        		}
        		else{
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			k++;
        		}
        	}
        	else if (app.get_scriptnums() == 3){
        		if ((qur2.length - k) > 2){//Du 3 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+2].get_exquery(),true,false, app.get_outurl_excel(qur2[k+2].get_querynm()));
        			k = k+3;
        		}
        		else if ((qur2.length - k) > 1){//Du 2 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			k = k+2;
        		}
        		else{
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			k++;
        		}
        	}
        	else if (app.get_scriptnums() == 4){
        		if ((qur2.length - k) > 3){//Du 4 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+2].get_exquery(),true,false, app.get_outurl_excel(qur2[k+2].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+3].get_exquery(),true,false, app.get_outurl_excel(qur2[k+3].get_querynm()));
        			k = k+4;
        		}
        		else if ((qur2.length - k) > 2){//Du 3 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+2].get_exquery(),true,false, app.get_outurl_excel(qur2[k+2].get_querynm()));
        			k = k+3;
        		}
        		else if ((qur2.length - k) > 1){//Du 2 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			k = k+2;
        		}
        		else{
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			k++;
        		}
        		
        	}
        	else if (app.get_scriptnums() == 5){
        		if ((qur2.length - k) > 4){//Du 5 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+2].get_exquery(),true,false, app.get_outurl_excel(qur2[k+2].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+3].get_exquery(),true,false, app.get_outurl_excel(qur2[k+3].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+4].get_exquery(),true,false, app.get_outurl_excel(qur2[k+4].get_querynm()));
        			k = k+5;
        		}
        		else if ((qur2.length - k) > 3){//Du 4 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+2].get_exquery(),true,false, app.get_outurl_excel(qur2[k+2].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+3].get_exquery(),true,false, app.get_outurl_excel(qur2[k+3].get_querynm()));
        			k = k+4;
        		}
        		else if ((qur2.length - k) > 2){//Du 3 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+2].get_exquery(),true,false, app.get_outurl_excel(qur2[k+2].get_querynm()));
        			k = k+3;
        		}
        		else if ((qur2.length - k) > 1){//Du 2 script
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			CommandQuery.commandQueryExcel(conn, qur2[k+1].get_exquery(),true,false, app.get_outurl_excel(qur2[k+1].get_querynm()));
        			k = k+2;
        		}
        		else{
        			CommandQuery.commandQueryExcel(conn, qur2[k].get_exquery(),true,false, app.get_outurl_excel(qur2[k].get_querynm()));
        			k++;
        		}
        	        	
        	}        	
		}*/
        System.out.println("\n\nRun....................");
        //CommandQuery.commandQueryExcel(conn, qur2[0].get_exquery(),true,false, app.get_outurl_excel(qur2[0].get_querynm()));
        
        //Run multi
        RunMulScript.commandMulQueryExcel(conn,qur2,app);
        
        try {
        	//System.out.println("Da dong ket noi");
            conn.close();
        } catch (SQLException ex) {
        }
        
	}
}
