package org.eib.common;

import org.apache.log4j.Logger;

public class ArrayMailUtil {
	
	private static Logger logger =Logger.getLogger("ArrayMailUtil");
	
	private String _fileXMLUrl; //Duong dan cua file cron.xmlhyb 
	private MailUtil[] _mailUtil;
		
	public String get_fileXMLUrl() {
		return _fileXMLUrl;
	}


	public void set_fileXMLUrl(String _fileXMLUrl) {
		this._fileXMLUrl = _fileXMLUrl;
	}


	public MailUtil[] get_mailUtil() {
		return _mailUtil;
	}


	public void set_mailUtil(MailUtil[] _mailUtil) {
		this._mailUtil = _mailUtil;
	}


	public ArrayMailUtil(String _fileXMLUrl) {
		super();
		this._fileXMLUrl = _fileXMLUrl;
		
		MailUtil _mail = new MailUtil(_fileXMLUrl+"mail.xml");
		this._mailUtil = new MailUtil[_mail.get_cntArray()];		
		_mail.getXMLToMail(_fileXMLUrl+"mail.xml",this._mailUtil);												

	}
	
	public void log(){
		for (int i=0; i< _mailUtil.length; i++){
			logger.info("i: "+i);
			_mailUtil[i].log();
		}
	}
	
}
