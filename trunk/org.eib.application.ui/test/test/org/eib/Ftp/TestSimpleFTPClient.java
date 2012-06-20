package test.org.eib.Ftp;

public class TestSimpleFTPClient {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		SimpleFTPClient f= new SimpleFTPClient ();
		  f.setHost("127.0.0.1");
		  f.setUser("tuanemtv");
		  f.setPassword("123456");
		  boolean connected=f.connect(); 
		  
		  f.setRemoteFile("public_html/u.txt");
		  if ( connected){
		    // Upload a file from your local drive, lets say in “c:/ftpul/u.txt”
		    if (f.uploadFile("D:/Query to Excel/Result/20120608.zip"))
		      // display the message of success if uploaded
		    System.out.println(f.getLastSuccessMessage ());
		    else
		      System.out.println(f.getLastErrorMessage ());
		    }
		    else
		    // Display any connection exception, if any
		      System.out.println(f.getLastErrorMessage ()); 
	}

}
