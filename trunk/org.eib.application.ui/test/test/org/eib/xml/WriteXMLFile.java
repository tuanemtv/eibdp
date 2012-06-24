package test.org.eib.xml;

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
 
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
 
public class WriteXMLFile {
 
	public static void main(String argv[]) {
 
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
		
		// staff elements
		Element staff = doc.createElement("Query");
		rootElement.appendChild(staff);
 
		// set attribute to staff element
		attr = doc.createAttribute("id");
		attr.setValue("LN01");
		staff.setAttributeNode(attr);
 
		// shorten way
		// staff.setAttribute("id", "1");
 
	
		Element firstname = doc.createElement("querynm");
		firstname.appendChild(doc.createTextNode("LN - 01. Khe uoc thay doi lai suat theo chu ky (ca nhan)"));
		staff.appendChild(firstname);
 
		// lastname elements
		Element lastname = doc.createElement("status");
		lastname.appendChild(doc.createTextNode("0"));
		staff.appendChild(lastname);
 
		// nickname elements
		Element nickname = doc.createElement("server");
		nickname.appendChild(doc.createTextNode("Oralce-AReport"));
		staff.appendChild(nickname);
 
		// salary elements
		Element salary = doc.createElement("module");
		salary.appendChild(doc.createTextNode("LN"));
		staff.appendChild(salary);
 
		
		

		// staff elements
		staff = doc.createElement("Query");
		rootElement.appendChild(staff);
 
		// set attribute to staff element
		attr = doc.createAttribute("id");
		attr.setValue("LN02");
		staff.setAttributeNode(attr);
 
		// shorten way
		// staff.setAttribute("id", "1");
 
	
		firstname = doc.createElement("querynm");
		firstname.appendChild(doc.createTextNode("LN - 01. Khe uoc thay doi lai suat theo chu ky (ca nhan)"));
		staff.appendChild(firstname);
 
		// lastname elements
		lastname = doc.createElement("status");
		lastname.appendChild(doc.createTextNode("0"));
		staff.appendChild(lastname);
 
		// nickname elements
		nickname = doc.createElement("server");
		nickname.appendChild(doc.createTextNode("Oralce-AReport"));
		staff.appendChild(nickname);
 
		// salary elements
		salary = doc.createElement("module");
		salary.appendChild(doc.createTextNode("LN"));
		staff.appendChild(salary);
 
		
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
	}
}