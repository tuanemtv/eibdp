package org.eib.common;

import org.apache.log4j.Logger;

public class ArrayCronUtil {
	
	private static Logger logger =Logger.getLogger("ArrayCronUtil");
	
	private String _fileXMLUrl; //Duong dan cua file cron.xml
	private QueryCron[] _querycron;
	
	public String get_fileXMLUrl() {		
		return _fileXMLUrl;
	}

	public void set_fileXMLUrl(String _fileXMLUrl) {
		this._fileXMLUrl = _fileXMLUrl;
	}

	public QueryCron[] get_querycron() {
		return _querycron;
	}

	public void set_querycron(QueryCron[] _querycron) {
		this._querycron = _querycron;
	}
	
	public ArrayCronUtil(String _fileXMLUrl) {
		super();
		this._fileXMLUrl = _fileXMLUrl;
		
		QueryCron qurcron = new QueryCron(_fileXMLUrl+"cron.xml","Cron");
		this._querycron = new QueryCron[qurcron.get_countcron()];		
		qurcron.getXMLToCron(_fileXMLUrl+"cron.xml","Cron",this._querycron);												
	}
			
	public void log(){
		for (int i=0; i< _querycron.length; i++){
			logger.info("i: "+i);
			_querycron[i].logQueryCron();
		}
	}
	
}
