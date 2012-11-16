package org.eib.common;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eib.database.CommandQuery;
import org.eib.database.Query;
import org.quartz.CronScheduleBuilder;
import org.quartz.Job;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;
import org.xml.sax.SAXException;

import test.org.eib.ArrayQuartz.Job1;
import test.org.eib.ArrayQuartz.JobQuery;
import test.org.eib.sort.Person2;

public class MainCommon {
	
	private static Logger logger =Logger.getLogger("MainCommon");
	
	private AppCommon _appcommon;
	private QueryServer[] _queryser;
	private QueryCron[] _querycron;
	private Query[] _query;
				
	
	public QueryCron[] get_querycron() {
		return _querycron;
	}
	public void set_querycron(QueryCron[] _querycron) {
		this._querycron = _querycron;
	}
	public AppCommon get_appcommon() {
		return _appcommon;
	}
	public void set_appcommon(AppCommon _appcommon) {
		this._appcommon = _appcommon;
	}

	public QueryServer[] get_queryser() {
		return _queryser;
	}
	public void set_queryser(QueryServer[] _queryser) {
		this._queryser = _queryser;
	}
	public Query[] get_query() {
		return _query;
	}
	public void set_query(Query[] _query) {
		this._query = _query;
	}
	
	
	/**
	 * Lay mang query tu queryid
	 * @param _queID
	 * @return
	 */
	public Query[] getQueryFromQueryID(String [] _queID){
		Query[] qur = new Query[_queID.length];
		
		for (int j=0; j<_queID.length;j++){
			for (int i = 0; i< this._query.length;i++){
				if (_query[i].get_queryid().equals(_queID[j])){
					qur[j] = _query[i];
				}
			}
		}		
		return qur;
	}
	
	/**
	 * 
	 * @param _cronNM
	 * @param _queID
	 * @return
	 */
	public Query[] getQueryFromQueryID(String _cronNM, String [] _queID){
		Query[] qur = new Query[_queID.length];
		
		for (int j=0; j<_queID.length;j++){
			for (int i = 0; i< this._query.length;i++){
				if (_queID[j].equals(_cronNM+"."+_query[i].get_queryid())){
					qur[j] = _query[i];
				}
			}
		}		
		return qur;
	}
	
	/**
	 * 
	 */
	public void sortQueryWithPriority() {
	    int in, out;

	    for (out = 1; out < _query.length; out++) {
	      Query temp = _query[out]; // out is dividing line
	      in = out; // start shifting at out

	      while (in > 0 && // until smaller one found,
	    		  _query[in - 1].get_priority() > temp.get_priority()) {
	    	  _query[in] = _query[in - 1]; // shift item to the right
	        --in; // go left one position
	      }
	      _query[in] = temp; // insert marked item
	    }	    	    	  	 	    
	}
	
	/**
	 * Lay Query tu queryid
	 * @param _queryid
	 * @return
	 */
	public Query getQueryFromID(String _queryid){
		Query _que = new Query();
		
		for (int i = 0; i<this._query.length;i++){
			if (_query[i].get_queryid().equals(_queryid)){
				_que = _query[i];				
			}
		}			
		return _que; 		
	}
	
	
	/**
	 * Lay QueryCron tu _cronNM
	 * @param _cronNM
	 * @return
	 */
	public QueryCron getQueryCronFromName(String _cronNM){
		QueryCron _quec = new QueryCron();
		
		for (int i = 0; i<this._querycron.length;i++){
			if (_querycron[i].get_cronNM().equals(_cronNM)){
				_quec = _querycron[i];				
			}
		}			
		return _quec; 		
	}
	
	
	
	public String[] getQueryIDFromName(String _cronNM){
		int count=0;
		
		for (int i = 0; i<this._querycron[0].get_queryid().length;i++){
			if (_cronNM.equals(_querycron[0].get_queryid()[i].substring(0, 6))){
				count ++;
			}
		}			
		
		String [] _strQueryid = new String[count];
		
		int j=0;
		for (int i = 0; i<this._querycron[0].get_queryid().length;i++){
			if (_cronNM.equals(_querycron[0].get_queryid()[i].substring(0, 6))){
				_strQueryid[j] = _querycron[0].get_queryid()[i].substring(7);
				//System.out.println("j= "+j+" = "+_strQueryid[j]);
				j++;				
			}
		}
		
		return _strQueryid; 		
	}
	
	
	/**
	 * 
	 * @param _qurser
	 * @return
	 */
	public QueryServer getQueryServerFromID(String _qurser){
		QueryServer queryser = new QueryServer();
		
		for (int i = 0; i<this._queryser.length;i++){
			if (_queryser[i].get_id().equals(_qurser)){
				queryser = _queryser[i];				
			}
		}		
		//queryser.logQueryServer();
		return queryser;
	}
	
	
	//Khoi tao
	public MainCommon(String _proName){
		
		File dir1 = new File(".");
		//ResourceBundle rb = ResourceBundle.getBundle("app");
		ResourceBundle rb = ResourceBundle.getBundle(_proName);
		//ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
				
		try {
			//logger.info("congifureUrl = "+ dir1.getCanonicalPath()+rb.getString("congifureUrl"));
			//logger.info("scriptUrl = "+ dir1.getCanonicalPath()+rb.getString("scriptUrl"));
			
			_appcommon = new AppCommon();	
			_appcommon.set_configureurl(dir1.getCanonicalPath()+rb.getString("congifureUrl"));			
			_appcommon.getAppCom(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"app.xml",rb.getString("app_configure_common")); //Common1
			_appcommon.set_logUrl(dir1.getCanonicalPath()+rb.getString("logtUrl"));
			_appcommon.set_scriptUrl(dir1.getCanonicalPath()+rb.getString("scriptUrl"));
			
			QueryServer qurserver= new QueryServer(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"database.xml","Database");			
			Query qur = new Query(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"script.xml","Query");
			//qur.logQuery();			
			QueryCron qurcron = new QueryCron(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"cron.xml","Cron");
			//qurcron.logQueryCron();						
			
			_query = new Query[qur.get_countquery()];//Tong so query
			_querycron = new QueryCron[qurcron.get_countcron()];								
			_queryser =new QueryServer[qurserver.get_countdatabase()];			
			
			//_appcommon.logAppCommon();			
			//_queryser.getServer(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"database.xml",_appcommon.get_servernm());\
			//_queryser.logQueryServer();
			//_queryser.connectDatabase();//Tien hanh connect
			
			qurserver.getXMLToScript(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"database.xml", "Database", _queryser);
			qur.getXMLToScript(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"script.xml", "Query", _query);			
			qurcron.getXMLToCron(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"cron.xml","Cron",_querycron);
			
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
	
	/**
	 * 
	 * @param _proName
	 * @param _kind
	 * 0: Duong dan he thong, 1: Duong dan trong file cau hinh
	 */
	public MainCommon(String _proName, String _kind){
		
		String url="";		
		ResourceBundle rb = ResourceBundle.getBundle(_proName);
				
		_kind = rb.getString("app_kind");
		
		//ResourceBundle rb = ResourceBundle.getBundle("app");		
		//ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
				
		try {
			//logger.info("congifureUrl = "+ dir1.getCanonicalPath()+rb.getString("congifureUrl"));
			//logger.info("scriptUrl = "+ dir1.getCanonicalPath()+rb.getString("scriptUrl"));
			
			if (_kind.equals("0")){//Lay duong dan he thong
				File dir1 = new File(".");
				url = dir1.getCanonicalPath();
			}
			else{ //Lay duong dan file cau hinh
				url = rb.getString("app_configure_url");
			}
			
			_appcommon = new AppCommon();	
			_appcommon.set_configureurl(url+rb.getString("congifureUrl"));
			_appcommon.getAppCom(_appcommon.get_configureurl()+"app.xml",rb.getString("app_configure_common")); //Common1
			_appcommon.set_scriptUrl(url+rb.getString("scriptUrl"));
			_appcommon.set_logUrl(url+rb.getString("logtUrl"));
			
			//_appcommon.logAppCommon();			
			QueryServer qurserver= new QueryServer(_appcommon.get_configureurl()+"database.xml","Database");
			
			Query qur = new Query(_appcommon.get_configureurl()+"script.xml","Query");
			//qur.logQuery();
			
			QueryCron qurcron = new QueryCron(_appcommon.get_configureurl()+"cron.xml","Cron");
			//qurcron.logQueryCron();
						
			_query = new Query[qur.get_countquery()];//Tong so query
			_querycron = new QueryCron[qurcron.get_countcron()];								
			_queryser =new QueryServer[qurserver.get_countdatabase()];
			
			//queryser.getServer(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"database.xml",_appcommon.get_servernm());\
			//_queryser.logQueryServer();
			//_queryser.connectDatabase();//Tien hanh connect
			
			qurserver.getXMLToScript(_appcommon.get_configureurl()+"database.xml", "Database", _queryser);
			qur.getXMLToScript(url+rb.getString("congifureUrl")+"script.xml", "Query", _query);			
			qurcron.getXMLToCron(_appcommon.get_configureurl()+"cron.xml","Cron",_querycron);
			
			
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
	
	/**
	 * 
	 * @param _proName
	 * @param _kind
	 * @param _typeUrl
	 */
	public MainCommon(String _proName, String _kind, String _typeUrl){
		
		String url="";		
		ResourceBundle rb = ResourceBundle.getBundle(_proName);
				
		_kind = rb.getString("app_kind");
		
		//ResourceBundle rb = ResourceBundle.getBundle("app");		
		//ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
				
		try {
			//logger.info("congifureUrl = "+ dir1.getCanonicalPath()+rb.getString("congifureUrl"));
			//logger.info("scriptUrl = "+ dir1.getCanonicalPath()+rb.getString("scriptUrl"));
			
			if (_kind.equals("0")){//Lay duong dan he thong
				File dir1 = new File(".");
				url = dir1.getCanonicalPath();
			}
			else{ //Lay duong dan file cau hinh
				url = rb.getString("app_configure_url");
			}
			
			_appcommon = new AppCommon();
			
			if (_typeUrl.equals("cron"))
				_appcommon.set_configureurl(url+rb.getString("congifureCronUrl"));
			else if (_typeUrl.equals("all"))
				_appcommon.set_configureurl(url+rb.getString("congifureAllUrl"));
			else if (_typeUrl.equals("folder"))
				_appcommon.set_configureurl(url+rb.getString("congifureFileUrl"));
			else if (_typeUrl.equals("choice"))
				_appcommon.set_configureurl(url+rb.getString("congifureChoiceUrl"));
			else if (_typeUrl.equals("pc"))
				_appcommon.set_configureurl(url+rb.getString("congifurePCUrl"));
			
			
			_appcommon.getAppCom(_appcommon.get_configureurl()+"app.xml",rb.getString("app_configure_common")); //Common1
			_appcommon.set_scriptUrl(url+rb.getString("scriptUrl"));
			_appcommon.set_logUrl(url+rb.getString("logtUrl"));
			
			
			//_appcommon.logAppCommon();			
			QueryServer qurserver= new QueryServer(_appcommon.get_configureurl()+"database.xml","Database");
			
			Query qur = new Query(_appcommon.get_configureurl()+"script.xml","Query");
			//qur.logQuery();
			
			QueryCron qurcron = new QueryCron(_appcommon.get_configureurl()+"cron.xml","Cron");
			//qurcron.logQueryCron();
						
			_query = new Query[qur.get_countquery()];//Tong so query
			_querycron = new QueryCron[qurcron.get_countcron()];								
			_queryser =new QueryServer[qurserver.get_countdatabase()];
			
			//queryser.getServer(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"database.xml",_appcommon.get_servernm());\
			//_queryser.logQueryServer();
			//_queryser.connectDatabase();//Tien hanh connect
			
			qurserver.getXMLToScript(_appcommon.get_configureurl()+"database.xml", "Database", _queryser);
			qur.getXMLToScript(_appcommon.get_configureurl()+"script.xml", "Query", _query);	//url+rb.getString("congifureUrl")									
			qurcron.getXMLToCron(_appcommon.get_configureurl()+"cron.xml","Cron",_querycron);												
			
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
	
	public void logQuery(){
		for (int i = 0; i<_query.length;i++){
			logger.info("["+i+"]-------------------------------");
			_query[i].logQuery();
		}
	}
	
	
	public void logQueryServer(){
		for (int i = 0; i<_queryser.length;i++){
			logger.info("["+i+"]-------------------------------");
			_queryser[i].logQueryServer();
		}
	}
	
	
	public void logQueryCron(){
		for (int i = 0; i<_querycron.length;i++){
			logger.info("["+i+"]-------------------------------");
			_querycron[i].logQueryCron();
		}
	}
	
	
	/**
	 * 
	 */
	public void logQuerySumReport(){
		//lay thong tin 
		long _sumScript = 0;
		long _sumSuccess = 0;
		long _sumFail = 0;
		long _sumOther = 0;
		long _sumNo = 0;
		
		for (int i = 0; i<_query.length;i++){
			if (_query[i].get_module().equals("AA")){
				//Script define. ko lam gi
			}
			else{
				_sumScript++;
				if (_query[i].get_status().equals("8")){
					_sumSuccess++;
				}
				else if (_query[i].get_status().equals("3")){
					_sumFail++;
				}
				else if (_query[i].get_status().equals("0")){
					_sumNo++;
				}
				else{
					_sumOther ++;
				}					
			}
		}
		
		logger.info("|               |    Sum    | Thanh Cong |   Fail   | Chua chay |   Khac   |");
		logger.info("| Tong script   "+_sumScript+"   "+_sumSuccess+"   "+_sumFail+"   "+_sumNo+"   "+_sumOther);
	}
	
	/**
	 * 
	 * @param _module
	 */
	public void logQuerySumReport(String _module){
		//lay thong tin 
		long _sumScript = 0;
		long _sumSuccess = 0;
		long _sumFail = 0;
		long _sumOther = 0;
		long _sumNo = 0;
		
		for (int i = 0; i<_query.length;i++){
			if (_query[i].get_module().equals("AA")){
				//Script define. ko lam gi
			}
			else{
				if (_query[i].get_module().equals(_module)){
					_sumScript++;
					if (_query[i].get_status().equals("8")){
						_sumSuccess++;
					}
					else if (_query[i].get_status().equals("3")){
						_sumFail++;
					}
					else if (_query[i].get_status().equals("0")){
						_sumNo++;
					}
					else{
						_sumOther ++;
					}
				}
								
			}
		}
		
		logger.info("|               |    Sum    | Thanh Cong |   Fail   | Chua chay |   Khac   |");
		logger.info("|     "+_module+"        "+_sumScript+"   "+_sumSuccess+"   "+_sumFail+"   "+_sumNo+"   "+_sumOther);
	}
	
}
