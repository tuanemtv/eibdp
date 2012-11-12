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

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Logger;

public class FTPUtil {
	
	private static Logger logger =Logger.getLogger("FTPUtil");
	
	private String _ftpServer;
	private String _user;
	private String _password;
	private String _filename;
	private String _ftpurl;
	private String _inturl;
	private int _port = 21;
	
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
	
	
	 public void sendUpload() {
		 //String ftpServer="127.0.0.1";
		//String user="tuanemtv";
		//String password="123456";
		//String fileName="GG Tran\\CS - 01. Danh sach phong giao dich.xls";		
		//File source = new File("D:\\Query to Excel\\Result\\20120608\\CS - 01. Danh sach phong giao dich.xls");
		 
		File source = new File(this._inturl+this._filename);
		
		try {
			//upload(this._ftpServer,this._user,this._password,fileName,source);
			upload(this._ftpServer,this._user,this._password,this._ftpurl+this._filename,source);
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
	            //showServerReply(ftpClient);
	            
	            int replyCode = ftpClient.getReplyCode();
	            if (!FTPReply.isPositiveCompletion(replyCode)) {
	            	logger.error("Operation failed. Server reply code: " + replyCode);
	                return;
	            }
	            
	            boolean success = ftpClient.login(this._user, this._password);
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
}
