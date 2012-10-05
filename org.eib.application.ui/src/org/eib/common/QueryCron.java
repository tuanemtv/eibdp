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

import org.eib.database.Query;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class QueryCron {
	private String _cronNM;
	private String _jobNM;
	private String _jobClass;
	private String _jobGroup;
	private String _triggerNM;
	private String _triggerSchedule;
	private String _triggerGroup;
	private Query[] _query;
	
	
	public String get_cronNM() {
		return _cronNM;
	}
	public void set_cronNM(String _cronNM) {
		this._cronNM = _cronNM;
	}
	public String get_jobNM() {
		return _jobNM;
	}
	public void set_jobNM(String _jobNM) {
		this._jobNM = _jobNM;
	}
	public String get_jobClass() {
		return _jobClass;
	}
	public void set_jobClass(String _jobClass) {
		this._jobClass = _jobClass;
	}
	public String get_jobGroup() {
		return _jobGroup;
	}
	public void set_jobGroup(String _jobGroup) {
		this._jobGroup = _jobGroup;
	}
	public String get_triggerNM() {
		return _triggerNM;
	}
	public void set_triggerNM(String _triggerNM) {
		this._triggerNM = _triggerNM;
	}
	public String get_triggerSchedule() {
		return _triggerSchedule;
	}
	public void set_triggerSchedule(String _triggerSchedule) {
		this._triggerSchedule = _triggerSchedule;
	}
	public String get_triggerGroup() {
		return _triggerGroup;
	}
	public void set_triggerGroup(String _triggerGroup) {
		this._triggerGroup = _triggerGroup;
	}
	public Query[] get_query() {
		return _query;
	}
	public void set_query(Query[] _query) {
		this._query = _query;
	}
	
	public void getXMLToCron(String fileurl, String servernm, QueryCron _querycron[]) throws ParserConfigurationException, SAXException, IOException{
		File f = new File(fileurl);
		 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		 DocumentBuilder db = dbf.newDocumentBuilder();
		 Document doc = db.parse(f);

		  //Element root = doc.getDocumentElement();		
		  //System.out.println("getAttributes : " +root.getAttribute("id"));
		  NodeList list = doc.getElementsByTagName(servernm);
		  
		  for (int i = 0; i < list.getLength(); i++) {
			  _querycron[i] = new QueryCron();			  
			  Node node = list.item(i);
			  
			  if (node.getNodeType() == Node.ELEMENT_NODE) {
				 Element element = (Element) node;
				 NodeList nodelist = element.getElementsByTagName("cronNM");
				 Element element1 = (Element) nodelist.item(0);
				 NodeList fstNm = element1.getChildNodes();
				 _querycron[i].set_cronNM((fstNm.item(0)).getNodeValue());
				// System.out.println("\nqueryid : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("querynm");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_querynm((fstNm.item(0)).getNodeValue());
				 //System.out.println("querynm : " + (fstNm.item(0)).getNodeValue());
				 				
				 
				 nodelist = element.getElementsByTagName("module");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_module((fstNm.item(0)).getNodeValue());
				 //System.out.println("module : " + (fstNm.item(0)).getNodeValue());
				 
				 
				 nodelist = element.getElementsByTagName("getquery");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_getquery((fstNm.item(0)).getNodeValue());
				 //System.out.println("getquery : " + (fstNm.item(0)).getNodeValue());
				 
				 
				 //Add define
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
				 
				 //Doc duong dan file
				 nodelist = element.getElementsByTagName("fileurl");
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
						 _query[i].set_getquery(_query[i].get_getquery() + strLine+'\n');//Cong them 1 khoang trang de cau script dung	  
						 //System.out.println (strLine);
					 }
				 }
				 //System.out.println ("get Query = " + _query[i].get_getquery());				 
				  
				  //Lay status
				 nodelist = element.getElementsByTagName("status");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_status((fstNm.item(0)).getNodeValue());
				 //System.out.println("status : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("description");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_description((fstNm.item(0)).getNodeValue());
				 
				 
				 nodelist = element.getElementsByTagName("note");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 _query[i].set_note((fstNm.item(0)).getNodeValue());
				 
			  }
		  }
	}
}
