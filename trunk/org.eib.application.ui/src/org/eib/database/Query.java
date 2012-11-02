package org.eib.database;

import java.io.*;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Set;
import java.util.Map.Entry;
import java.util.TreeMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eib.common.AppCommon;
import org.eib.common.FolderUtil;
import org.eib.common.JavaUtil;
import org.eib.common.QueryServer;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class Query {
	
	private static Logger logger =Logger.getLogger("Query");
	private String _queryid;
	private String _querynm;
	private String _queryouturl;
	private String _queryinurl;
	private String _status; //=0: chua lam gi, =1: bat dau xu ly, 2: dang xu ly, 7: fail, 8: 0k
	private String _module;
	private String _fileurl;
	private String _exquery;//Cau query thuc hien
	private String _getquery; //Cau query chua lam j	
	private String _startDate;
	private String _endDate;
	private String _description;
	private String _note;
	private int _countquery; //Tong so script
	private TreeMap<String, String> _define;
	private int _priority;
	
	
	public int get_priority() {
		return _priority;
	}

	public void set_priority(int _priority) {
		this._priority = _priority;
	}

	public int get_countquery() {
		return _countquery;
	}

	public void set_countquery(int _countquery) {
		this._countquery = _countquery;
	}

	public String get_description() {
		return _description;
	}

	public void set_description(String _description) {
		this._description = _description;
	}

	public String get_note() {
		return _note;
	}

	public void set_note(String _note) {
		this._note = _note;
	}
	
	public String get_startDate() {
		return _startDate;
	}

	public void set_startDate(String _startDate) {
		this._startDate = _startDate;
	}

	public String get_endDate() {
		return _endDate;
	}

	public void set_endDate(String _endDate) {
		this._endDate = _endDate;
	}	
		
	public String get_queryouturl() {
		return _queryouturl;
	}

	public void set_queryouturl(String _queryouturl) {
		this._queryouturl = _queryouturl;
	}

	public String get_queryinurl() {
		return _queryinurl;
	}

	public void set_queryinurl(String _queryinurl) {
		this._queryinurl = _queryinurl;
	}

	public String get_status() {
		return _status;
	}

	public void set_status(String _status) {
		this._status = _status;
	}

	public String get_fileurl() {
		return _fileurl;
	}

	public void set_fileurl(String _fileurl) {
		this._fileurl = _fileurl;
	}
	
	
	public Query() {
		super();
		this.set_define(new TreeMap<String, String>()) ;
		this.set_exquery("");
		this.set_getquery("");
		this.set_status("0");
		// TODO Auto-generated constructor stub
	}
	
	/**
	 * Diem so luong query duoc cau hinh
	 * @param _filepath
	 * @param _tagName
	 */
	public Query(String _filepath, String _tagName) {
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		try {
			docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.parse(_filepath);
			NodeList list = doc.getElementsByTagName(_tagName);
			this._countquery = list.getLength();
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}								
	}
	
	public String get_exquery() {
		return _exquery;
	}

	public String get_getquery() {
		return _getquery;
	}

	public void set_getquery(String _getquery) {
		this._getquery = _getquery;
	}
	
	public void set_exquery(String _exquery) {
		this._exquery = _exquery;
	}
	
	public Query(String _queryid,String _querynm,String _queryurl,String _module,TreeMap<String, String> _define) {
		this._queryid = _queryid;
		this._querynm = _querynm;
		this._queryouturl = _queryurl;
		this._module = _module;
		this._define = _define;
	}
	
	
	public String get_queryid() {
		return _queryid;
	}
	public void set_queryid(String _queryid) {
		this._queryid = _queryid;
	}
	public String get_querynm() {
		return _querynm;
	}
	public void set_querynm(String _querynm) {
		this._querynm = _querynm;
	}
	public String get_queryurl() {
		return _queryouturl;
	}
	public void set_queryurl(String _queryurl) {
		this._queryouturl = _queryurl;
	}
	public String get_module() {
		return _module;
	}
	public void set_module(String _module) {
		this._module = _module;
	}
	public TreeMap<String, String> get_define() {
		return _define;
	}
	public void set_define(TreeMap<String, String> _define) {
		this._define = _define;
	}
	
	/*
	 * Dung de map cac bien vao cau query
	 */
	public void setquery(){
		_exquery = _getquery; 
		Set<Entry<String, String>> set = _define.entrySet();
		Iterator<Entry<String, String>> i = set.iterator();
		
		while(i.hasNext()) {
			Entry<String, String> me = i.next();
			//Chi & + tu ky tu thu 2(bo 01, 02..)
			//System.out.println("a = "+me.getKey());
			//System.out.println("b = "+"&"+(String)me.getKey().substring(3));
			//System.out.println("getValue = "+(String)me.getValue());
			_exquery = _exquery.replaceAll("&"+(String)me.getKey().substring(3), (String)me.getValue());
		}
	}
	
	public void getXMLToScript(String fileurl, String servernm, Query _query[]) throws ParserConfigurationException, SAXException, IOException{
		File f = new File(fileurl);
		 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		 DocumentBuilder db = dbf.newDocumentBuilder();
		 Document doc = db.parse(f);

		  //Element root = doc.getDocumentElement();		
		  //System.out.println("getAttributes : " +root.getAttribute("id"));
		  NodeList list = doc.getElementsByTagName(servernm);
		  
		  for (int i = 0; i < list.getLength(); i++) {
			  _query[i] = new Query();			  
			  Node node = list.item(i);
			  
			  if (node.getNodeType() == Node.ELEMENT_NODE) {
				 Element element = (Element) node;
				 NodeList nodelist = element.getElementsByTagName("queryid");
				 Element element1 = (Element) nodelist.item(0);
				 NodeList fstNm = element1.getChildNodes();
				 _query[i].set_queryid((fstNm.item(0)).getNodeValue());
				// System.out.println("\nqueryid : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("querynm");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_querynm((fstNm.item(0)).getNodeValue());
				 //System.out.println("querynm : " + (fstNm.item(0)).getNodeValue());
				 
				 /*
				 nodelist = element.getElementsByTagName("queryouturl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set
				 System.out.println("queryouturl : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("queryinurl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.database = (fstNm.item(0)).getNodeValue();
				System.out.println("queryinurl : " + (fstNm.item(0)).getNodeValue());
				 
				 
				 nodelist = element.getElementsByTagName("status");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set
				 System.out.println("status : " + (fstNm.item(0)).getNodeValue());
				 */
				 
				 nodelist = element.getElementsByTagName("module");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_module((fstNm.item(0)).getNodeValue());
				 //System.out.println("module : " + (fstNm.item(0)).getNodeValue());
				 
				 /*
				 nodelist = element.getElementsByTagName("getquery");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_getquery((fstNm.item(0)).getNodeValue());
				 //System.out.println("getquery : " + (fstNm.item(0)).getNodeValue());
				 */
				 
				 //Add define
				 /*
				 TreeMap<String, String> hm_temp = new TreeMap<String, String>();
				 
				 nodelist = element.getElementsByTagName("define1");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define2");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define3");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+ element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define4");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define5");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define6");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define7");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define8");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define9");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 
				 nodelist = element.getElementsByTagName("define10");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 hm_temp.put('&'+element1.getAttribute("id"), (fstNm.item(0)).getNodeValue());
				 }
				 //Dua vao define
				 _query[i].set_define(hm_temp);
				 */
				 
				 //Doc duong dan file
				 nodelist = element.getElementsByTagName("fileurl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes(); 
				 _query[i].set_fileurl((fstNm.item(0)).getNodeValue());
				 
				 /* 20121027 - chua doc file
				 if ((fstNm.item(0)).getNodeValue().trim().length()!=0)
				 {
					 FileInputStream fstream = new FileInputStream((fstNm.item(0)).getNodeValue());
					 // Get the object of DataInputStream
					 DataInputStream in = new DataInputStream(fstream);
					 BufferedReader br = new BufferedReader(new InputStreamReader(in));
					 String strLine;
					 while ((strLine = br.readLine()) != null)   {	
						 //Neu bat dau bang select thi moi them vao.
						 _query[i].set_getquery(_query[i].get_getquery() + strLine+'\n');//Cong them 1 khoang trang de cau script dung	  
						 //System.out.println (strLine);
					 }
				 }*/
				 //System.out.println ("get Query = " + _query[i].get_getquery());				 
				  
				  //Lay status
				 /*
				 nodelist = element.getElementsByTagName("status");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_status((fstNm.item(0)).getNodeValue());
				 //System.out.println("status : " + (fstNm.item(0)).getNodeValue());
				 */
				 
				 if (element.getElementsByTagName("description") != null) { //xem lai
					 nodelist = element.getElementsByTagName("description");
				 	element1 = (Element) nodelist.item(0);
				 	fstNm = element1.getChildNodes();
				 	_query[i].set_description((fstNm.item(0)).getNodeValue());
				 }else{
					 logger.error("description is null");
				 }
				 
				 nodelist = element.getElementsByTagName("note");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_note((fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("priority");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_priority(Integer.parseInt((fstNm.item(0)).getNodeValue()));
				 
			  }
		  }
	}
	
	/**
	 * Ghi doi tuong Query ra file XML
	 * @param _query
	 * @param _urlfile
	 */
	public void WriteScriptToXML(Query[] _query, String _urlfile){
		
	}
	
	/**
	 * Doc duong dan script
	 */
	public void readScript(){
		
		FileInputStream fstream;
		try {
			fstream = new FileInputStream(this.get_fileurl());
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
			while ((strLine = br.readLine()) != null)   {	
				//Neu bat dau bang select thi moi them vao.
				this.set_getquery(this.get_getquery() + strLine+'\n');//Cong them 1 khoang trang de cau script dung	  
				 //System.out.println (strLine);
			}			 
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		 // Get the object of DataInputStream
		catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		 
	}
	
	/**
	 * Thuc hien query to Excel
	 * @param _app
	 * @param _queryser
	 */
	public void queryToExcel(AppCommon _app, QueryServer _queryser){
		Date date ;
		
		DateFormat dateFormat;
		
		this.set_fileurl(_app.get_scriptUrl()+this.get_fileurl());
		//doc file
		this.readScript();		
		this.set_define(_app.get_define());
		this.setquery();//Set lai cau script lay
		
		dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");		
		date= new Date();
		this.set_startDate(dateFormat.format(date));
		
		try {
			CommandQuery.set_Excelrow(_app.get_excelrows());//so dong excel
			CommandQuery.commandQueryExcel(_queryser.get_conn(), this.get_exquery(),true,false, _app.get_outurl_excel(this.get_querynm()));
			date= new Date();
			this.set_endDate(dateFormat.format(date));
			
			logger.info("S["+this.get_startDate()+"], E["+this.get_endDate()+"]. Query successful: "+this.get_querynm()+ " with url: "+_app.get_outurl_excel(this.get_querynm()));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			date= new Date();
			this.set_endDate(dateFormat.format(date));
			logger.error("S["+this.get_startDate()+"], E["+this.get_endDate()+"]. Query Fail: "+ e.getMessage());
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			date= new Date();
			this.set_endDate(dateFormat.format(date));
			logger.error("S["+this.get_startDate()+"], E["+this.get_endDate()+"]. Query Fail: "+ e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			date= new Date();
			this.set_endDate(dateFormat.format(date));
			logger.error("S["+this.get_startDate()+"], E["+this.get_endDate()+"]. Query Fail: "+ e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * Tai function cho Dababase
	 * @param _app
	 * @param _queryser
	 */
	public void queryToFunctions(AppCommon _app, QueryServer _queryser){
		Date date ;		
		DateFormat dateFormat;
		
		//Bat buoc
		this.set_fileurl(_app.get_scriptUrl()+this.get_fileurl());//Lay duong dan he thong cau hinh
		this.readScript();//doc file	
		this.set_define(_app.get_define());
		this.setquery();//Set lai cau script lay
		
		dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");		
		date= new Date();
		this.set_startDate(dateFormat.format(date));
		CommandQuery.commandFunctions(_queryser.get_conn(), this.get_exquery());
		date= new Date();
		this.set_endDate(dateFormat.format(date));
		
		logger.info("S["+this.get_startDate()+"], E["+this.get_endDate()+"]. Execute script successful with name: "+this.get_querynm());
		
	}
	
	
	/**
	 * Lay gia tri dua vao define cua App
	 * @param _app
	 * @param _queryser
	 */
	public void queryToAppDefine(AppCommon _app, QueryServer _queryser){
		Date date ;		
		DateFormat dateFormat;
		
		//Bat buoc
		this.set_fileurl(_app.get_scriptUrl()+this.get_fileurl());//Lay duong dan he thong cau hinh
		this.readScript();//doc file		
		this.set_define(_app.get_define());
		this.setquery();//Set lai cau script lay - Lay define cua Query (neu cau set lai define cua Appcomon)
		this.logQuery();
		
		dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");		
		date= new Date();
		this.set_startDate(dateFormat.format(date));
		_app.set_define(CommandQuery.queryGetVar(_queryser.get_conn(), this.get_exquery()));
		date= new Date();
		this.set_endDate(dateFormat.format(date));
		
		logger.info("S["+this.get_startDate()+"], E["+this.get_endDate()+"]. queryToAppDefine successful with name: "+this.get_querynm());
		
	}
	
	/*
	 * Log cho Query
	 */
	public void logQuery(){		
		if (this.get_countquery() != 0)
			logger.info("_countquery: "+this.get_countquery());
		if (this.get_queryid() != null)
			logger.info("_queryid: "+this.get_queryid());
		if (this.get_querynm() != null)
			logger.info("_querynm: "+this.get_querynm());
		if (this.get_queryouturl() != null)
			logger.info("_queryouturl: "+this.get_queryouturl());
		if (this.get_queryinurl() != null)
			logger.info("_queryinurl: "+this.get_queryinurl());
		if (this.get_status() != null)
			logger.info("_status: "+this.get_status());
		if (this.get_module() != null)
			logger.info("_module: "+this.get_module());
		if (this.get_fileurl() != null)
			logger.info("_fileurl: "+this.get_fileurl());
		if (this.get_exquery() != null)
			logger.info("_exquery: "+this.get_exquery());
		if (this.get_getquery() != null)
			logger.info("_getquery: "+this.get_getquery());
		if (this.get_startDate() != null)
			logger.info("_startDate: "+this.get_startDate());
		if (this.get_endDate() != null)
			logger.info("_endDate: "+this.get_endDate());
		if (this.get_description() != null)
			logger.info("_description: "+this.get_description());
		if (this.get_note() != null)
			logger.info("_note: "+this.get_note());
		if (this.get_priority() != 0)
			logger.info("_priority: "+this.get_priority());
		
		JavaUtil.showHashMap(this.get_define());
	}
	
}
