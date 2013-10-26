package org.eib.common;

import java.io.File;
import java.io.IOException;
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
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.jasypt.util.text.BasicTextEncryptor;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class MailUtil {
	
	
	private static Logger logger =Logger.getLogger("MailUtil");
	
	private String _id;	
	private String _smtpServer;
	private String _frMail; //Mat khau cua nguoi gui mail
	private String _passFrMail;
	private String[] _toMail;		
	private String _subject; //Tieu de mail
	private String _ContMail; //Noi dung trong mail
	private String _bodyKind; //='0': Dang text, '1': Dang HTML
	private String _fileUrl; //Duong dan luu file
	private String _fileName; //Ten file co phan duoi
	private String _keyPass;
	private int _cntArray;
		
	public int get_cntArray() {
		return _cntArray;
	}
	public void set_cntArray(int _cntArray) {
		this._cntArray = _cntArray;
	}
	
	public String get_keyPass() {
		return _keyPass;
	}
	public void set_keyPass(String _keyPass) {
		this._keyPass = _keyPass;
	}
	public String get_id() {
		return _id;
	}
	public void set_id(String _id) {
		this._id = _id;
	}

	public String get_smtpServer() {
		return _smtpServer;
	}
	public void set_smtpServer(String _smtpServer) {
		this._smtpServer = _smtpServer;
	}	
	public String[] get_toMail() {
		return _toMail;
	}
	public void set_toMail(String[] _toMail) {
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
		props.put("mail.smtp.host", this._smtpServer);
		props.put("mail.smtp.port", "587");
		props.put("mail.smtp.starttls.enable","true");
		final String login = this._frMail;//”nth001@gmail.com”;//usermail
		final String pwd;
		
		/*
		if ((this._keyPass == null) || (this._keyPass.trim().equals(""))){
			pwd = this._passFrMail;//”password cua ban o day”;
		}else{
			BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
			//textEncryptor.setPassword(this._keyPass);
			textEncryptor.setPassword("smilesunny");
			pwd = textEncryptor.decrypt(this._passFrMail);
			
			System.out.println(pwd);
			
		}*/
		
		BasicTextEncryptor textEncryptor = new BasicTextEncryptor();		
		textEncryptor.setPassword("smilesunny");
		pwd = textEncryptor.decrypt(this._passFrMail);
	
		
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
        /*
        msg.addRecipient(Message.RecipientType.TO,new InternetAddress(this._toMail));
        msg.addRecipient(Message.RecipientType.TO,new InternetAddress("tuanemtv.java@gmail.com"));
        msg.addRecipient(Message.RecipientType.TO,new InternetAddress("tuanemtv.web@gmail.com"));
        */
        if (this._toMail != null){
        	for (int i=0; i<this._toMail.length; i++){
        		msg.addRecipient(Message.RecipientType.TO,new InternetAddress(this._toMail[i]));
        	}
        }
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
        
        String filename = this._fileUrl + this._fileName;
        
        DataSource source = new FileDataSource(filename);
        messageBodyPart.setDataHandler(new DataHandler(source));
        
        messageBodyPart.setFileName(this._fileName);
        multipart.addBodyPart(messageBodyPart);

        // Send the complete message parts
        msg.setContent(multipart );        
				
		// — Send the message –
		Transport.send(msg);
		logger.info("Message sent OK.");
		//System.out.println("Message sent OK.");

	}
	
	public MailUtil() {
		super();
	}
	
	public MailUtil(String _filepath) {	
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		try {
			docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.parse(_filepath);
			NodeList list = doc.getElementsByTagName("Mail");
			this._cntArray = list.getLength();
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}	
	}
	
	public void getXMLToMail(String fileurl, MailUtil _mail[]) {
		File f = new File(fileurl);
		 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		 DocumentBuilder db;
		try {
			db = dbf.newDocumentBuilder();
			 Document doc = db.parse(f);

			  //Element root = doc.getDocumentElement();		  
			  NodeList list = doc.getElementsByTagName("Mail");
			  for (int i = 0; i < list.getLength(); i++) {
				  _mail[i] = new MailUtil();	
				  Node node = list.item(i);			  
				  if (node.getNodeType() == Node.ELEMENT_NODE) {
					 Element element = (Element) node;
					 
					 NodeList nodelist = element.getElementsByTagName("id");
					 Element element1 = (Element) nodelist.item(0);
					 NodeList fstNm = element1.getChildNodes();
					 _mail[i].set_id((fstNm.item(0)).getNodeValue());
									 
					 nodelist = element.getElementsByTagName("smtpServer");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();					 
					 _mail[i].set_smtpServer((fstNm.item(0)).getNodeValue());
					
					 //System.out.println("(fstNm.item(0)).getNodeValue() : " + (fstNm.item(0)).getNodeValue());
					 
					 nodelist = element.getElementsByTagName("frMail");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();
					 _mail[i].set_frMail((fstNm.item(0)).getNodeValue());
					 //System.out.println("port : " + (fstNm.item(0)).getNodeValue());
					 
					 nodelist = element.getElementsByTagName("passFrMail");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();
					 _mail[i].set_passFrMail((fstNm.item(0)).getNodeValue());
					 //System.out.println("host : " + (fstNm.item(0)).getNodeValue());					 				 				
					 
					 NodeList qlist = doc.getElementsByTagName("toMail");
					 _mail[i]._toMail = new String[qlist.getLength()];
					 for (int j = 0; j < qlist.getLength(); j++) {	
						 //_queryid[j] = new String();
						 if (node.getNodeType() == Node.ELEMENT_NODE) {
							Element qelement1 = (Element) qlist.item(j);
							NodeList qfstNm = qelement1.getChildNodes();							
							//System.out.println("ID : " +qelement1.getAttribute("id")+" Query : " + (qfstNm.item(0)).getNodeValue());
							_mail[i]._toMail[j] = (qfstNm.item(0)).getNodeValue();//(qelement1.getAttribute("id"));
						 }
					 }
					 
					 /*
					 nodelist = element.getElementsByTagName("toMail");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();				
					 _mail[i].set_toMail((fstNm.item(0)).getNodeValue());
					//System.out.println("database : " + (fstNm.item(0)).getNodeValue());
					 */					 				
					 
					 nodelist = element.getElementsByTagName("subject");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();				
					 _mail[i].set_subject((fstNm.item(0)).getNodeValue());
					 
					 nodelist = element.getElementsByTagName("contMail");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();				
					 _mail[i].set_ContMail((fstNm.item(0)).getNodeValue());
					 
					 nodelist = element.getElementsByTagName("bodyKind");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();				
					 _mail[i].set_bodyKind((fstNm.item(0)).getNodeValue());
					 
					 nodelist = element.getElementsByTagName("fileUrl");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();				
					 _mail[i].set_fileUrl((fstNm.item(0)).getNodeValue());
					 					 
					 nodelist = element.getElementsByTagName("fileName");
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();				
					 _mail[i].set_fileName((fstNm.item(0)).getNodeValue());
				  }
			  }	
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());	
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());	
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());	
			e.printStackTrace();
		}			
	}	
	
	public void log(){		
		if (this.get_id() != null)
			logger.info("id: "+this.get_id());
		if (this.get_smtpServer() != null)
			logger.info("_smtpServer: "+this.get_smtpServer());
		if (this.get_frMail() != null)
			logger.info("_frMail: "+this.get_frMail());
		if (this.get_passFrMail() != null)
			logger.info("_passFrMail: "+this.get_passFrMail());
		
		if (this.get_toMail() != null){
			for (int l=0; l<this.get_toMail().length; l++)
				logger.info("_toMail["+l+"]=" + this.get_toMail()[l]);
		}
		
		if (this.get_subject() != null)
			logger.info("_subject: "+this.get_subject());
		if (this.get_ContMail() != null)
			logger.info("_ContMail: "+this.get_ContMail());
		if (this.get_bodyKind() != null)
			logger.info("_bodyKind: "+this.get_bodyKind());
		if (this.get_fileUrl() != null)
			logger.info("_fileUrl: "+this.get_fileUrl());
		if (this.get_fileName() != null)
			logger.info("filename: "+this.get_fileName());
	}
}
