package org.eib.common;

import org.apache.log4j.Logger;

public class MailUtil {
	private static Logger logger =Logger.getLogger("MailUtil");
	
	private String _smtpServer;
	private String _toMail;
	private String _passFrMail;
	private String _frMail; //Mat khau cua nguoi gui mail
	private String _subject; //Tieu de mail
	private String _ContMail; //Noi dung trong mail
	private String _bodyKind; //='0': Dang text, '1': Dang HTML
	private String _fileUrl; //Duong dan luu file
	private String _fileName; //Ten file co phan duoi
	public String get_smtpServer() {
		return _smtpServer;
	}
	public void set_smtpServer(String _smtpServer) {
		this._smtpServer = _smtpServer;
	}
	public String get_toMail() {
		return _toMail;
	}
	public void set_toMail(String _toMail) {
		this._toMail = _toMail;
	}
	public String get_passFrMail() {
		return _passFrMail;
	}
	public void set_passFrMail(String _passFrMail) {
		this._passFrMail = _passFrMail;
	}
	public String get_frMail() {
		return _frMail;
	}
	public void set_frMail(String _frMail) {
		this._frMail = _frMail;
	}
	public String get_subject() {
		return _subject;
	}
	public void set_subject(String _subject) {
		this._subject = _subject;
	}
	public String get_ContMail() {
		return _ContMail;
	}
	public void set_ContMail(String _ContMail) {
		this._ContMail = _ContMail;
	}
	public String get_bodyKind() {
		return _bodyKind;
	}
	public void set_bodyKind(String _bodyKind) {
		this._bodyKind = _bodyKind;
	}
	public String get_fileUrl() {
		return _fileUrl;
	}
	public void set_fileUrl(String _fileUrl) {
		this._fileUrl = _fileUrl;
	}
	public String get_fileName() {
		return _fileName;
	}
	public void set_fileName(String _fileName) {
		this._fileName = _fileName;
	}
	
	
	
	
}
