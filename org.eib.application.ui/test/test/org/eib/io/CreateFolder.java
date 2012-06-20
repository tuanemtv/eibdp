package test.org.eib.io;

import java.io.File;

public class CreateFolder {
	
	public static void main(String args[])
	  {
	File f = new File("D:\\TEST");
	try{
	if(f.mkdir())
	System.out.println("Directory Created");
	else
	System.out.println("Directory is not created");
	}catch(Exception e){
	e.printStackTrace();
	} 
	  }
}	
