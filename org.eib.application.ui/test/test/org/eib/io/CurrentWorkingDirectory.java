package test.org.eib.io;

import java.io.File;

public class CurrentWorkingDirectory {
	 public static void main (String args[]) {
	 File directory = new File (".");
	 try {
	 System.out.println ("Current directory's canonical path: " + directory.getCanonicalPath()+"\\Congifure\\"); 
	   System.out.println ("Current directory's absolute  path: "  + directory.getAbsolutePath());
	 }catch(Exception e) {
	 System.out.println("Exceptione is ="+e.getMessage());
	  }
	 }
	}