package test.org.eib.xml;

import java.util.Iterator;
import java.util.List;
 
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;


public class XMLReadExample {

	/**Read xml document using dom4j library
	 * @param args
	 */
	public static void main(String[] args) throws DocumentException {
        // Get the SAXReader object
        SAXReader reader = new SAXReader();
        // Get the xml document object by sax reader.
        Document document = reader.read("C:/person.xml");
        //String xpathExpression = "//company/person";
        //String xpathExpression = "C:\\";
        
        // Get the list of nodes on given xPath
        //List<Node> nodes = (List<Node>) document.selectNodes(xpathExpression);
 
        //Node id = document.selectSingleNode("personid");
        //System.out.println("Person Id : " + id.getText());
        
        // Read all the node inside xpath nodes and print the value of each
        /*
        for (Node node : nodes) {
            Node id = node.selectSingleNode("personid");
            System.out.println("Person Id : " + id.getText());
            Node name = node.selectSingleNode("name");
            System.out.println("Name : " + name.getText());
            Node age = node.selectSingleNode("age");
            System.out.println("Age : " + age.getText());
        }*/
        
        Element entryPoint = document.getRootElement();
        Element elem;
        for(Iterator iter = entryPoint.elements().iterator(); iter.hasNext();){
         elem = (Element)iter.next();
         System.out.println(elem.getName());
        }

    }
}
