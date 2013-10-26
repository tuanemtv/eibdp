package test.org.eib.io;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

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
	  //FileInputStream fstream = new FileInputStream("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\GG  Report to Excel\\Script\\MySQL\\testNumber.sql");
	  FileInputStream fstream = new FileInputStream("D:\\TEST\\test\\monitor_20131024_28");
		  
	  // Get the object of DataInputStream
	  
	  /*
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
	  */
	  //FileInputStream fstream;
		try {			
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
			List<String> lines = new ArrayList<String>();
			
			while ((strLine = br.readLine()) != null)   {	
				//Neu bat dau bang select thi moi them vao.
				//this.set_getquery(this.get_getquery() + strLine+'\n');//Cong them 1 khoang trang de cau script dung	  
				 //System.out.println (strLine);
				 if (strLine.length()>10){					 
					 String temp="";
					 temp = strLine.substring(0, 1);
					 
					 /*if (temp.equals(">")){
						 System.out.println (strLine);
					 }*/
							 
					 
					 if (temp.equals(">") || temp.equals("P") || temp.equals("	") || 
					     temp.equals("-") || temp.equals("T") || temp.equals("�") ||
					     temp.equals("F")){
						 
					 }else{
						 
						 //System.out.println (strLine);
						 String [] strTemp = strLine.split(" ", 0);
						 String serviceNm = "";
						 for (int i =0 ; i< strTemp.length; i++){
							 if (i ==0 ){
								//System.out.println (strTemp[i]);
							 	serviceNm=strTemp[i];
							 }
							 else if (i == strTemp.length - 1 ){
								 if (strTemp[i].equals(")")){ //Vi RESTARTING
									System.out.println (strTemp[i-3]);
									serviceNm = serviceNm + ";" +strTemp[i-3];
								 }else
									 serviceNm = serviceNm + ";" +strTemp[i];
							 }
						 }
						 lines.add(serviceNm);
						 //System.out.println ("---->"+serviceNm);
						 //System.out.println ("--->" + temp);
					 }
					 
				 }				 	
			}	
			
			/*
			String a[] = lines.toArray(new String[lines.size()]);
			for (int j =0; j<a.length; j++){
				System.out.println ("a--->" + a[j]);
			}*/
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			//logger.error(e.getMessage());
			e.printStackTrace();
		}
		 // Get the object of DataInputStream
		catch (IOException e) {
			// TODO Auto-generated catch block
			//logger.error(e.getMessage());
			e.printStackTrace();
		}
	    }catch (Exception e){//Catch exception if any
	  System.err.println("Error: " + e.getMessage());
	  }
	  }

}
