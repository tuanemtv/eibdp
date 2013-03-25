package org.eib.common;

import org.apache.log4j.Logger;

public class ArrayFTPUtil {
	
	private static Logger logger =Logger.getLogger("ArrayFTPUtil");
	
	private String _fileXMLUrl; //Duong dan cua file cron.xmlhyb 
	private FTPUtil[] _ftpUtil;
	
		
	public String get_fileXMLUrl() {
		return _fileXMLUrl;
	}

	public void set_fileXMLUrl(String _fileXMLUrl) {
		this._fileXMLUrl = _fileXMLUrl;
	}

	public FTPUtil[] get_ftpUtil() {
		return _ftpUtil;
	}

	public void set_ftpUtil(FTPUtil[] _ftpUtil) {
		this._ftpUtil = _ftpUtil;
	}

	public ArrayFTPUtil(String _fileXMLUrl) {
		super();
		this._fileXMLUrl = _fileXMLUrl;
		
		QueryCron qurcron = new QueryCron(_fileXMLUrl+"cron.xml","Cron");
		//this._querycron = new QueryCron[qurcron.get_countcron()];		
		//qurcron.getXMLToCron(_fileXMLUrl+"cron.xml","Cron",this._querycron);												

	}
}
