package test.org.eib.xml;

import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
 
import org.apache.log4j.Logger;
import org.eib.database.Query;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;
 
public class WriteXMLFile {
	private static Query[] _query;
	private static Logger logger =Logger.getLogger("WriteXMLFile");
	
	public static void main(String argv[]) {
 
		
		Query qur = new Query();//luc khoi dau lay duoc gia tri ko?
		_query = new Query[123];
		
		
		try {
			qur.getXMLToScript("D:\\Query to Excel\\Congifure\\script.xml", "Query", _query);
			
			try {
				 
				DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
				DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		 
				// root elements
				Document doc = docBuilder.newDocument();
				Element rootElement = doc.createElement("ScriptCommon");
				doc.appendChild(rootElement);
	
				Attr attr = doc.createAttribute("id");
				attr.setValue("All Script	");
				rootElement.setAttributeNode(attr);
				
				Element eleTemp;
				
				for (int i=0; i< _query.length; i++){
					logger.info("["+(i+1)+"] queryid: " + _query[i].get_queryid()+", name: "+_query[i].get_querynm());
					_query[i].setquery();
						
					// staff elements
					Element staff = doc.createElement("Query");
					rootElement.appendChild(staff);
			 
					// set attribute to staff element
					attr = doc.createAttribute("id");
					attr.setValue(_query[i].get_queryid());
					staff.setAttributeNode(attr);
			 
					// shorten way
					// staff.setAttribute("id", "1");
				
					eleTemp = doc.createElement("queryid");
					eleTemp.appendChild(doc.createTextNode(_query[i].get_queryid()));
					staff.appendChild(eleTemp);
			 
					
					eleTemp = doc.createElement("querynm");
					eleTemp.appendChild(doc.createTextNode(_query[i].get_querynm()));
					staff.appendChild(eleTemp);
			 
					eleTemp = doc.createElement("status");
					eleTemp.appendChild(doc.createTextNode(_query[i].get_status()));
					staff.appendChild(eleTemp);
					
					eleTemp = doc.createElement("module");
					eleTemp.appendChild(doc.createTextNode(_query[i].get_module()));
					staff.appendChild(eleTemp);
					/*
					eleTemp = doc.createElement("fileurl");
					eleTemp.appendChild(doc.createTextNode(_query[i].get_fileurl()));
					staff.appendChild(eleTemp);*/
					/*
					eleTemp = doc.createElement("description");
					eleTemp.appendChild(doc.createTextNode(_query[i].get_description()));
					staff.appendChild(eleTemp);
					
					eleTemp = doc.createElement("note");
					eleTemp.appendChild(doc.createTextNode(_query[i].get_note()));
					staff.appendChild(eleTemp);
					*/
					
				}
				// write the content into xml file
				TransformerFactory transformerFactory = TransformerFactory.newInstance();
				Transformer transformer = transformerFactory.newTransformer();
				DOMSource source = new DOMSource(doc);
				StreamResult result = new StreamResult(new File("D:\\test.xml"));
		 
				// Output to console for testing
				// StreamResult result = new StreamResult(System.out);
		 
				transformer.transform(source, result);
		 
				System.out.println("File saved!");
		 
			  } catch (ParserConfigurationException pce) {
				pce.printStackTrace();
			  } catch (TransformerException tfe) {
				tfe.printStackTrace();
			  }	
			//System.out.println("> Load script Done. With= "+_query.length+" scripts");
		} catch (ParserConfigurationException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return;	
		} catch (SAXException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return;	
		} catch (IOException e1) {
			// TODO Auto-generated catch block

			e1.printStackTrace();
			return;	
		}
		
		
	 
	}
}