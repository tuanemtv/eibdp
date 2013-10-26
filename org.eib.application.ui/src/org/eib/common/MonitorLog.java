package org.eib.common;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;

public class MonitorLog {
	private static Logger logger =Logger.getLogger("MonitorLog");
	private String [] _arrService;
	private String [] _arrService28;
	private String [] _arrService29;
	private String [] _arrService40;	
	private String [] _arrExcel;
	
	private String _pCnm;
	private String _frTRDT;
	private String _toTRDT;
	private int _rowLines; //Row excel
				

	public String[] get_arrService28() {
		return _arrService28;
	}

	public void set_arrService28(String[] _arrService28) {
		this._arrService28 = _arrService28;
	}

	public String[] get_arrService29() {
		return _arrService29;
	}

	public void set_arrService29(String[] _arrService29) {
		this._arrService29 = _arrService29;
	}

	public String[] get_arrService40() {
		return _arrService40;
	}

	public void set_arrService40(String[] _arrService40) {
		this._arrService40 = _arrService40;
	}

	public int get_rowLines() {
		return _rowLines;
	}

	public void set_rowLines(int _rowLines) {
		this._rowLines = _rowLines;
	}

	public MonitorLog(String[] _arrService) {
		super();
		this._arrService = _arrService;
	}
	
	public String[] get_arrExcel() {
		return _arrExcel;
	}

	public void set_arrExcel(String[] _arrExcel) {
		this._arrExcel = _arrExcel;
	}
		
	public String get_pCnm() {
		return _pCnm;
	}

	public void set_pCnm(String _pCnm) {
		this._pCnm = _pCnm;
	}

	
	public String get_frTRDT() {
		return _frTRDT;
	}

	public void set_frTRDT(String _frTRDT) {
		this._frTRDT = _frTRDT;
	}

	public String get_toTRDT() {
		return _toTRDT;
	}

	public void set_toTRDT(String _toTRDT) {
		this._toTRDT = _toTRDT;
	}

	public String[] get_arrService() {
		return _arrService;
	}

	public void set_arrService(String[] _arrService) {
		this._arrService = _arrService;
	}
	
	public MonitorLog(){
		
	}
	
	/**
	 * 	
	 * @param filename
	 * @throws IOException
	 */
	public void readLines(String filename) throws IOException {
        FileReader fileReader = new FileReader(filename);
        BufferedReader bufferedReader = new BufferedReader(fileReader);
        List<String> lines = new ArrayList<String>();
        String line = null;
        while ((line = bufferedReader.readLine()) != null) {
            lines.add(line);
        }
        bufferedReader.close();
        
        this.set_arrService(lines.toArray(new String[lines.size()]));        
    }
	
	/**
	 * 
	 * @param typeServer: Loai server: 28, 29, 40, 
	 * @param filename
	 * @throws IOException
	 */
	public void readLines(String typeServer, String filename) throws IOException {
        FileReader fileReader = new FileReader(filename);
        BufferedReader bufferedReader = new BufferedReader(fileReader);
        List<String> lines = new ArrayList<String>();
        String line = null;
        while ((line = bufferedReader.readLine()) != null) {
            lines.add(line);
        }
        bufferedReader.close();
        
        if (typeServer.equals("28"))
        	this.set_arrService28(lines.toArray(new String[lines.size()]));        
        else if (typeServer.equals("29"))
        	this.set_arrService29(lines.toArray(new String[lines.size()]));
        else if (typeServer.equals("40"))
        	this.set_arrService40(lines.toArray(new String[lines.size()]));
        else
        	this.set_arrService(lines.toArray(new String[lines.size()]));
    }
	
	/**
	 * 
	 * @param filename
	 * @throws IOException
	 */
	public void readMonitorLog(String filename) throws IOException {		
		FileInputStream fstream = new FileInputStream(filename);
		DataInputStream in = new DataInputStream(fstream);
		BufferedReader br = new BufferedReader(new InputStreamReader(in));
		String strLine;
		List<String> lines = new ArrayList<String>();
		
		while ((strLine = br.readLine()) != null)   {				
			 if (strLine.length()>10){ //Xet dong tren 10 ky tu				 
				 String temp="";
				 temp = strLine.substring(0, 1);
				 
				 if (temp.equals(">") || temp.equals("P") || temp.equals("	") || 
				     temp.equals("-") || temp.equals("T") || temp.equals("�") ||
				     temp.equals("F")){
					 //Ko doc dong nay
				 }else{
					 
					 //System.out.println (strLine);
					 String [] strTemp = strLine.split(" ", 0);
					 String serviceNm = "";
					 for (int i =0 ; i< strTemp.length; i++){
						 if (i ==0 ){							
						 	serviceNm=strTemp[i];
						 }
						 else if (i == strTemp.length - 1 ){
							if (strTemp[i].equals(")")){ //Vi RESTARTING
									//System.out.println (strTemp[i-3]);
								serviceNm = serviceNm + ";" +strTemp[i-3];
							}else
								serviceNm = serviceNm + ";" +strTemp[i];
							//serviceNm = serviceNm + ";" +strTemp[i];
						 }
					 }
					 lines.add(serviceNm);					
				 }
			 }				 	
		}	
		
		this.set_arrService(lines.toArray(new String[lines.size()]));   
		/*
		String a[] = lines.toArray(new String[lines.size()]);
		for (int j =0; j<a.length; j++){
			System.out.println ("a--->" + a[j]);
		}*/
	}
	
	/**
	 * 
	 * @param typeServer: Loai server: 28, 29, 40, 
	 * @param filename
	 * @throws IOException
	 */
	public void readMonitorLog(String typeServer, String filename) throws IOException {	
		logger.info("readMonitorLog: " + typeServer);
		//Date bfDate, afDate;
		//bfDate= new Date();
		FileInputStream fstream = new FileInputStream(filename);
		DataInputStream in = new DataInputStream(fstream);
		BufferedReader br = new BufferedReader(new InputStreamReader(in));
		String strLine;
		List<String> lines = new ArrayList<String>();
		
		while ((strLine = br.readLine()) != null)   {				
			 if (strLine.length()>10){ //Xet dong tren 10 ky tu				 
				 String temp="";
				 temp = strLine.substring(0, 1);
				 
				 if (temp.equals(">") || temp.equals("P") || temp.equals("	") || 
				     temp.equals("-") || temp.equals("T") || temp.equals("�") ||
				     temp.equals("F")){
					 //Ko doc dong nay
				 }else{
					 
					 //System.out.println (strLine);
					 String [] strTemp = strLine.split(" ", 0);
					 String serviceNm = "";
					 for (int i =0 ; i< strTemp.length; i++){
						 if (i ==0 ){							
						 	serviceNm=strTemp[i];
						 }
						 else if (i == strTemp.length - 1 ){
							if (strTemp[i].equals(")")){ //Vi RESTARTING
									//System.out.println (strTemp[i-3]);
								serviceNm = serviceNm + ";" +strTemp[i-3];
							}else
								serviceNm = serviceNm + ";" +strTemp[i];
							//serviceNm = serviceNm + ";" +strTemp[i];
						 }
					 }
					 lines.add(serviceNm);					
				 }
			 }				 	
		}	
		
		
		if (typeServer.equals("28"))
        	this.set_arrService28(lines.toArray(new String[lines.size()]));        	
        else if (typeServer.equals("29"))
        	this.set_arrService29(lines.toArray(new String[lines.size()]));
        else if (typeServer.equals("40"))
        	this.set_arrService40(lines.toArray(new String[lines.size()]));
        else
        	this.set_arrService(lines.toArray(new String[lines.size()]));
		
		//afDate= new Date();
		logger.info("readMonitorLog done: " + typeServer + 	" Rows="+ lines.size());
		
		/*
		String a[] = lines.toArray(new String[lines.size()]);
		for (int j =0; j<a.length; j++){
			System.out.println ("a--->" + a[j]);
		}*/
	}
		
	/**
	 * Loc mang trung
	 */
	public void setDuplicate(){	
		logger.info("setDuplicate before rows= " + this.get_arrService().length);
		
		Set<String> set = new LinkedHashSet<String>(Arrays.asList(this.get_arrService()));
		String[] arr3 = set.toArray(new String[0]);
		this.set_arrService(arr3);
		
		logger.info("setDuplicate after rows= " + this.get_arrService().length);
	}
	
	/**
	 * 
	 * @param typeServer
	 */
	public void joinArrayService(String typeServer){
		logger.info("joinArrayService: " + typeServer);
		//Date bfDate, afDate;
		//bfDate= new Date();
		
		if (typeServer.equals("28"))
			this.set_arrService(ArrayUtils.addAll(this.get_arrService(), this.get_arrService28()));
        else if (typeServer.equals("29"))
        	this.set_arrService(ArrayUtils.addAll(this.get_arrService(), this.get_arrService29()));
        else if (typeServer.equals("40"))
        	this.set_arrService(ArrayUtils.addAll(this.get_arrService(), this.get_arrService40())); 
		
		//afDate= new Date();
		logger.info("joinArrayService done: " + typeServer + 	" arrService Rows="+ this.get_arrService().length);
		
	}
	
	/**
	 * Doc excel va ghi lai Excel tu file Txt. arrService chi co 1 dong service
	 * @param urlInExcel
	 * @param urlOutExcel
	 * @throws IOException 
	 */
	public void writeExcelFrTxt(String urlInExcel, String urlOutExcel) throws IOException{
		
		FileInputStream file = new FileInputStream(new File(urlInExcel));		     	    
	    HSSFWorkbook workbook = new HSSFWorkbook(file);	//Get the workbook instance for XLS file	 		    		    	    
	    HSSFSheet sheet = workbook.getSheetAt(0); //Get first sheet from the workbook		    		    		    		    	    
	    Iterator<Row> rowIterator = sheet.iterator(); //Iterate through each rows from first sheet		       
	    int j= 0;
	    List<String> lines = new ArrayList<String>();
	    
	    while(rowIterator.hasNext()) {
	        Row row = rowIterator.next();			        
	        HSSFCell cell1 = (HSSFCell) row.getCell(0); //Chi doc o 1
	        lines.add(cell1.getStringCellValue()); //dua vao mang		        
	        j++;
	        this.set_rowLines(j); //Dong hoi duyet
	        //System.out.println("");		        
	    }		    
	    file.close();
	    
	    this.set_arrExcel(lines.toArray(new String[lines.size()]));		//Set mang Excel
	    
	    //System.out.println(ar.get_arrExcel().length);
	    //for (int k=0; k<=ar.get_arrExcel().length -1 ;k++){
	    //	 System.out.println("k["+k+"]= " + ar.get_arrExcel()[k]);
	    //}
	     
	    //Tim dong nao ko co trong Excel		    
	    HSSFFont font = workbook.createFont();
	    font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	    CellStyle style = workbook.createCellStyle();
	    //font.setBoldweight(HSSFFont.COLOR_RED);	
	    //style.setFillBackgroundColor(IndexedColors.AQUA.getIndex());
	    //style.setFillForegroundColor(IndexedColors.BLUE.getIndex());
	    //style.setAlignment(CellStyle.ALIGN_CENTER);	    
        //style.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        //style.setFillPattern(CellStyle.SOLID_FOREGROUND);	        
        style.setFont(font);	        
        
        for (int l=0; l<this.get_arrService().length; l++){ //Quet array Services
        	boolean flag = false; 
        	for(int m=0; m<this.get_arrExcel().length-1; m++){ //Quet Array Excel
        		if(this.get_arrService()[l].equals(this.get_arrExcel()[m])){
        			flag = true;
        		}
        	}
        	
        	if (flag == false){ //Tim khong thay trong file Excel
        		HSSFRow  row = sheet.createRow((int) this.get_rowLines());  
    		    HSSFCell cell = row.createCell(0);//cot 1			   
    		    cell.setCellValue(this.get_arrService()[l]);
    		    cell.setCellStyle(style);
    		    
    		    cell = row.createCell(2);//cot 2
    		    cell.setCellValue(this.get_toTRDT()); //lay ngay
    		    
    		    this.set_rowLines(this.get_rowLines()+1);
        	}
        }
	    		    		   	    		 		   		    
	    FileOutputStream out =
	        new FileOutputStream(new File(urlOutExcel));
	    workbook.write(out);
	    out.close();
		
	}
	
	/**
	 * Doc excel va ghi lai Excel tu file Txt. arrService chi co 1 dong gom server;service
	 * @param urlInExcel
	 * @param urlOutExcel
	 * @throws IOException 
	 */
	public void writeExcelFrMonitorLog(String urlInExcel, String urlOutExcel) throws IOException{
		logger.info("writeExcelFrMonitorLog In:" + urlInExcel +" out:"+ urlOutExcel);
		
		FileInputStream file = new FileInputStream(new File(urlInExcel));		     	    
	    HSSFWorkbook workbook = new HSSFWorkbook(file);	//Get the workbook instance for XLS file	 		    		    	    
	    HSSFSheet sheet = workbook.getSheetAt(0); //Get first sheet from the workbook		    		    		    		    	    
	    Iterator<Row> rowIterator = sheet.iterator(); //Iterate through each rows from first sheet		       
	    int j= 0;
	    List<String> lines = new ArrayList<String>();
	    
	    while(rowIterator.hasNext()) {
	        Row row = rowIterator.next();			        
	        HSSFCell cell1 = (HSSFCell) row.getCell(0); //Chi doc o 1
	        lines.add(cell1.getStringCellValue()); //dua vao mang		        
	        j++;
	        this.set_rowLines(j); //Dong hoi duyet
	        //System.out.println("");		        
	    }		    
	    file.close();
	    
	    this.set_arrExcel(lines.toArray(new String[lines.size()]));		//Set mang Excel
	    
	    //System.out.println(ar.get_arrExcel().length);
	    //for (int k=0; k<=ar.get_arrExcel().length -1 ;k++){
	    //	 System.out.println("k["+k+"]= " + ar.get_arrExcel()[k]);
	    //}
	     
	    //Tim dong nao ko co trong Excel		    
	    HSSFFont font = workbook.createFont();
	    font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	    CellStyle style = workbook.createCellStyle();
	    //font.setBoldweight(HSSFFont.COLOR_RED);	
	    //style.setFillBackgroundColor(IndexedColors.AQUA.getIndex());
	    //style.setFillForegroundColor(IndexedColors.BLUE.getIndex());
	    //style.setAlignment(CellStyle.ALIGN_CENTER);	    
        //style.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        //style.setFillPattern(CellStyle.SOLID_FOREGROUND);	        
        style.setFont(font);	        
        
        for (int l=0; l<this.get_arrService().length; l++){ //Quet array Services
        	boolean flag = false; 
        	String [] strTemp = this.get_arrService()[l].split(";", 0); //strTemp[0]: Server, strTemp[1]: service name
        	for(int m=0; m<this.get_arrExcel().length; m++){ //Quet Array Excel
        		if(strTemp[1].equals(this.get_arrExcel()[m])){
        			flag = true;
        		}
        	}
        	
        	if (flag == false){ //Tim khong thay trong file Excel
        		logger.info("Next ="+strTemp[1]+" ("+strTemp[0]+")");
        		HSSFRow  row = sheet.createRow((int) this.get_rowLines());  
    		    HSSFCell cell = row.createCell(0);//cot 1			   
    		    cell.setCellValue(strTemp[1]); //ten service
    		    cell.setCellStyle(style);
    		    
    		    cell = row.createCell(1);//cot 2
    		    cell.setCellValue(strTemp[0]); //ten server
    		    
    		    cell = row.createCell(2);//cot 3
    		    cell.setCellValue(this.get_toTRDT()); //lay ngay
    		    
    		    this.set_rowLines(this.get_rowLines()+1);
        	}
        }
	    		    		   	    		 		   		    
	    FileOutputStream out =
	        new FileOutputStream(new File(urlOutExcel));
	    workbook.write(out);
	    out.close();		
	}
	
	/**
	 * 
	 * @param typeServer
	 * @param urlFile
	 */
	public void writeArrServer(String typeServer, String urlFile){
		logger.info("writeArrServer: " + typeServer+ " url= " + urlFile);
		FileWriter fr;
		try {
			fr = new FileWriter(urlFile);
			BufferedWriter br = new BufferedWriter(fr);  
	        PrintWriter out = new PrintWriter(br);  
	        if (typeServer.equals("28")){
	        	for(int i=0; i<this.get_arrService28().length; i++){  
	 	           if(this.get_arrService28()[i] != null)     
	 	        	   out.write(this.get_arrService28()[i]);  
	 	           out.write("\n");         
	 	        } 
	        }
	        else if (typeServer.equals("29")){
	        	for(int i=0; i<this.get_arrService29().length; i++){  
	 	           if(this.get_arrService29()[i] != null)     
	 	        	   out.write(this.get_arrService29()[i]);  
	 	           out.write("\n");         
	 	        } 
	        }
	        else if (typeServer.equals("40")){
	        	for(int i=0; i<this.get_arrService40().length; i++){  
	 	           if(this.get_arrService40()[i] != null)     
	 	        	   out.write(this.get_arrService40()[i]);  
	 	           out.write("\n");         
	 	        } 
	        }
	        else{
	        	for(int i=0; i<this.get_arrService().length; i++){  
	 	           if(this.get_arrService()[i] != null)     
	 	        	   out.write(this.get_arrService()[i]);  
	 	           out.write("\n");         
	 	        } 
	        }
	        out.close();  
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}  
		logger.info("writeArrServer done");
        
	}
		
	
}
