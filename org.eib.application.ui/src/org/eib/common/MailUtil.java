package org.eib.common;

import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

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
	
	
	public void sendMail() throws Exception
	{
		// java.security.Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
		Properties props = System.getProperties();
		// –
		props.put("mail.smtp.host", this._smtpServer);
		props.put("mail.smtp.port", "587");
		props.put("mail.smtp.starttls.enable","true");
		final String login = this._frMail;//”nth001@gmail.com”;//usermail
		final String pwd = this._passFrMail;//”password cua ban o day”;
		
		Authenticator pa = null; //default: no authentication
			
		if (login != null && pwd != null) { //authentication required?
			props.put("mail.smtp.auth", "true");
			pa = new Authenticator (){
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(login, pwd);
				}
			};
		}//else: no authentication
		
		Session session = Session.getInstance(props, pa);
		/*
		// — Create a new message –
		Message msg = new MimeMessage(session);
		// — Set the FROM and TO fields –
		msg.setFrom(new InternetAddress(from));
		msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
		// — Set the subject and body text –
		msg.setSubject(subject);
		
		//Neu muon dinh dang thi dung cai nay. Bo setText
		//msg.setContent("<h1>This is actual message</h1>","text/html" );		
		msg.setText(body);
		
		// — Set some other header information –
		msg.setHeader("X-Mailer", "LOTONtechEmail");
		msg.setSentDate(new Date());
		msg.saveChanges();
		
		*/
		
		 // Create a default MimeMessage object.
        MimeMessage msg = new MimeMessage(session);

        // Set From: header field of the header.
        msg.setFrom(new InternetAddress(this._frMail));

        // Set To: header field of the header.
        msg.addRecipient(Message.RecipientType.TO,new InternetAddress(this._toMail));

        // Set Subject: header field
        msg.setSubject(this._subject);

        // Create the message part 
        BodyPart messageBodyPart = new MimeBodyPart();

        // Fill the message
        if (this._bodyKind.equals("0")){ //text
        	messageBodyPart.setText(this._ContMail);
        }else{
        	messageBodyPart.setContent(this._ContMail,"text/html");
        }
        //   
        
        // Create a multipar message
        Multipart multipart = new MimeMultipart();

        // Set text message part
        multipart.addBodyPart(messageBodyPart);

        // Part two is attachment
        messageBodyPart = new MimeBodyPart();
        
        String filename = this._fileUrl;
        
        DataSource source = new FileDataSource(filename);
        messageBodyPart.setDataHandler(new DataHandler(source));
        
        messageBodyPart.setFileName(this._fileName);
        multipart.addBodyPart(messageBodyPart);

        // Send the complete message parts
        msg.setContent(multipart );        
				
		// — Send the message –
		Transport.send(msg);
		//logger.info("Message sent OK.");
		//System.out.println("Message sent OK.");

	}
	public MailUtil() {
		super();
	}
	
}
