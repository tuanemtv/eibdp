package test.org.eib.Ftp;

import java.io.IOException;
import java.net.SocketException;
import java.util.Date;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;

public class TestLastModified {

	/**
	 * @param args
	 */
	 public static void main(String[] args) {  
	        FTPClient client = new FTPClient();  
	        try {  
	            client.connect("127.0.0.1");  
	            client.login("tuanemtv", "123456");  
	            client.setTcpNoDelay(true);  
	            client.changeWorkingDirectory("/dp/src/dpsa");  
	            // client.enterLocalPassiveMode();  
	            client.setFileType(FTPClient.BINARY_FILE_TYPE);  
	            System.out.println(client.getPassivePort()); 
	            
	            FTPFile[] files = client.listFiles();  
	            
	            FTPFile lastFile = lastFileModified(files);  
	            System.out.println(lastFile.getName());  
	            client.logout();  
	            client.disconnect();  
	        } catch (SocketException e) {  
	            // TODO Auto-generated catch block  
	            e.printStackTrace();  
	        } catch (IOException e) {  
	            // TODO Auto-generated catch block  
	            e.printStackTrace();  
	        }  
	  
	    }  
	  
	    public static FTPFile lastFileModified(FTPFile[] files) {  
	        Date lastMod = files[0].getTimestamp().getTime();  
	        FTPFile choice = files[0];  
	        for (FTPFile file : files) {  
	            if (file.getTimestamp().getTime().after(lastMod)) {  
	            	System.out.println("lastMod: "+lastMod);
	                choice = file;  
	                lastMod = file.getTimestamp().getTime();  
	            }  
	        }  
	        return choice;  
	    } 
	    
	    
}
