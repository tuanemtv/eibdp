package test.org.eib.database;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
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

public class TestQueryXML {

	/**
	 * @param args
	 * @throws IOException 
	 * @throws SAXException 
	 * @throws ParserConfigurationException 
	 */
	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException {
		// TODO Auto-generated method stub
		//get("D:\\script.xml","Query");
		Query qur = new Query();
		Query[] qur2 = new Query[2];
		
		qur.getXMLToScript("D:\\script.xml", "Query", qur2);
		
		for (int i=0; i<2;i++){
			System.out.println("\n[1] queryid : " + qur2[i].get_queryid());
			System.out.println("[1] querynm : " + qur2[i].get_querynm());
			System.out.println("[1] module : " + qur2[i].get_module());
			System.out.println("[1] getquery : " + qur2[i].get_getquery());
			qur2[i].setquery();
			
			TreeMap<String, String> hm_temp = new TreeMap<String, String>();
			hm_temp =qur2[i].get_define();
			Set<Entry<String, String>> set = hm_temp.entrySet();
			// Get an iterator
			Iterator<Entry<String, String>> j = set.iterator();
			while(j.hasNext()) {
				Map.Entry me = j.next();
				System.out.print(me.getKey() + ": ");
				System.out.println(me.getValue());
			}
			
			System.out.println("[1] exequery : " + qur2[i].get_exquery());
		}
	}
	
	public static void get(String fileurl, String servernm) throws ParserConfigurationException, SAXException, IOException{
		 File f = new File(fileurl);
		 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		 DocumentBuilder db = dbf.newDocumentBuilder();
		 Document doc = db.parse(f);

		  Element root = doc.getDocumentElement();		
		  System.out.println("getAttributes : " +root.getAttribute("id"));
		  
		  NodeList list = doc.getElementsByTagName(servernm);
		  
		  for (int i = 0; i < list.getLength(); i++) {
			  Node node = list.item(i);			  
			  if (node.getNodeType() == Node.ELEMENT_NODE) {
				 Element element = (Element) node;
				 NodeList nodelist = element.getElementsByTagName("queryid");
				 Element element1 = (Element) nodelist.item(0);
				 NodeList fstNm = element1.getChildNodes();
				 //this.driver = (fstNm.item(0)).getNodeValue();
				 System.out.println("\nqueryid : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("querynm");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.host = (fstNm.item(0)).getNodeValue();
				 System.out.println("querynm : " + (fstNm.item(0)).getNodeValue());
				 				 
				 nodelist = element.getElementsByTagName("queryouturl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.port = Integer.parseInt((fstNm.item(0)).getNodeValue());
				 System.out.println("queryouturl : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("queryinurl");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.database = (fstNm.item(0)).getNodeValue();
				System.out.println("queryinurl : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("status");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.user = (fstNm.item(0)).getNodeValue();
				 System.out.println("status : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("module");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.password = (fstNm.item(0)).getNodeValue().trim();
				 System.out.println("module : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("define1");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.password = (fstNm.item(0)).getNodeValue().trim();
				 System.out.println("define1 : " + (fstNm.item(0)).getNodeValue());				 
				 System.out.println("name : " +  element1.getAttribute("name"));
				 System.out.println("id : " +  element1.getAttribute("id"));
				
				 
				 nodelist = element.getElementsByTagName("define2");
				 if (nodelist != null)
				 {	 
					 element1 = (Element) nodelist.item(0);
					 fstNm = element1.getChildNodes();
					 //this.password = (fstNm.item(0)).getNodeValue().trim();
					 System.out.println("define2 : " + (fstNm.item(0)).getNodeValue());				 
					 System.out.println("name : " +  element1.getAttribute("name"));
					 System.out.println("id : " +  element1.getAttribute("id"));
				 }
			  }
		  }
   }
	
}
