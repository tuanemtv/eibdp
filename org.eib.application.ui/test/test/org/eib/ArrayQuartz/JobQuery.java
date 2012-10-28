package test.org.eib.ArrayQuartz;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eib.common.AppCommon;
import org.eib.common.QueryCron;
import org.eib.common.QueryServer;
import org.eib.database.Query;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.xml.sax.SAXException;

public class JobQuery implements Job{
	private static Logger logger =Logger.getLogger("JobQuery");
	private static AppCommon _app;
	private static QueryServer _queryser;
	private static Query _query;
	
	public AppCommon get_app() {
		return _app;
	}

	public void set_app(AppCommon _app) {
		this._app = _app;
	}

	public QueryServer get_queryser() {
		return _queryser;
	}

	public void set_queryser(QueryServer _queryser) {
		this._queryser = _queryser;
	}

	
	public void execute(JobExecutionContext context)
			throws JobExecutionException {
		
				logger.info("Query dfffff");
				
				//logger.info("getJobDetail= "+context.getJobDetail().getDescription());
				//DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss] dd/MM/yyyy");
				
				DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
				Date date = new Date();
				logger.info(dateFormat.format(date));
				
				//Tien hanh query
				this._query.set_querynm(dateFormat.format(date)+" - "+this._query.get_querynm());
				_query.queryToExcel(_app, _queryser);	
				
				/*
				File dir1 = new File(".");
				ResourceBundle rb = ResourceBundle.getBundle("app");
					
				
				try {
					logger.info("congifureUrl = "+ dir1.getCanonicalPath()+rb.getString("congifureUrl"));
				
					logger.info("scriptUrl = "+ dir1.getCanonicalPath()+rb.getString("scriptUrl"));
					
					Query qur = new Query(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"script.xml","Query");
					qur.logQuery();
					
					QueryCron qurcron = new QueryCron(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"cron.xml","Cron");
					qurcron.logQueryCron();
					
					_queryser =new QueryServer();
					_app = new AppCommon();	
					_app.set_scriptUrl(dir1.getCanonicalPath()+rb.getString("scriptUrl"));
					_app.set_logUrl(dir1.getCanonicalPath()+rb.getString("logtUrl"));
					
					
					_query = new Query[qur.get_countquery()];//Tong so query			
								
					_app.getAppCom(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"app.xml","Common1");
					_app.logAppCommon();
					
					_queryser.getServer(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"database.xml",_app.get_servernm());
					_queryser.logQueryServer();
					_queryser.connectDatabase();//Tien hanh connect
					
					
					qur.getXMLToScript(dir1.getCanonicalPath()+rb.getString("congifureUrl")+"script.xml", "Query", _query);			
					for (int i=0; i< _query.length; i++){
						System.out.println("["+i+"]");
						DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
						Date date = new Date();
						logger.info(dateFormat.format(date));
						
						//Tien hanh query
						this._query[i].set_querynm(dateFormat.format(date)+" - "+this._query[i].get_querynm());
						_query[i].queryToExcel(_app, _queryser);							
					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//this._query.set_querynm(dateFormat.format(date)+this._query.get_querynm());
				//this._query.queryToExcel(this._app, this._queryser);	
				catch (ParserConfigurationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SAXException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}*/
		 
			}
}
