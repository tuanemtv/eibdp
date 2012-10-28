package test.org.eib.io;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class GetFileList {

	/**
	 * @param args
	 */
	public static void main(String args[]){
		 //File file = new File("D:\\20090610_SVN Client\\Local Project\\Script\\DP\\");  

		 File file = new File("D:\\Project\\Query to Excel\\libs\\"); //LN
		
		 //File file = new File("D:\\FTP Server Url\\dp\\src\\dpsa\\");

		 //File file = new File("E:\\BACKUP\\DROPBOX\\Dropbox\\WORK\\Project\\File Configure\\Tong script\\Tong script\\DP\\"); //LN  
		 //File file = new File("N:\\ENGLISH LIST\\TEXTBOOK\\E - English for Office - Business Conversations\\");

			//File file = new File("D:\\Query to Excel\\Total Result\\20120621\\"); //LN
			//Long lastModified = file.lastModified();
			 //Date date = new Date(lastModified);
			 
			// DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");				
			// System.out.println(dateFormat.format(date));
		
		 
		 File[] files = file.listFiles();  
		 for (int fileInList = 0; fileInList < files.length; fileInList++)  
		 {  
			 /* 
			 /*
			 Date nowDate = new Date();
			 DateFormat nowDateFormat = new SimpleDateFormat("yyyyMMdd");
			 //System.out.println(nowDateFormat.format(nowDate));
			 
			 
			 Long lastModified=files[fileInList].lastModified();
			 
			 Date date = new Date(lastModified);
			 //DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");				
			 DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
			 if (dateFormat.format(date).equals(nowDateFormat.format(nowDate)))
				 System.out.println(dateFormat.format(date)+" "+files[fileInList].toString());
			*/ 

			 //System.out.println(files[fileInList].toString() + "thuoc tinh: ");  

			 System.out.println(files[fileInList].toString());  

			 
		 }  
	}

}
