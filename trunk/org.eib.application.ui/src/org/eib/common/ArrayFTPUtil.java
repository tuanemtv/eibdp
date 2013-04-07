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
		
		FTPUtil _ftp = new FTPUtil(_fileXMLUrl+"ftp.xml");
		this._ftpUtil = new FTPUtil[_ftp.get_cntArray()];		
		_ftp.getXMLToFTP(_fileXMLUrl+"ftp.xml",this._ftpUtil);											

	}
	
	/**
	 * 
	 * @param _ftpID
	 * @return
	 */
	public FTPUtil getFTPFromID(String _ftpID){
		FTPUtil _ftp = new FTPUtil();
		
		for (int i = 0; i<this._ftpUtil.length;i++){
			if (_ftpUtil[i].get_id().equals(_ftpID)){
				_ftp = _ftpUtil[i];				
			}
		}		
		//queryser.logQueryServer();
		return _ftp;
	}
	
	
	public void log(){
		for (int i=0; i< _ftpUtil.length; i++){
			logger.info("i: "+i);
			_ftpUtil[i].log();
		}
	}
	
}
