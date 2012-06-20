package test.org.eib.xml;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class CreateXMLtoFile {

	/**
	 * @param args
	 * @throws ParserConfigurationException 
	 * @throws IOException 
	 * @throws TransformerException 
	 */
	public static void main(String[] args) throws ParserConfigurationException, IOException, TransformerException {
		// TODO Auto-generated method stub
		DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder domBuilder = domFactory.newDocumentBuilder();

	    Document newDoc = domBuilder.newDocument();
	    Element rootElement = newDoc.createElement("CSV2XML");
	    newDoc.appendChild(rootElement);

	    BufferedReader csvReader = new BufferedReader(new FileReader("csvFileName.txt"));
	    String curLine = csvReader.readLine();
	    String[] csvFields = curLine.split(",");
	    Element rowElement = newDoc.createElement("row");
	    for(String value: csvFields){
	      Element curElement = newDoc.createElement(value);
	      curElement.appendChild(newDoc.createTextNode(value));
	      rowElement.appendChild(curElement);
	      rootElement.appendChild(rowElement);
	    }
	    csvReader.close();
	    TransformerFactory tranFactory = TransformerFactory.newInstance();
	    Transformer aTransformer = tranFactory.newTransformer();
	    Source src = new DOMSource(newDoc);
	    Result dest = new StreamResult(new File("xmlFileName"));
	    aTransformer.transform(src, dest);
	}

}
