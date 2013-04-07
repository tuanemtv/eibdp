package org.eib.common;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Logger;
import org.jasypt.util.text.BasicTextEncryptor;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class FTPUtil {
	
	private static Logger logger =Logger.getLogger("FTPUtil");
	private int _cntArray;
	private String _id;	
	private String _ftpServer;
	private String _user;
	private String _password;
	private String _filename;
	private String _ftpurl;
	private String _inturl;
	private int _port = 21;
	
		
	public int get_cntArray() {
		return _cntArray;
	}
	public void set_cntArray(int _cntArray) {
		this._cntArray = _cntArray;
	}
	
	public String get_id() {
		return _id;
	}
	public void set_id(String _id) {
		this._id = _id;
	}
	public int get_port() {
		return _port;
	}
	public void set_port(int _port) {
		this._port = _port;
	}
	public String get_ftpServer() {
		return _ftpServer;
	}
	public void set_ftpServer(String _ftpServer) {
		this._ftpServer = _ftpServer;
	}
	public String get_user() {
		return _user;
	}
	public void set_user(String _user) {
		this._user = _user;
	}
	public String get_password() {
		return _password;
	}
	public void set_password(String _password) {
		this._password = _password;
	}
	public String get_filename() {
		return _filename;
	}
	public void set_filename(String _filename) {
		this._filename = _filename;
	}
	public String get_ftpurl() {
		return _ftpurl;
	}
	public void set_ftpurl(String _ftpurl) {
		this._ftpurl = _ftpurl;
	}
	public String get_inturl() {
		return _inturl;
	}
	public void set_inturl(String _inturl) {
		this._inturl = _inturl;
	}
	
	public FTPUtil(){		
		super();
	}
	
	public FTPUtil(String _filepath) {	
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		try {
			docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.parse(_filepath);
			NodeList list = doc.getElementsByTagName("Ftp");
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
	
	 public void sendUpload() {
		 //String ftpServer="127.0.0.1";
		//String user="tuanemtv";
		//String password="123456";
		//String fileName="GG Tran\\CS - 01. Danh sach phong giao dich.xls";		
		//File source = new File("D:\\Query to Excel\\Result\\20120608\\CS - 01. Danh sach phong giao dich.xls");
		 
		File source = new File(this._inturl+this._filename);
		
		try {
			//upload(this._ftpServer,this._user,this._password,fileName,source);
			//Giai ma pass
			String _pass="";
			BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
			textEncryptor.setPassword("smilesunny");
			_pass =textEncryptor.decrypt(this._password);
			
			upload(this._ftpServer,this._user,_pass,this._ftpurl+this._filename,source);
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error(e.getMessage());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error(e.getMessage());
		}
	 }
	
	/**
	    * Upload a file to a FTP server. A FTP URL is generated with the
	    * following syntax:
	    * ftp://user:password@host:port/filePath;type=i.
	    *
	    * @param ftpServer , FTP server address (optional port ':portNumber').
	    * @param user , Optional user name to login.
	    * @param password , Optional password for user.
	    * @param fileName , Destination file name on FTP server (with optional
	    *            preceding relative path, e.g. "myDir/myFile.txt").
	    * @param source , Source file to upload.
	    * @throws MalformedURLException, IOException on error.
	    */
	   public static void upload( String ftpServer, String user, String password,
	         String fileName, File source ) throws MalformedURLException,
	         IOException
	   {
		
		   //Giai ma
			BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
			textEncryptor.setPassword("smilesunny");
			password =textEncryptor.decrypt(password);
			
	      if (ftpServer != null && fileName != null && source != null)
	      {
	         StringBuffer sb = new StringBuffer( "ftp://" );
	         // check for authentication else assume its anonymous access.
	         if (user != null && password != null)
	         {
	            sb.append( user );
	            sb.append( ':' );
	            sb.append( password );
	            sb.append( '@' );
	         }
	         sb.append( ftpServer );
	         sb.append( '/' );
	         sb.append( fileName );
	         /*
	          * type ==&gt; a=ASCII mode, i=image (binary) mode, d= file directory
	          * listing
	          */
	         sb.append( ";type=i" );
	 
	         BufferedInputStream bis = null;
	         BufferedOutputStream bos = null;
	         try
	         {
	            URL url = new URL( sb.toString() );
	            URLConnection urlc = url.openConnection();
	 
	            bos = new BufferedOutputStream( urlc.getOutputStream() );
	            bis = new BufferedInputStream( new FileInputStream( source ) );
	 
	            int i;
	            // read byte by byte until end of stream
	            while ((i = bis.read()) != -1)
	            {
	               bos.write( i );
	            }
	         }
	         finally
	         {
	            if (bis != null)
	               try
	               {
	                  bis.close();
	               }
	               catch (IOException ioe)
	               {
	                  ioe.printStackTrace();
	                  logger.error(ioe.getMessage());
	               }
	            if (bos != null)
	               try
	               {
	                  bos.close();
	               }
	               catch (IOException ioe)
	               {
	                  ioe.printStackTrace();
	                  logger.error(ioe.getMessage());
	               }
	         }
	         
	         logger.info("Upload =" +fileName+" is successfull");
	      }
	      else
	      {
	         //System.out.println( "Input not available." );
	         logger.info("Input not available.");
	      }
	   }
	 
	   /**
	    * Download a file from a FTP server. A FTP URL is generated with the
	    * following syntax:
	    * ftp://user:password@host:port/filePath;type=i.
	    *
	    * @param ftpServer , FTP server address (optional port ':portNumber').
	    * @param user , Optional user name to login.
	    * @param password , Optional password for user.
	    * @param fileName , Name of file to download (with optional preceeding
	    *            relative path, e.g. one/two/three.txt).
	    * @param destination , Destination file to save.
	    * @throws MalformedURLException, IOException on error.
	    */
	   public void download( String ftpServer, String user, String password,
	         String fileName, File destination ) throws MalformedURLException,
	         IOException
	   {
		   //Giai ma
			BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
			textEncryptor.setPassword("smilesunny");
			password =textEncryptor.decrypt(password);
			
	      if (ftpServer != null && fileName != null && destination != null)
	      {
	         StringBuffer sb = new StringBuffer( "ftp://" );
	         // check for authentication else assume its anonymous access.
	         if (user != null && password != null)
	         {
	            sb.append( user );
	            sb.append( ':' );
	            sb.append( password );
	            sb.append( '@' );
	         }
	         sb.append( ftpServer );
	         sb.append( '/' );
	         sb.append( fileName );
	         /*
	          * type ==&gt; a=ASCII mode, i=image (binary) mode, d= file directory
	          * listing
	          */
	         sb.append( ";type=i" );
	         BufferedInputStream bis = null;
	         BufferedOutputStream bos = null;
	         try
	         {
	            URL url = new URL( sb.toString() );
	            URLConnection urlc = url.openConnection();
	 
	            bis = new BufferedInputStream( urlc.getInputStream() );
	            bos = new BufferedOutputStream( new FileOutputStream(
	                  destination.getName() ) );
	 
	            int i;
	            while ((i = bis.read()) != -1)
	            {
	               bos.write( i );
	            }
	         }
	         finally
	         {
	            if (bis != null)
	               try
	               {
	                  bis.close();
	               }
	               catch (IOException ioe)
	               {
	                  ioe.printStackTrace();
	                  logger.error(ioe.getMessage());
	               }
	            if (bos != null)
	               try
	               {
	                  bos.close();
	               }
	               catch (IOException ioe)
	               {
	                  ioe.printStackTrace();
	                  logger.error(ioe.getMessage());
	               }
	         }
	      }
	      else
	      {
	         //System.out.println( "Input not available" );
	         logger.info("Input not available");
	      }
	   }
	   
	   
	   public void createFolder (String _folderUrl){		   
	        FTPClient ftpClient = new FTPClient();
	        try {
	        	
	            ftpClient.connect(this._ftpServer, this._port);
	        	//ftpClient.connect("10.1.71.51", 21);
	            //showServerReply(ftpClient);
	            
	            int replyCode = ftpClient.getReplyCode();
	            if (!FTPReply.isPositiveCompletion(replyCode)) {
	            	logger.error("Operation failed. Server reply code: " + replyCode);
	                return;
	            }
	            
	            //Giai nen
	            String _pass="";
	    		BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
	    		textEncryptor.setPassword("smilesunny");
	    		_pass =textEncryptor.decrypt(this._password);
	    		
	            boolean success = ftpClient.login(this._user, _pass);
	            //showServerReply(ftpClient);
	            if (!success) {
	            	logger.info("Could not login to the server");
	                return;
	            }
	            
	            // Creates a directory
	            String dirToCreate = _folderUrl;//   "/upload123";
	            success = ftpClient.makeDirectory(dirToCreate);
	            //showServerReply(ftpClient);
	            if (success) {
	            	logger.info("Successfully created directory: " + dirToCreate);
	            } else {
	            	logger.info("Failed to create directory. See server's reply.");
	            }
	            
	            // logs out
	            ftpClient.logout();
	            ftpClient.disconnect();
	            
	        } catch (IOException ex) {
	        	logger.error("Oops! Something wrong happened");
	            ex.printStackTrace();
	        }
	   }
	   
	   private static void showServerReply(FTPClient ftpClient) {
	        String[] replies = ftpClient.getReplyStrings();
	        if (replies != null && replies.length > 0) {
	            for (String aReply : replies) {
	            	logger.info("SERVER: " + aReply);
	            }
	        }
	    }
	   
	   public void log(){
			if (this.get_ftpServer() != null)
				logger.info("_ftpServer: "+this.get_ftpServer());
			if (this.get_user() != null)
				logger.info("_user: "+this.get_user());
			if (this.get_password() != null)
				logger.info("_password: "+this.get_password());
			if (this.get_filename() != null)
				logger.info("_filename: "+this.get_filename());
			if (this.get_ftpurl() != null)
				logger.info("_ftpurl: "+this.get_ftpurl());
			if (this.get_inturl() != null)
				logger.info("_inturl: "+this.get_inturl());			
	   }
	   
	   public void getXMLToFTP(String fileurl, FTPUtil _ftp[]) {
			File f = new File(fileurl);
			 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
			 DocumentBuilder db;
			try {
				db = dbf.newDocumentBuilder();
				 Document doc = db.parse(f);

				  //Element root = doc.getDocumentElement();		  
				  NodeList list = doc.getElementsByTagName("Ftp");
				  for (int i = 0; i < list.getLength(); i++) {
					  _ftp[i] = new FTPUtil();	
					  Node node = list.item(i);			  
					  if (node.getNodeType() == Node.ELEMENT_NODE) {
						 Element element = (Element) node;
						 
						 NodeList nodelist = element.getElementsByTagName("id");
						 Element element1 = (Element) nodelist.item(0);
						 NodeList fstNm = element1.getChildNodes();
						 _ftp[i].set_id((fstNm.item(0)).getNodeValue());
										 
						 nodelist = element.getElementsByTagName("ftpServer");
						 element1 = (Element) nodelist.item(0);
						 fstNm = element1.getChildNodes();					 
						 _ftp[i].set_ftpServer((fstNm.item(0)).getNodeValue());
						
						 //System.out.println("(fstNm.item(0)).getNodeValue() : " + (fstNm.item(0)).getNodeValue());
						 
						 nodelist = element.getElementsByTagName("user");
						 element1 = (Element) nodelist.item(0);
						 fstNm = element1.getChildNodes();
						 _ftp[i].set_user((fstNm.item(0)).getNodeValue());
						 //System.out.println("port : " + (fstNm.item(0)).getNodeValue());
						 
						 nodelist = element.getElementsByTagName("password");
						 element1 = (Element) nodelist.item(0);
						 fstNm = element1.getChildNodes();
						 _ftp[i].set_password((fstNm.item(0)).getNodeValue());
						 //System.out.println("host : " + (fstNm.item(0)).getNodeValue());					 				 				
						 
						 nodelist = element.getElementsByTagName("filename");
						 element1 = (Element) nodelist.item(0);
						 fstNm = element1.getChildNodes();
						 _ftp[i].set_filename((fstNm.item(0)).getNodeValue());
						 						
						 nodelist = element.getElementsByTagName("ftpurl");
						 element1 = (Element) nodelist.item(0);
						 fstNm = element1.getChildNodes();				
						 _ftp[i].set_ftpurl((fstNm.item(0)).getNodeValue());
						 
						 nodelist = element.getElementsByTagName("inturl");
						 element1 = (Element) nodelist.item(0);
						 fstNm = element1.getChildNodes();				
						 _ftp[i].set_inturl((fstNm.item(0)).getNodeValue());	
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
		
}
