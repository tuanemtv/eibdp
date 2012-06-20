package test.org.eib.xml;

import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class CreateXML {
	
	public static void main(String[] argv) throws Exception {
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder builder = factory.newDocumentBuilder();
	    DOMImplementation impl = builder.getDOMImplementation();
	    Document doc = impl.createDocument(null, null, null);
	    
	    Element e1 = doc.createElement("script");
	    doc.appendChild(e1);
	    Element e2 = doc.createElement("script1");
	    e1.appendChild(e2);
	    //e2.setAttribute("url", "http://www.domain.com");
	    
	    
	    DOMSource domSource = new DOMSource(doc);
	    Transformer transformer = TransformerFactory.newInstance().newTransformer();
	    transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
	    transformer.setOutputProperty(OutputKeys.METHOD, "xml");
	    transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
	    transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
	    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	    StringWriter sw = new StringWriter();
	    StreamResult sr = new StreamResult(sw);
	    transformer.transform(domSource, sr);
	    System.out.println(sw.toString());
	  }
}
