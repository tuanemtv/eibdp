package test.org.eib.io;

import java.io.File;

public class GetFileList {

	/**
	 * @param args
	 */
	public static void main(String args[]){
		 //File file = new File("D:\\20090610_SVN Client\\Local Project\\Script\\DP\\");  
		 File file = new File("E:\\BACKUP\\DROPBOX\\Dropbox\\WORK\\Project\\File Configure\\Tong script\\Tong script\\EI\\"); //LN  
		 File[] files = file.listFiles();  
		 for (int fileInList = 0; fileInList < files.length; fileInList++)  
		 {  
		 System.out.println(files[fileInList].toString());  		 
		 }  
	}

}
