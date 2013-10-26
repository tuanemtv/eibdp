package org.eib.ftp;


import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.eib.common.AppCommon;


public class  FTPdownload
{
	private static Logger logger =Logger.getLogger("FTPdownload");

    FTPClient ftp = new FTPClient();

    public    FTPdownload(String ftpHost, String ftpUserName, String ftpPassword) throws IOException,Exception {
    	ftp.connect(ftpHost);
	    int reply;
	    reply = ftp.getReplyCode();
	    if(!FTPReply.isPositiveCompletion(reply)) {
	       try {
	    	   ftp.disconnect();
	       } catch (Exception e){	   
	    	   logger.info("Unable to disconnect from FTP server " + "after server refused connection. "+e.toString());
	       }
	       throw new Exception ("FTP server refused connection.");
	    }
	    logger.info("Connected to " + ftpHost + ". "+ftp.getReplyString());
	    if (!ftp.login(ftpUserName, ftpPassword)) {
	         throw new Exception ("Unable to login to FTP server " +"using username "+ftpUserName+" " +"and password "+ftpPassword);
	    }
    }

    /**
     *
     * @param outputFile: duong dan Client
     * @param inputFile: duong dan server
     */
    public  void  copyFile(File outputFile, String inputFile){
        int reply;
        InputStream in = null;
        OutputStream out = null;

        int flag =0;        
        logger.info("\n");
        logger.info("outputFile-> "+outputFile);
        logger.info("inputFile-> "+inputFile);
        logger.info("\n");

        try{
           File outputFile1 = new File(outputFile+"");
           boolean success = (new File(outputFile+"")).mkdirs();
           String inputfiles = inputFile;

           ftp.setFileType(FTP.BINARY_FILE_TYPE);

           FTPFile ftpfile = new FTPFile();
           ftpfile.setRawListing(inputFile);
           FTPFile[] ftpFiles = ftp.listFiles( inputFile );

           if (inputFile != null && inputFile.trim().length() > 0){        	  
               ftp.changeWorkingDirectory(inputFile);
               reply = ftp.getReplyCode();               
               if(!FTPReply.isPositiveCompletion(reply)){
                     //throw new Exception ("1. Unable to change working directory to:"+inputFile);
            	   return;
               }
           }
          
           int size = ( ftpFiles == null ) ? 0 : ftpFiles.length;          
           ArrayList ar  = new ArrayList();

           for( int i = 0; i < size; i++ ){
              ftpfile = ftpFiles[i];
              ar.add(ftpFiles[i].getName());            
              if(ftpfile.isDirectory()){
	        	   //neu la no la duong dan thi di tiep
            	  String temIn =  inputFile+"";              
	              File f = new File(outputFile+"\\"+ftpfile.getName());
	              copyFile(f,temIn+"/"+ftpfile.getName());
	           }else{	        	   
	               try{
	                  boolean retValue=false;
	                  String filename=ftpfile.getName();
	                  String File1 = outputFile + "\\"+ filename;
	                  File  fileout = new File(File1);
	                  
	                  //if (filename.indexOf(".pc")>0){//La file .pc	                	 
	                	  logger.info(" -->Copy: "+filename+"   ==> "+outputFile + "\\"+ filename+"  -->OK");
	                	  ftp.changeWorkingDirectory(inputFile);
		                  retValue = ftp.retrieveFile(filename, new FileOutputStream(fileout));
		                  if (!retValue){
		                   //throw new Exception ("1. Downloading of remote file "+ inputFile+" failed. ftp.retrieveFile() returned false.");
		                	  return;
		                  }
	                  //}
	               }catch(Exception e){
	            	   logger.info("1. The exection in function="+e);
	               }
	            }
       		}
        }catch(Exception exe){
        	logger.info("1. The exection in function="+exe);
        }
    }
    
    /**
     * Copy 1 file tu Server xuong Client
     * @param outputFile
     * @param inputFile
     * @param fileName
     */
    public  void  copyOneFile(File outputFile, String inputFile, String fileName, String suffixName){
        int reply;
        InputStream in = null;
        OutputStream out = null;

        int flag =0;        
        //logger.info("\n");
        logger.info("outputFile-> "+outputFile);
        logger.info("inputFile-> "+inputFile);
        //logger.info("\n");

        try{
           File outputFile1 = new File(outputFile+"");
           boolean success = (new File(outputFile+"")).mkdirs();
           String inputfiles = inputFile;

           ftp.setFileType(FTP.BINARY_FILE_TYPE);

           FTPFile ftpfile = new FTPFile();
           ftpfile.setRawListing(inputFile);
           FTPFile[] ftpFiles = ftp.listFiles( inputFile );

           if (inputFile != null && inputFile.trim().length() > 0){        	  
               ftp.changeWorkingDirectory(inputFile);
               reply = ftp.getReplyCode();               
               if(!FTPReply.isPositiveCompletion(reply)){
                     //throw new Exception ("1. Unable to change working directory to:"+inputFile);
            	   return;
               }
           }
          
           int size = ( ftpFiles == null ) ? 0 : ftpFiles.length;          
           ArrayList ar  = new ArrayList();

           for( int i = 0; i < size; i++ ){
              ftpfile = ftpFiles[i];
              ar.add(ftpFiles[i].getName());            
              if(ftpfile.isDirectory()){
	        	   //neu la no la duong dan thi di tiep
            	  String temIn =  inputFile+"";              
	              File f = new File(outputFile+"\\"+ftpfile.getName());
	              copyFile(f,temIn+"/"+ftpfile.getName());
	           }else{	        	   
	               try{
	                  boolean retValue=false;
	                  String filename=ftpfile.getName();
	                  if( filename.equals(fileName)){
	                	  String File1 = outputFile + "\\"+ filename + suffixName;
		                  File  fileout = new File(File1);		                  		                                 	 
	                	  logger.info(" -->Copy: "+filename+"   ==> "+outputFile + "\\"+ filename+ suffixName+"  -->OK");
	                	  ftp.changeWorkingDirectory(inputFile);
		                  retValue = ftp.retrieveFile(filename, new FileOutputStream(fileout));
		                  if (!retValue){
		                   //throw new Exception ("1. Downloading of remote file "+ inputFile+" failed. ftp.retrieveFile() returned false.");
		                	  return;
		                  }
	                  }	                  	                  
	               }catch(Exception e){
	            	   logger.info("1. The exection in function="+e);
	               }
	            }
       		}
        }catch(Exception exe){
        	logger.info("1. The exection in function="+exe);
        }
    }
    
    /**
     * 
     * @param _app
     */
    public  void  copyFile(AppCommon _app){
        int reply;
        InputStream in = null;
        OutputStream out = null;
        
        
        File outputFile = new File(_app.get_srcFTPCliUrl());
        String inputFile = _app.get_srcFTPSerUrl();
        
        int flag =0;        
        logger.info("\n");
        logger.info("outputFile-> "+outputFile);
        logger.info("inputFile-> "+inputFile);
        logger.info("\n");

        try{
           File outputFile1 = new File(outputFile+"");
           boolean success = (new File(outputFile+"")).mkdirs();
           String inputfiles = inputFile;

           ftp.setFileType(FTP.BINARY_FILE_TYPE);

           FTPFile ftpfile = new FTPFile();
           ftpfile.setRawListing(inputFile);
           FTPFile[] ftpFiles = ftp.listFiles( inputFile );

           if (inputFile != null && inputFile.trim().length() > 0){        	  
               ftp.changeWorkingDirectory(inputFile);
               reply = ftp.getReplyCode();               
               if(!FTPReply.isPositiveCompletion(reply)){
                     //throw new Exception ("1. Unable to change working directory to:"+inputFile);
            	   return;
               }
           }
          
           int size = ( ftpFiles == null ) ? 0 : ftpFiles.length;          
           ArrayList ar  = new ArrayList();

           for( int i = 0; i < size; i++ ){
              ftpfile = ftpFiles[i];
              ar.add(ftpFiles[i].getName());            
              if(ftpfile.isDirectory()){
	        	   //neu la no la duong dan thi di tiep
            	  String temIn =  inputFile+"";
            	  //goi de quy
	              File f = new File(outputFile+"\\"+ftpfile.getName());
	              copyFile(f,temIn+"/"+ftpfile.getName());
	              
	           
	              
	           }else{	        	   
	               try{
	                  boolean retValue=false;
	                  String filename=ftpfile.getName();
	                  String File1 = outputFile + "\\"+ filename;
	                  File  fileout = new File(File1);
	                  
	                  if (filename.indexOf(_app.get_srcFTPExtFile())>0){//La file .pc	                	 
	                	  logger.info(" -->Copy: "+filename+"   ==> "+outputFile + "\\"+ filename+"  -->OK");
	                	  ftp.changeWorkingDirectory(inputFile);
		                  retValue = ftp.retrieveFile(filename, new FileOutputStream(fileout));
		                  if (!retValue){
		                   //throw new Exception ("1. Downloading of remote file "+ inputFile+" failed. ftp.retrieveFile() returned false.");
		                	  return;
		                  }
	                  }
	               }catch(Exception e){
	            	   logger.info("1. The exection in function="+e);
	               }
	            }
       		}
        }catch(Exception exe){
        	logger.info("1. The exection in function="+exe);
        }
    }
    
    /**
     * Hien thi cac file moi chinh sua
     * @param _app
     */
    public  void  showModifyFile(AppCommon _app){
        int reply;
        InputStream in = null;
        OutputStream out = null;
        
        
        File outputFile = new File(_app.get_srcFTPCliUrl());
        String inputFile = _app.get_srcFTPSerUrl();
          
       
        try{
           //File outputFile1 = new File(outputFile+"");
           //boolean success = (new File(outputFile+"")).mkdirs();
           //String inputfiles = inputFile;

           ftp.setFileType(FTP.BINARY_FILE_TYPE);

           FTPFile ftpfile = new FTPFile();
           ftpfile.setRawListing(inputFile);
           FTPFile[] ftpFiles = ftp.listFiles( inputFile );

           if (inputFile != null && inputFile.trim().length() > 0){        	  
               ftp.changeWorkingDirectory(inputFile);
               reply = ftp.getReplyCode();               
               if(!FTPReply.isPositiveCompletion(reply)){
                     //throw new Exception ("1. Unable to change working directory to:"+inputFile);
            	   return;
               }
           }
          
           int size = ( ftpFiles == null ) ? 0 : ftpFiles.length;          
           ArrayList<String> ar  = new ArrayList<String>();

           for( int i = 0; i < size; i++ ){
              ftpfile = ftpFiles[i];
              ar.add(ftpFiles[i].getName());  
              
              if(ftpfile.isDirectory()){
	        	   //neu la no la duong dan thi di tiep
            	  String temIn =  inputFile+"";
            	  //Goi de quy
            	  
	             //File f = new File(outputFile+"\\"+ftpfile.getName());
	              //copyFile(f,temIn+"/"+ftpfile.getName());
	              
            	  _app.set_srcFTPCliUrl(outputFile+"\\"+ftpfile.getName());
	              _app.set_srcFTPSerUrl(temIn+"/"+ftpfile.getName());
	              	            	              
	              showModifyFile(_app);
	              
	           }else{	        	   
	               try{
	                  boolean retValue=false;
	                  String filename=ftpfile.getName();
	                  String File1 = outputFile + "\\"+ filename;
	                  File  fileout = new File(File1);
	                  
	                  String strDate="";
	                  if (_app.get_srcDate().equals("TODAY")){//la ngay hom nay
	                	 Date nowDate = new Date();
	         			 DateFormat nowDateFormat = new SimpleDateFormat("yyyyMMdd");
	         			 strDate = nowDateFormat.format(nowDate);
	                  }else
	                  {
	                	  strDate = _app.get_srcDate();
	                  }
	                  
	                 
	                  Date date;
	                  date= ftpfile.getTimestamp().getTime();
	                  	               
	     			  DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
	     			  
	     			 //System.out.println(fileout.getTimestamp().getTime() + " - " + fileout.getName());
	     			 // logger.info(strDate+" "+dateFormat.format(date)+" filename: "+filename +" "+outputFile);
	     			  if (dateFormat.format(date).equals(strDate) && filename.indexOf(_app.get_srcFTPExtFile())>0){
	     				  logger.info(" modify: "+_app.get_srcFTPSerUrl()+"/"+ftpfile.getName());
	     				  //System.out.println(" modify: "+_app.get_srcFTPSerUrl()+"/"+ftpfile.getName());
	     			  }
	     				 
	                  /*
	                  if (filename.indexOf(_app.get_srcFTPExtFile())>0){//La file .pc	                	 
	                	  logger.info(" -->Copy: "+filename+"   ==> "+outputFile + "\\"+ filename+"  -->OK");
	                	  ftp.changeWorkingDirectory(inputFile);
		                  retValue = ftp.retrieveFile(filename, new FileOutputStream(fileout));
		                  if (!retValue){
		                   //throw new Exception ("1. Downloading of remote file "+ inputFile+" failed. ftp.retrieveFile() returned false.");
		                	  return;
		                  }
	                  }*/
	               }catch(Exception e){
	            	   logger.info("1. The exection in function="+e);
	               }
	            }
       		}
        }catch(Exception exe){
        	logger.info("1. The exection in function="+exe);
        }
    }
    
    public  void  downloadModifyFile(AppCommon _app){
        int reply;
        InputStream in = null;
        OutputStream out = null;
        
        
        File outputFile = new File(_app.get_srcFTPCliUrl());
        String inputFile = _app.get_srcFTPSerUrl();
          
       
        try{
           //File outputFile1 = new File(outputFile+"");
           boolean success = (new File(outputFile+"")).mkdirs();
           //String inputfiles = inputFile;

           ftp.setFileType(FTP.BINARY_FILE_TYPE);

           FTPFile ftpfile = new FTPFile();
           ftpfile.setRawListing(inputFile);
           FTPFile[] ftpFiles = ftp.listFiles( inputFile );

           if (inputFile != null && inputFile.trim().length() > 0){        	  
               ftp.changeWorkingDirectory(inputFile);
               reply = ftp.getReplyCode();               
               if(!FTPReply.isPositiveCompletion(reply)){
                     //throw new Exception ("1. Unable to change working directory to:"+inputFile);
            	   return;
               }
           }
          
           int size = ( ftpFiles == null ) ? 0 : ftpFiles.length;          
           ArrayList<String> ar  = new ArrayList<String>();

           for( int i = 0; i < size; i++ ){
              ftpfile = ftpFiles[i];
              ar.add(ftpFiles[i].getName());  
              
              if(ftpfile.isDirectory()){
	        	   //neu la no la duong dan thi di tiep
            	  String temIn =  inputFile+"";
            	  //Goi de quy
            	  
	             //File f = new File(outputFile+"\\"+ftpfile.getName());
	              //copyFile(f,temIn+"/"+ftpfile.getName());
	              
            	  _app.set_srcFTPCliUrl(outputFile+"\\"+ftpfile.getName());
	              _app.set_srcFTPSerUrl(temIn+"/"+ftpfile.getName());
	              	            	              
	              downloadModifyFile(_app);
	              
	           }else{	        	   
	               try{
	                  boolean retValue=false;
	                  String filename=ftpfile.getName();
	                  String File1 = outputFile + "\\"+ filename;
	                  File  fileout = new File(File1);
	                  
	                  String strDate="";
	                  if (_app.get_srcDate().equals("TODAY")){//la ngay hom nay
	                	 Date nowDate = new Date();
	         			 DateFormat nowDateFormat = new SimpleDateFormat("yyyyMMdd");
	         			 strDate = nowDateFormat.format(nowDate);
	                  }else
	                  {
	                	  strDate = _app.get_srcDate();
	                  }
	                  
	                 
	                  Date date;
	                  date= ftpfile.getTimestamp().getTime();
	                  	               
	     			  DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
	     			  
	     			 //System.out.println(fileout.getTimestamp().getTime() + " - " + fileout.getName());
	     			 // logger.info(strDate+" "+dateFormat.format(date)+" filename: "+filename +" "+outputFile);
	     			  if (dateFormat.format(date).equals(strDate)){
	     				  logger.info(" download: "+_app.get_srcFTPSerUrl()+"/"+ftpfile.getName());
	     				  //System.out.println(" download: "+_app.get_srcFTPSerUrl()+"/"+ftpfile.getName());
	     				 if (filename.indexOf(_app.get_srcFTPExtFile())>0){//La file .pc	                	 
		                	  logger.info(" -->Copy: "+filename+"   ==> "+outputFile + "\\"+ filename+"  -->OK");
		                	  ftp.changeWorkingDirectory(inputFile);
			                  retValue = ftp.retrieveFile(filename, new FileOutputStream(fileout));
			                  if (!retValue){
			                   //throw new Exception ("1. Downloading of remote file "+ inputFile+" failed. ftp.retrieveFile() returned false.");
			                	  return;
			                  }
		                  }
	     			  }
	     				 
	               }catch(Exception e){
	            	   logger.info("1. The exection in function="+e);
	               }
	            }
       		}
        }catch(Exception exe){
        	logger.info("1. The exection in function="+exe);
        }
    }
    
    
    /**
     *
     * @param inFile: duong dan Server
     * @param outFile: duong dan Client
     */
    public  void filecopy(String inFile, String outFile){
        int n;
        int reply;
        //System.out.println("\n\n\n 2. Goi filecopy ......<------");
        //System.out.println("inFile-> "+inFile);
        //System.out.println("outFile-> "+outFile);
        //System.out.println("\n");

        ArrayList arsecond = new ArrayList();
        try{
           File outputFile = new File(outFile);
           FTPFile inputFile = new FTPFile();
           inputFile.setRawListing(inFile);           
           File dir = new File(inFile);//your input directory which you want to replicate
           FTPFile[] children = null;
           children = ftp.listFiles();
           String   tempfile="";

           String temp="";
           if (children == null){
        	   //System.out.println("the children is null");
           }else{
               for (int i=0; i<children.length; i++){                  
            	   //System.out.println("2.==>"+inFile+"/"+children[i].getName());

            	   /*
            	   String childfile = (String) children[i].getName();
                   if(!children[i].isDirectory()){
                       System.out.println("*****. outputchild is-> " +outputFile +"  --> "+outputFile+"\\"+ childfile);
                       if (childfile.indexOf(".pc")>0){//La file .pc
  	                     boolean retValue = ftp.retrieveFile(childfile, new FileOutputStream(outputFile+"\\"+ childfile));
  	                     if (!retValue){
  	                    	 return;
  	                         //throw new Exception ("Downloading of remote file=> "+ inputFile+" failed. ftp.retrieveFile() returned false.");
  	                     }
                       }
                    }else{
                    	 temp = children[i].getName();
                         tempfile = outputFile+"/" +temp ;
                         //tempfile = outputFile+"/";
                         System.out.println("Else  => " +temp );
                    }*/

            	   /*String temp="";
            	   if(!children[i].isDirectory()){
                       temp = children[i].getName();
                       arsecond.add(children[i].getName());
                       Iterator itsecond = arsecond.iterator();
                       while(itsecond.hasNext()){
                      	 String childfile = (String) itsecond.next();
                           System.out.println("2. child file is-> " +childfile );
                           if(children[i].isFile()){
                              System.out.println("**. outputchild is-> " +outputFile );
                              boolean retValue = ftp.retrieveFile(childfile, new FileOutputStream(outputFile+"\\"+ childfile));
                              if (!retValue){
                                  throw new Exception ("Downloading of remote file=> "+ inputFile+" failed. ftp.retrieveFile() returned false.");
                              }
                           }
                       }
                       tempfile = outputFile+"/";
                       System.out.println("Inside if File copy temp is=> " +temp );
                    }else{
                       //temp = extractDirName(children[p].toString());
                       temp = children[i].getName();
                       tempfile = outputFile+"/" +temp ;
                       System.out.println("Inside else  File copy temp is=> " +temp );
                    }

                    //File f = new File(outputFile+"/"+temp);
                    //System.out.println("\n out file ="+f);
                    File f = new File(tempfile);
                    System.out.println("inside file copy verfy  f ->>  " + f);
                    System.out.println("inside file copy verfy  temp->>  " + temp) ;
                    //copyFile(f,temp+"");
                    copyFile(f,inFile+"/"+temp+"");*/
               }
          }


          for(int p=0;p<children.length;p++){
              if(!children[p].isDirectory()){
                temp = children[p].getName();
                 arsecond.add(children[p].getName());
                 Iterator itsecond = arsecond.iterator();
                 /*
                 while(itsecond.hasNext()){
                	 String childfile = (String) itsecond.next();
                     System.out.println("2. child file is-> " +childfile );
                     if(children[p].isFile()){
                        System.out.println("**. outputchild is-> " +outputFile );
                        boolean retValue = ftp.retrieveFile(childfile, new FileOutputStream(outputFile+"\\"+ childfile));
                        if (!retValue){
                            throw new Exception ("Downloading of remote file=> "+ inputFile+" failed. ftp.retrieveFile() returned false.");
                        }
                     }
                 }*/
                 /*
                 */

                 tempfile = outputFile+"/";
                 //System.out.println("If  => " +temp +" - "+tempfile);
                //
              }else{                
                 temp = children[p].getName();
                 tempfile = outputFile+"/" +temp ;
                 //tempfile = outputFile+"/";
                //System.out.println("Else  => " +temp );
             }

              //File f = new File(outputFile+"/"+temp);
              //System.out.println("\n out file ="+f);

              File f = new File(tempfile);
              //System.out.println("inside file copy verfy  f ->>  " + f);
             // System.out.println("inside file copy verfy  temp->>  " + temp) ;
            // copyFile(f,temp+"");
              copyFile(f,inFile+"/"+temp+"");

          }
        }catch(Exception smbe){
        	//System.out.println("The smbFile fileCopy function=> "+smbe);
        }
      }


    public static void main(String[] args) throws  Exception{

	  ResourceBundle rb = ResourceBundle.getBundle("configure");
	  String server = rb.getString("server");
      String user = rb.getString("user");
      String pass = rb.getString("pass");
      String serverDir = rb.getString("serverDir");
      String clientDir = rb.getString("clientDir");

       FTPdownload   upload = new FTPdownload (server,user, pass);
       File f = new File(clientDir);
       //upload.copyFile(f,serverDir);
      upload.filecopy("ABC/","C:\\B");
     }
}