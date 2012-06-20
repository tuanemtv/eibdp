package test.org.eib.xml;
import java.io.*;
import org.w3c.dom.*;
import javax.xml.parsers.*;


public class readxmlfromafile {
	public static void main(String[] args) throws Exception {
		  File f = new File("D:\\database.xml");
		  DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		  DocumentBuilder db = dbf.newDocumentBuilder();
		  Document doc = db.parse(f);
		  new readxmlfromafile().read(doc,"Oralce-ALive");
	}

	public void read(Document doc, String server) {
		  Element root = doc.getDocumentElement();
		  NodeList list = doc.getElementsByTagName(server);
		  for (int i = 0; i < list.getLength(); i++) {
			  Node node = list.item(i);			  
			  if (node.getNodeType() == Node.ELEMENT_NODE) {
				 Element element = (Element) node;
				 NodeList nodelist = element.getElementsByTagName("driver");
				 Element element1 = (Element) nodelist.item(0);
				 NodeList fstNm = element1.getChildNodes();
				 System.out.println("driver : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("host");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 System.out.println("host : " + (fstNm.item(0)).getNodeValue());
				 				 
				 nodelist = element.getElementsByTagName("port");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 System.out.println("port : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("database");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 System.out.println("database : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("user");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 System.out.println("user : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("password");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 System.out.println("password : " + (fstNm.item(0)).getNodeValue());
				 
			  }
		  }
	}
}
