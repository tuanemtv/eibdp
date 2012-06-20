package test.org.eib.xml;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;


public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String xmlFileName = "D:/a.xml";
	      String xPath = "//Root/@Address";
	      Document document = getDocument( xmlFileName );
	      List<Node> nodes = (List<Node>) document.selectNodes( xPath );
	      for (Node node : nodes)
	      {
	         String studentId = node.valueOf( "@studentId" );
	         System.out.println( "Student Id : " + studentId );
	      }
	}
	
	public static Document getDocument( final String xmlFileName )
	   {
	      Document document = null;
	      SAXReader reader = new SAXReader();
	      try
	      {
	         document = reader.read( xmlFileName );
	      }
	      catch (DocumentException e)
	      {
	         e.printStackTrace();
	      }
	      return document;
	   }
	

}
