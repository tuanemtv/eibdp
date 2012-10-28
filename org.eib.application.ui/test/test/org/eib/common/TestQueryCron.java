package test.org.eib.common;

import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eib.application.dialog.AppMessageBox;
import org.eib.common.AppCommon;
import org.eib.common.QueryCron;
import org.eib.database.Query;
import org.xml.sax.SAXException;

public class TestQueryCron {
	
	private static Logger logger =Logger.getLogger("TellerView");
	private AppCommon _app;
	AppMessageBox _appMes;
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		QueryCron[] qur;//luc khoi dau lay duoc gia tri ko?
		QueryCron qur1 = new QueryCron();
		qur = new QueryCron[3];
		
		try {
			qur1.getXMLToCron("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\GG  Report to Excel\\Congifure\\test\\cron.xml", "Cron", qur); //_app.get_configureurl()+
			for (int i=0; i< qur.length; i++){
				//logger.info("["+(i+1)+"] queryid: " + _query[i].get_queryid()+", name: "+_query[i].get_querynm());
				//System.out.println("\n["+(i+1)+"] queryid : " + _query[i].get_queryid());
				//System.out.println("["+(i+1)+"] querynm : " + _query[i].get_querynm());
				//System.out.println("["+i+"] module : " + _query[i].get_module());
				//System.out.println("["+i+"] getquery : " + qur2[i].get_getquery());
				
				//qur[i].setquery();
				//logger.info("\n"+_query[i].get_exquery());
				
				//cboReport.add(_query[i].get_querynm(), i);
				//JavaUtil.showHashMap(_query[i].get_define());
				
				//System.out.println("["+i+"] exequery : " + _query[i].get_exquery());
				
				//Lay duong dan out file
				//_query[i].set_queryouturl(_app.get_outurl_excel(_query[i].get_querynm()));
				//System.out.println("["+i+"] out file : " + _query[i].get_queryouturl());						
				//System.out.println("["+i+"] status : " + _query[i].get_status());						
			}
			//System.out.println("> Load script Done. With= "+_query.length+" scripts");
		} catch (ParserConfigurationException e1) {
			// TODO Auto-generated catch block
		
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		} catch (SAXException e1) {
			// TODO Auto-generated catch block
			
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		}	
	}

}
