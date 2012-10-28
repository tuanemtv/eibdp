package test.org.eib.io;

import java.io.File;
import java.util.ResourceBundle;

public class CurrentDir {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		 File dir1 = new File(".");
	        File dir2 = new File("..");
	        try {
	        	ResourceBundle rb = ResourceBundle.getBundle("app");
	        	
	            //System.out.println("Current dir : " + dir1.getCanonicalPath());
	            System.out.println("congifureUrl : " + dir1.getCanonicalPath()+rb.getString("congifureUrl"));
	            System.out.println("rb " + rb.getString("congifureUrl"));
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	}

}
