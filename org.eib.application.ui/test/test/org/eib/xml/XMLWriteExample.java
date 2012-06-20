package test.org.eib.xml;

import java.io.FileOutputStream;
import java.io.IOException;
 
import org.dom4j.Document;
import org.dom4j.DocumentFactory;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

public class XMLWriteExample {

	/**Write xml document using dom4j library
	 * @param args
	 */
	public static void main(String[] args) throws IOException {
        Document document = DocumentFactory.getInstance().createDocument();
        // Create the root element of xml file
        Element root = document.addElement("person");
        // Add some attributes to root element.
        root.addAttribute("attributeName", "attributeValue");
        // Add the element name in root element.
        Element name = root.addElement("name");
        name.addText("Mahendra");
        // Add the element age in root element.
        Element age = root.addElement("age");
        age.addText("29");
        // Create a file named as person.xml
        FileOutputStream fos = new FileOutputStream("person.xml");
        // Create the pretty print of xml document.
        OutputFormat format = OutputFormat.createCompactFormat();
        // Create the xml writer by passing outputstream and format
        XMLWriter writer = new XMLWriter(fos, format);
        // Write to the xml document
        writer.write(document);
        // Flush after done
        writer.flush();
    }
}
/*
 * <?xml version="1.0" encoding="UTF-8"?>
	<person attributeName="attributeValue">
      <name>Mahendra</name>
      <age>29</age>
	</person>
 */
