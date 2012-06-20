package test.org.eib.Ftp;

	 
	import org.apache.commons.net.ftp.FTPClient;
	import java.io.FileInputStream;
	import java.io.IOException;
	 
	public class FileUploadDemo {
	    public static void main(String[] args) {
	        FTPClient client = new FTPClient();
	        FileInputStream fis = null;
	 
	        try {
	            client.connect("127.0.0.1");
	            client.login("tuanemtv", "123456");
	 
	            //
	            // Create an InputStream of the file to be uploaded
	            //
	            String filename = "D:\\Query to Excel\\Log\\Querylog.log";
	            fis = new FileInputStream(filename);
	 
	            //
	            // Store file to server
	            //
	            client.storeFile(filename, fis);
	            client.logout();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            try {
	                if (fis != null) {
	                    fis.close();
	                }
	                client.disconnect();
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }
	    }
	}


