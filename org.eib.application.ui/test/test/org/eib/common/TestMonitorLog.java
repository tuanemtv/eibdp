package test.org.eib.common;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.eib.common.MonitorLog;
import org.eib.ftp.FTPdownload;

public class TestMonitorLog {

	private static Logger logger =Logger.getLogger("MainCommon");	
		
	
	//Can ham - doc file dua vao mang
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		MonitorLog ar = new MonitorLog();
		
		ar.set_frTRDT("20131026"); //Ngay log truoc
		ar.set_toTRDT("20131027"); //Ngay chay log
		
		String urlFolder ="D:\\TEST\\test\\MonitorLog\\"; //Duong dan thu muc				
		String ftpServer28 = "127.0.0.1" ;
		String ftpServer29 = "127.0.0.1" ;
		String ftpServer40 = "127.0.0.1" ;
	    String ftpUser = "tuanemtv"; ;
	    String ftpPass = "1"; 
	    
	    
	    String ftpClientDir = urlFolder + "Log\\";	     
		String urlInExcel  = urlFolder + ar.get_frTRDT() +"_monilog.xls";
		String urlOutExcel = urlFolder + ar.get_toTRDT() +"_monilog.xls";								
		String urlMonitorLog28 = urlFolder + "Log\\monitor_" + ar.get_toTRDT()+"_28";
		String urlMonitorLog29 = urlFolder + "Log\\monitor_" + ar.get_toTRDT()+"_29";
		String urlMonitorLog40 = urlFolder + "Log\\monitor_" + ar.get_toTRDT()+"_40";	
		String urlMonitorLogTXT28 = urlFolder + "LogTXT\\monitor_" + ar.get_toTRDT()+"_28.txt";
		String urlMonitorLogTXT29 = urlFolder + "LogTXT\\monitor_" + ar.get_toTRDT()+"_29.txt";
		String urlMonitorLogTXT40 = urlFolder + "LogTXT\\monitor_" + ar.get_toTRDT()+"_40.txt";
		String urlMonitorLogTXTAll = urlFolder + "LogTXT\\monitor_" + ar.get_toTRDT()+"_all.txt"; 
		String urlMonitorLogTXTAll_Duplicate = urlFolder + "LogTXT\\monitor_" + ar.get_toTRDT()+"_all_duplicate.txt";
		
		FTPdownload ftpDownload = null;
		try {
			//Chep file ve
			//May 28
			File f = new File(ftpClientDir);//Duong dan out file
			//May 28
			ftpDownload = new FTPdownload (ftpServer28,ftpUser, ftpPass);			
			ftpDownload.copyOneFile(f, "/May28","monitor_"+ar.get_toTRDT(),"_28");
			//May 29
			ftpDownload = new FTPdownload (ftpServer29,ftpUser, ftpPass);			
			ftpDownload.copyOneFile(f, "/May29","monitor_"+ar.get_toTRDT(),"_29");
			//May 40
			ftpDownload = new FTPdownload (ftpServer40,ftpUser, ftpPass);			
			ftpDownload.copyOneFile(f, "/May40","monitor_"+ar.get_toTRDT(),"_40");
			
			
			//Doc file
			ar.readMonitorLog("28", urlMonitorLog28);
			ar.readMonitorLog("29", urlMonitorLog29);
			ar.readMonitorLog("40", urlMonitorLog40);
			
			//Join array
			ar.joinArrayService("28");
			ar.joinArrayService("29");
			ar.joinArrayService("40");
			
			//Luu lai file
			ar.writeArrServer("28", urlMonitorLogTXT28);
			ar.writeArrServer("29", urlMonitorLogTXT29);
			ar.writeArrServer("40", urlMonitorLogTXT40);
			ar.writeArrServer("all", urlMonitorLogTXTAll);	
			
			
			//ar.readMonitorLog(urlMonitorLog);
			//ar.readLines(urlInService);
			/*
			for (int i = 0; i<ar.get_arrService().length; i++){
				System.out.println(i+"= "+ar.get_arrService()[i]);
			}*/			
			//System.out.println("---------------");
			ar.setDuplicate(); //Xoa dong trong
			ar.writeArrServer("all", urlMonitorLogTXTAll_Duplicate);	
			/*for (int i = 0; i<ar.get_arrService().length; i++){
				System.out.println(i+"= "+ar.get_arrService()[i]);
			}*/					
			
			//Doc excel
			ar.writeExcelFrMonitorLog(urlInExcel, urlOutExcel);
			//ar.writeExcelFrTxt(urlInExcel, urlOutExcel);								
			
		} catch (IOException e) {
			logger.error("Error: " + e.getMessage());
			e.printStackTrace();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}								
		
		logger.info("End");							    			
	}	

}
