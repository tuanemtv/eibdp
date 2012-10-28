package org.eib.common;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.TreeMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class AppCommon {
	private static Logger logger =Logger.getLogger("AppCommon");
	
	private String _inurl; //Duong dan nhap file
	private String _outurl; //Duong dan xuat file
	private int _excelrows;//So dong trong 1 sheet cua file
	private int _scriptnums;//So script duoc chay cung 1 luc
	private int _scriptcount;
	private String _h_trdt; //Ngay de tao thu muc
	private TreeMap<String, String> _define;
	private TreeMap<String, String> _definenm; //Define co cot ten
	private String _defscripturl; //Duong dan ngay he thong
	private String _defscript ="";
	
	private String _defscripturl2; //duong dan ngay truyen vao
	private String _defscript2 ="";
		

	private String _ftpServer;
	private String _ftpUsr;
	private String _ftpPass;
	private String _ftpFilename;
	private String _ftpUrl;
	private String _ftpInurl;
	private String _servernm;
	private String _srcFTPServer;
	private String _srcFTPUser;
	private String _srcFTPPass;
	private String _srcFTPSerUrl;
	private String _srcFTPCliUrl;
	private String _srcFTPExtFile;
	private String _srcDate;
	
	private String _scriptUrl;
	private String _logUrl;
	private String _configureUrl;//Duong dan luu file cau hinh		
	
	public String get_scriptUrl() {
		return _scriptUrl;
	}

	public void set_scriptUrl(String _scriptUrl) {
		this._scriptUrl = _scriptUrl;
	}

	public String get_logUrl() {
		return _logUrl;
	}

	public void set_logUrl(String _logUrl) {
		this._logUrl = _logUrl;
	}

	
	public String get_srcFTPServer() {
		return _srcFTPServer;
	}

	public void set_srcFTPServer(String _srcFTPServer) {
		this._srcFTPServer = _srcFTPServer;
	}

	public String get_srcFTPUser() {
		return _srcFTPUser;
	}

	public void set_srcFTPUser(String _srcFTPUser) {
		this._srcFTPUser = _srcFTPUser;
	}

	public String get_srcFTPPass() {
		return _srcFTPPass;
	}

	public void set_srcFTPPass(String _srcFTPPass) {
		this._srcFTPPass = _srcFTPPass;
	}

	public String get_srcFTPSerUrl() {
		return _srcFTPSerUrl;
	}

	public void set_srcFTPSerUrl(String _srcFTPSerUrl) {
		this._srcFTPSerUrl = _srcFTPSerUrl;
	}

	public String get_srcFTPCliUrl() {
		return _srcFTPCliUrl;
	}

	public void set_srcFTPCliUrl(String _srcFTPCliUrl) {
		this._srcFTPCliUrl = _srcFTPCliUrl;
	}

	public String get_srcFTPExtFile() {
		return _srcFTPExtFile;
	}

	public void set_srcFTPExtFile(String _srcFTPExtFile) {
		this._srcFTPExtFile = _srcFTPExtFile;
	}

	public String get_srcDate() {
		return _srcDate;
	}

	public void set_srcDate(String _srcDate) {
		this._srcDate = _srcDate;
	}

	public String get_servernm() {
		return _servernm;
	}

	public void set_servernm(String _servernm) {
		this._servernm = _servernm;
	}

	public String get_h_trdt() {
		return _h_trdt;
	}

	public void set_h_trdt(String _h_trdt) {
		this._h_trdt = _h_trdt;
	}	
	
	public TreeMap<String, String> get_definenm() {
		return _definenm;
	}
	
	public void set_definenm(TreeMap<String, String> hm_tempnm) {
		this._definenm = hm_tempnm;
	}	
	
	public TreeMap<String, String> get_define() {
		return _define;
	}
	public void set_define(TreeMap<String, String> hm_temp) {
		this._define = hm_temp;
	}
	public int get_scriptcount() {
		return _scriptcount;
	}
	public void set_scriptcount(int _scriptcount) {
		this._scriptcount = _scriptcount;
	}

	
	/**
	 * Lay so luong script trong file xml 
	 * @param _scriptXMlUrl
	 * @throws ParserConfigurationException 
	 * @throws IOException 
	 * @throws SAXException 
	 */
	public void set_scriptcount(String _scriptXMlUrl) throws ParserConfigurationException, SAXException, IOException{
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.parse(_scriptXMlUrl);
 
		NodeList list = doc.getElementsByTagName("Query");
		
		this._scriptcount = list.getLength();
	}
	
	public String get_defscripturl2() {
		return _defscripturl2;
	}

	public void set_defscripturl2(String _defscripturl2) {
		this._defscripturl2 = _defscripturl2;
	}

	public String get_defscript2() {
		return _defscript2;
	}

	public void set_defscript2(String _defscript2) {
		this._defscript2 = _defscript2;
	}
	
	public String get_configureurl() {
		return _configureUrl;
	}
	public void set_configureurl(String _configureurl) {
		this._configureUrl = _configureurl;
	}
	public int get_scriptnums() {
		return _scriptnums;
	}
	public void set_scriptnums(int _scriptnums) {
		this._scriptnums = _scriptnums;
	}
	public String get_inurl() {
		return _inurl;
	}
	public void set_inurl(String _inurl) {
		this._inurl = _inurl;
	}
	public String get_outurl() {
		return _outurl;
	}
	public void set_outurl(String _outurl) {
		this._outurl = _outurl;
	}
	public int get_excelrows() {
		return _excelrows;
	}
	public void set_excelrows(int _excelrows) {
		this._excelrows = _excelrows;
	}
	
	public String get_inurl_excel(String _filename){
		return this._inurl + _filename +".xls";
	}
	
	/**
	 * Lay duong dan out file xls
	 * @param _filename: Ten file xls
	 * @return
	 */
	public String get_outurl_excel(String _filename){
		//Tao thu muc va set duong dan moi				
		return this._outurl + _filename +".xls";
	}
	
	public String get_defscripturl() {
		return _defscripturl;
	}

	public void set_defscripturl(String _defscripturl) {
		this._defscripturl = _defscripturl;
	}

	public String get_defscript() {
		return _defscript;
	}

	public void set_defscript(String _defscript) {
		this._defscript = _defscript;
	}
	
	
	public String get_ftpServer() {
		return _ftpServer;
	}

	public void set_ftpServer(String _ftpServer) {
		this._ftpServer = _ftpServer;
	}

	public String get_ftpUsr() {
		return _ftpUsr;
	}

	public void set_ftpUsr(String _ftpUsr) {
		this._ftpUsr = _ftpUsr;
	}

	public String get_ftpPass() {
		return _ftpPass;
	}

	public void set_ftpPass(String _ftpPass) {
		this._ftpPass = _ftpPass;
	}

	public String get_ftpFilename() {
		return _ftpFilename;
	}

	public void set_ftpFilename(String _ftpFilename) {
		this._ftpFilename = _ftpFilename;
	}

	public String get_ftpUrl() {
		return _ftpUrl;
	}

	public void set_ftpUrl(String _ftpUrl) {
		this._ftpUrl = _ftpUrl;
	}

	public String get_ftpInurl() {
		return _ftpInurl;
	}

	public void set_ftpInurl(String _ftpInurl) {
		this._ftpInurl = _ftpInurl;
	}

	public void getAppCom(String fileurl, String servernm) throws ParserConfigurationException, SAXException, IOException{
		 File f = new File(fileurl);
		 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		 DocumentBuilder db = dbf.newDocumentBuilder();
		 Document doc = db.parse(f);
	  
		  NodeList list = doc.getElementsByTagName(servernm);
		  for (int i = 0; i < list.getLength(); i++) {
			  Node node = list.item(i);			  
			  if (node.getNodeType() == Node.ELEMENT_NODE) {
				  
				 //Duong dan lay file
				 Element element = (Element) node;
				 NodeList nodelist = element.getElementsByTagName("inurl");
				 Element element1 = (Element) nodelist.item(0);
				 NodeList fstNm = element1.getChildNodes();
				 this._inurl = (fstNm.item(0)).getNodeValue();
				 
				 //Duong dan out file
				 nodelist = element.getElementsByTagName("outurl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._outurl = (fstNm.item(0)).getNodeValue();
				 
				 //so dong trong sheet excel
				 nodelist = element.getElementsByTagName("excelrows");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._excelrows = Integer.parseInt((fstNm.item(0)).getNodeValue());
				 
				 //so luong script chay
				 nodelist = element.getElementsByTagName("scriptnums");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._scriptnums = Integer.parseInt((fstNm.item(0)).getNodeValue());
				 //logger.info("scriptnums: "+this.get_scriptnums());
					
				 //Duong dan luu file cau hinh
				 nodelist = element.getElementsByTagName("configureurl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._configureUrl = (fstNm.item(0)).getNodeValue();
				 
				 //tong so script chay
				 nodelist = element.getElementsByTagName("scriptcount");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._scriptcount = Integer.parseInt((fstNm.item(0)).getNodeValue());
				 
				 //Add define
				 TreeMap<String, String> hm_temp = new TreeMap<String, String>();				 
				 TreeMap<String, String> hm_tempnm = new TreeMap<String, String>();
				 nodelist = element.getElementsByTagName("define1");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
					 this._h_trdt = (fstNm.item(0)).getNodeValue();//Ngay
				 }
				 
				 nodelist = element.getElementsByTagName("define2");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define3");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define4");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define5");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define6");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define7");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define8");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define9");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 
				 nodelist = element.getElementsByTagName("define10");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put(element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
					 hm_tempnm.put(element1.getAttribute("id"),"["+element1.getAttribute("name")+"]");
				 }
				 //Dua vao define
				 this.set_define(hm_temp);
				 this.set_definenm(hm_tempnm);
				 
				 //show hashmap
				 //JavaUtil.showHashMap(hm_temp);
				 //JavaUtil.showHashMap(hm_tempnm); 
				
				//Set lai duong dan xuat file
				//this._outurl  = this._outurl + this._h_trdt;
				
				//Tao folder
				//FolderUtil.createFolder(this._outurl);
				
				//Lay thong tin FTP
				//ftpserver
				 nodelist = element.getElementsByTagName("ftpserver");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._ftpServer = (fstNm.item(0)).getNodeValue();
				 logger.info("_ftpServer: "+this.get_ftpServer());
				 
				 //ftpuser
				 nodelist = element.getElementsByTagName("ftpuser");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._ftpUsr = (fstNm.item(0)).getNodeValue();
				 
				 //ftppass
				 nodelist = element.getElementsByTagName("ftppass");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._ftpPass = (fstNm.item(0)).getNodeValue();
				 
				//ftpfilename
				 nodelist = element.getElementsByTagName("ftpfilename");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._ftpFilename = (fstNm.item(0)).getNodeValue();
				 
				//ftpurl
				 nodelist = element.getElementsByTagName("ftpurl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._ftpUrl = (fstNm.item(0)).getNodeValue();
				 
				//ftpinturl
				 nodelist = element.getElementsByTagName("ftpinturl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._ftpInurl = (fstNm.item(0)).getNodeValue();
				 
				 
				 //Doc duong dan file
				 /*
				 nodelist = element.getElementsByTagName("defscripturl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 FileInputStream fstream = new FileInputStream((fstNm.item(0)).getNodeValue());
					 // Get the object of DataInputStream
					 DataInputStream in = new DataInputStream(fstream);
					 BufferedReader br = new BufferedReader(new InputStreamReader(in));
					 String strLine;
					 while ((strLine = br.readLine()) != null)   {	
						 //Neu bat dau bang select thi moi them vao.
						 //_query[i].set_getquery(_query[i].get_getquery() + strLine+'\n');//Cong them 1 khoang trang de cau script dung
						 //this._defscript = this._defscript + strLine+'\n';
						 this.set_defscript(this.get_defscript()+ strLine+'\n');
						 //System.out.println (strLine);
					 }
					 //System.out.println (this._defscript);
				 }
				 
				 //Doc duong dan file di bien truyen vao
				 nodelist = element.getElementsByTagName("defscripturl2");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 FileInputStream fstream = new FileInputStream((fstNm.item(0)).getNodeValue());
					 // Get the object of DataInputStream
					 DataInputStream in = new DataInputStream(fstream);
					 BufferedReader br = new BufferedReader(new InputStreamReader(in));
					 String strLine;
					 while ((strLine = br.readLine()) != null)   {	
						 //Neu bat dau bang select thi moi them vao.
						 //_query[i].set_getquery(_query[i].get_getquery() + strLine+'\n');//Cong them 1 khoang trang de cau script dung
						 //this._defscript = this._defscript + strLine+'\n';
						 this.set_defscript2(this.get_defscript2()+ strLine+'\n');
						 //System.out.println (strLine);
					 }
					 //System.out.println (this._defscript);
				 }*/
				 
				//servernm
				 nodelist = element.getElementsByTagName("servernm");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._servernm = (fstNm.item(0)).getNodeValue();
				 
				 //_srcFTPServer
				 nodelist = element.getElementsByTagName("srcFTPServer");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._srcFTPServer = (fstNm.item(0)).getNodeValue();
				 
				 //_srcFTPUser
				 nodelist = element.getElementsByTagName("srcFTPUser");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._srcFTPUser = (fstNm.item(0)).getNodeValue();
				 
				 //_srcFTPPass
				 nodelist = element.getElementsByTagName("srcFTPPass");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._srcFTPPass = (fstNm.item(0)).getNodeValue();
				 
				 //_srcFTPSerUrl
				 nodelist = element.getElementsByTagName("srcFTPSerUrl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._srcFTPSerUrl = (fstNm.item(0)).getNodeValue();
				 
				 //_srcFTPCliUrl
				 nodelist = element.getElementsByTagName("srcFTPCliUrl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._srcFTPCliUrl = (fstNm.item(0)).getNodeValue();
				 
				 //_srcFTPExtFile
				 nodelist = element.getElementsByTagName("srcFTPExtFile");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._srcFTPExtFile = (fstNm.item(0)).getNodeValue();
				 
				 //_srcDate
				 nodelist = element.getElementsByTagName("srcDate");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this._srcDate = (fstNm.item(0)).getNodeValue();
			  }
		  }
   }
	
	
	public void seth_trdt(String _h_trdt){
		//_exquery = _exquery.replaceAll("&"+(String)me.getKey().substring(2), (String)me.getValue());
		_defscript2 = _defscript2.replaceAll("&h_trdt", _h_trdt);
	}
	
	
	public void logAppCommon(){
		if (this.get_inurl() != null)
			logger.info("_inurl: "+this.get_inurl());
		if (this.get_outurl() != null)
			logger.info("_outurl: "+ this.get_outurl());
		if (this.get_excelrows() != 0)
			logger.info("_excelrows: "+this.get_excelrows());
		if (this.get_scriptnums() != 0)
			logger.info("_scriptnums: "+this.get_scriptnums());
		if (this.get_scriptcount() != 0)
			logger.info("_scriptcount: "+this.get_scriptcount());	
		if (this.get_h_trdt() != null)
			logger.info("_h_trdt: "+this.get_h_trdt());		
		
		//private TreeMap<String, String> _define;
		//private TreeMap<String, String> _definenm; //Define co cot ten
		if (this.get_defscripturl() != null)
			logger.info("_defscripturl: "+this.get_defscripturl());		
		if (this.get_defscript() != null)
			logger.info("_defscript: "+this.get_defscript());	
		if (this.get_defscripturl2() != null)
			logger.info("_defscripturl2: "+this.get_defscripturl2());
		if (this.get_defscript2() != null)
			logger.info("_defscript2: "+this.get_defscript2());
		if (this.get_configureurl() != null)
			logger.info("_configureurl: "+this.get_configureurl());	
		if (this.get_scriptUrl() != null)
			logger.info("_scriptUrl: "+this.get_scriptUrl());
		if (this.get_logUrl() != null)
			logger.info("_logUrl: "+this.get_logUrl());
		if (this.get_ftpServer() != null)
			logger.info("_ftpServer: "+this.get_ftpServer());
		if (this.get_ftpUsr() != null)
			logger.info("_ftpUsr: "+this.get_ftpUsr());
		if (this.get_ftpPass() != null)
			logger.info("_ftpPass: "+this.get_ftpPass());
		if (this.get_ftpFilename() != null)
			logger.info("_ftpFilename: "+this.get_ftpFilename());
		if (this.get_ftpUrl() != null)
			logger.info("_ftpUrl: "+this.get_ftpUrl());
		if (this.get_ftpInurl() != null)	
			logger.info("_ftpInurl: "+this.get_ftpInurl());
		if (this.get_servernm() != null)
			logger.info("_servernm: "+this.get_servernm());
		if (this.get_srcFTPServer() != null)
			logger.info("_srcFTPServer: "+this.get_srcFTPServer());
		if (this.get_srcFTPUser() != null)
			logger.info("_srcFTPUser: "+this.get_srcFTPUser());
		if (this.get_srcFTPPass() != null)
			logger.info("_srcFTPPass: "+this.get_srcFTPPass());	
		if (this.get_srcFTPSerUrl() != null)
			logger.info("_srcFTPSerUrl: "+this.get_srcFTPSerUrl());
		if (this.get_srcFTPCliUrl() != null)
			logger.info("_srcFTPCliUrl: "+this.get_srcFTPCliUrl());
		if (this.get_srcFTPExtFile() != null)
			logger.info("_srcFTPExtFile: "+this.get_srcFTPExtFile());
		if (this.get_srcDate() != null)
			logger.info("_srcDate: "+this.get_srcDate());	
	}	
	
}
