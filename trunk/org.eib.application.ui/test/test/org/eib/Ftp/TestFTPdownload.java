package test.org.eib.Ftp;

import java.io.File;
import java.io.IOException;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.eib.common.AppCommon;
import org.eib.ftp.FTPdownload;
import org.xml.sax.SAXException;

public class TestFTPdownload {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		AppCommon _app;
		_app = new AppCommon();
		try {
			//ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
			//_app.getAppCom("D:\\Query to Excel\\Congifure\\app.xml", "Common2");
			_app.getAppCom("D:\\Query to Excel\\Congifure\\app.xml","Common2");
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return;	
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return;	
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return;	
		}
		
		
		//ResourceBundle rb = ResourceBundle.getBundle("configure");
		  //String server = rb.getString("server"); ;
	     // String user = rb.getString("user"); ;
	      //String pass = rb.getString("pass"); 
	      //String serverDir = rb.getString("serverDir");;
	     // String clientDir = rb.getString("clientDir");

	       FTPdownload upload = null;
		try {
			upload = new FTPdownload (_app.get_srcFTPServer(),_app.get_srcFTPUser(), _app.get_srcFTPPass());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	      // File f = new File(_app.get_srcFTPCliUrl());
	      // upload.copyFile(f,_app.get_srcFTPSerUrl());
		upload.showModifyFile(_app);
	       
	       
	}

}
