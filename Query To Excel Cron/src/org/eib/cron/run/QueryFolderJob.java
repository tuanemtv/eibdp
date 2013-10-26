package org.eib.cron.run;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;
import org.eib.common.AppCommon;
import org.eib.common.ArrayFTPUtil;
import org.eib.common.ArrayScriptUtil;
import org.eib.common.FTPUtil;
import org.eib.common.FolderUtil;
import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.eib.common.ZipUtil;
import org.eib.database.Query;
import org.eib.thread.RunMulConScript;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QueryFolderJob implements Job{
	
	private static Logger logger =Logger.getLogger("QueryFolderJob");	
	
	
	public void execute(JobExecutionContext context)
			throws JobExecutionException {
		
		logger.info("");
		logger.info("");
		logger.info("Running---------------------------------");
		JobDataMap data = context.getJobDetail().getJobDataMap();		
		logger.info("_cronNM= " + data.getString("_cronNM"));	
		logger.info("_defineScript= " + data.getString("_defineScript"));
		logger.info("_databaseID= " + data.getString("_databaseID"));
		logger.info("_ftpID= " + data.getString("_ftpID"));
		logger.info("_mailID= " + data.getString("_mailID"));
		logger.info("_folderUrl= " + data.getString("_folderUrl"));

		//System.out.println("Run-----------------");
		//System.out.println("_cronNM= " + data.getString("_cronNM"));
		//System.out.println("_defineScript= " + data.getString("_defineScript"));
		//System.out.println("_databaseID= " + data.getString("_databaseID"));
		String _outZipUrl;
		String _fileNameZip;
		String _outAppUrl;
		
		ResourceBundle rb = ResourceBundle.getBundle("/resource/app");				
		MainCommon main = new MainCommon("/resource/app",rb.getString("app_kind"));
		
		AppCommon _appcommon = new AppCommon();	
		_appcommon.set_configureurl(rb.getString("app_configure_url"));	
		_appcommon.getAppCom(rb.getString("app_configure_url")+rb.getString("congifureCronUrl")+"app.xml",rb.getString("app_configure_common")); //Common1
		_appcommon.logAppCommon();
		
		
		//Lay tat ca script
		ArrayScriptUtil _arrScript = new ArrayScriptUtil(data.getString("_folderUrl"));
		main.set_query(_arrScript.getScript());
		
		_arrScript.log();
		
		
		
		Date date1 ;
		DateFormat dateFormat1;
		DateFormat dateFormat2;
		
		dateFormat1 = new SimpleDateFormat("yyyyMMdd");	
		date1= new Date();
		_outAppUrl = main.get_appcommon().get_outurl();
		
		//Set lai duong dan out
		main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat1.format(date1)+"\\");		
		FolderUtil.createFolder(main.get_appcommon().get_outurl());
		
		//set FTP out
		//_appcommon.set_ftpUrl(main.get_appcommon().get_ftpUrl()+ dateFormat1.format(date1)+"\\");
		
		_fileNameZip = dateFormat1.format(date1);
		
		dateFormat2 = new SimpleDateFormat("HHmm");	
		date1= new Date();
		main.get_appcommon().set_outurl(main.get_appcommon().get_outurl()+dateFormat2.format(date1)+"\\");	
		
		_fileNameZip = _fileNameZip +" - " + dateFormat2.format(date1);
		
		//Tao folder
		FolderUtil.createFolder(main.get_appcommon().get_outurl());				
		_outZipUrl = main.get_appcommon().get_outurl();
		
		
		QueryServer _qurser = new QueryServer();
        Query _qur = new Query();
		_qurser = main.getQueryServerFromID(data.getString("_databaseID")); //Oralce-AReport , Oralce-ALONE29       MySQL-test          
        _qurser.connectDatabase();
        
        //_qurser.logQueryServer();
        
        //Lay define cho he thong
        /* Chua lay
        _qur = main.getQueryFromID(data.getString("_defineScript"));
        _qur.queryToAppDefine(main.get_appcommon(), _qurser);
        */        
        //main.get_appcommon().logAppCommon();
        
       
		//Tim cron dung        
        //String [] a= null;
		//a = main.getQueryIDFromName(data.getString("_cronNM"));		
		//Query[] _arrQueryTemp = new Query[a.length];		
		//_arrQueryTemp = main.getQueryFromQueryID(a);
		
			
		//main.logQuery();
		main.set_query(_arrScript.getScript());
		
		 
		//Sort lai query theo thu tu uu tien
		main.sortQueryWithPriority();				
		
        //set cac thong tin cua Query
        for (int j=0; j<main.get_query().length;j++)
        {        	
        	main.get_query()[j].set_module("File");
        	main.get_query()[j].set_querynm(main.get_appcommon().get_define().get("01h_trdt")+"_"+main.get_query()[j].get_querynm());
        	//main.get_query()[j].set_fileurl(main.get_appcommon().get_scriptUrl()+main.get_query()[j].get_fileurl());
    		//doc file
        	main.get_query()[j].readScript();    	
    		//this.logQuery();
        	main.get_query()[j].set_define(main.get_appcommon().get_define());
        	main.get_query()[j].setquery();        	
        	//main.get_query()[j].logQuery();
        }        
        
        //Tien hanh chay multi query        
        RunMulConScript.commandMulQueryExcel(_qurser, main.get_query(), main.get_appcommon());
      		
        
        //logger.error("main.get_appcommon().get_outurl()= "+main.get_appcommon().get_outurl());
        
        
        //Tien hanh Zip file
        
        //ZipUtil.createRARFolder("C:\\Program Files (x86)\\WinRAR\\WinRAR.exe", _outAppUrl + _fileNameZip+".rar", _outZipUrl);
        
        
        ZipUtil.creatZipFoler(main.get_appcommon().get_outurl(),_outZipUrl,_fileNameZip);
        
        /*
        //ZipUtil.creatZipFoler("D:\\20121109\\2233\\","D:\\20121109\\","20121109 - 2233");
        ZipUtil.creatZipFoler(main.get_appcommon().get_outurl(),_outZipUrl,_fileNameZip);
        */
        
        //Tao foler tren FTP
        
      //Lay FTP

  		FTPUtil ftp = new FTPUtil();
  		ArrayFTPUtil _ftpUtil = new ArrayFTPUtil(rb.getString("app_configure_url")+rb.getString("congifureCronUrl"));
  		//_ftpUtil.log();
  		
  		ftp = _ftpUtil.getFTPFromID(data.getString("_ftpID"));
  		ftp.set_port(21);
  		
        ftp.log();
        
        /*
        ftp.set_ftpServer(main.get_appcommon().get_ftpServer());
        ftp.set_user(main.get_appcommon().get_ftpUsr());
        ftp.set_password(main.get_appcommon().get_ftpPass());
        ftp.set_port(21);
        
      		
        ftp.createFolder(main.get_appcommon().get_ftpUrl());
                
        //Dua len FTP
        //main.get_appcommon().set_ftpFilename(main.get_appcommon().get_ftpFilename()+_fileNameZip+".zip");
        main.get_appcommon().set_ftpFilename(_fileNameZip+".zip");
        main.get_appcommon().set_ftpInurl(_outZipUrl+_fileNameZip+".zip");
        File source = new File(main.get_appcommon().get_ftpInurl());
        */
        
  		ftp.createFolder(ftp.get_ftpurl());
  		
  		main.get_appcommon().set_ftpFilename(ftp.get_ftpurl()+ _fileNameZip+".rar");//Duong dan tren server
        main.get_appcommon().set_ftpInurl(_outAppUrl+_fileNameZip+".rar"); 
        
        File source = new File(main.get_appcommon().get_ftpInurl()); //Duong dan cua file
        
        //main.get_appcommon().logAppCommon();
        logger.info("_outZipUrl= "+_outZipUrl);
        logger.info("1= "+main.get_appcommon().get_ftpInurl());
        logger.info("2= "+main.get_appcommon().get_ftpFilename());
        
        //app.set_ftpFilename("a\\TuTruyenCuaSteveJobs.pdf");
		//app.set_ftpUrl("D:\\Study\\Books\\TuTruyenCuaSteveJobs.pdf");
		
		//File source2 = new File(app.get_ftpUrl());
		
        //File source = new File("D:\\Study\\Books\\TuTruyenCuaSteveJobs.pdf");
        
        try {
			//upload(ftpServer,user,password,fileName,source);
			FTPUtil.upload(ftp.get_ftpServer(),
					ftp.get_user(),
					ftp.get_password(),
					main.get_appcommon().get_ftpFilename(),
					source);
			//Xoa folder
			
			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error(e.getMessage());		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error(e.getMessage());		
		}    
        
        //Xoa folder  
        /*
        File curFolder = new File(_outZipUrl);
        FolderUtil.deleteDirectory(curFolder);
         */
	}   
}