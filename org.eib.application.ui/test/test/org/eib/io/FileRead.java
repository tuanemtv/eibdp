package test.org.eib.io;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;

public class FileRead {

	/**
	 * @param args
	 */
	public static void main(String args[])
	  {
	  try{
	  // Open the file that is the first 
	  // command line parameter
	  //FileInputStream fstream = new FileInputStream("E:\\BACKUP\\DROPBOX\\Dropbox\\WORK\\Project\\script1.sql");
	  FileInputStream fstream = new FileInputStream("D:\\20090610_SVN Client\\Local Project\\Script\\060 - PRT - Sac he Eximbank.sql");
	  // Get the object of DataInputStream
	  DataInputStream in = new DataInputStream(fstream);
	  BufferedReader br = new BufferedReader(new InputStreamReader(in));
	  String strLine;
	  String strGet = "";
	  String strGet2 ="";
	  strGet2 = br.toString();
	  //Read File Line By Line
	  while ((strLine = br.readLine()) != null)   {
	  // Print the content on the console
		  strGet = strGet + strLine;
		  System.out.println (strLine);
	  }
	  //Close the input stream
	  in.close();
	  System.out.println ("strGet  "+strGet);
	  System.out.println ("strGet2  "+strGet2);
	  
	    }catch (Exception e){//Catch exception if any
	  System.err.println("Error: " + e.getMessage());
	  }
	  }

}
