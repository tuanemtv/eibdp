package test.org.eib.xml;

import java.io.File;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class TutorialXML {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String strServer = null;
        String strName = null;
        String strUsername = null;
        String strPassword = null;
        
        try
        {
            //Doc du lieu tu tap tin DBConfig.xml
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.
                newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse(new File("D:/a.xml"));
            
            /* cach 1
            doc.getDocumentElement().normalize();
            NodeList databaseList = doc.getElementsByTagName("Database");
            Node databaseNode = databaseList.item(0);
            
            //Kiem tra mot node la element
            if (databaseNode.getNodeType() == Node.ELEMENT_NODE)
            {
                Element database = (Element)databaseNode;
                //Lay node Server
                NodeList serverList = database.getElementsByTagName("Server");
                Element server = (Element)serverList.item(0);
                Node sNode = server.getChildNodes().item(0);
                
                if (sNode != null)
                {
                    //this.txtServer.setText(sNode.getNodeValue());
                	System.out.println("Server = "+sNode.getNodeValue());
                }
                else
                {
                    //this.txtServer.setText("localhost");
                }
                //Lay node Name
                NodeList nameList = database.getElementsByTagName("Name");
                Element name = (Element)nameList.item(0);
                Node nNode = name.getChildNodes().item(0);
               
                if (nNode != null)
                {
                    //this.txtName.setText(nNode.getNodeValue());
                	System.out.println("Name = "+nNode.getNodeValue());
                }
                else
                {
                    //this.txtName.setText("QLSTK");
                }
                //Lay node Username
                NodeList usernameList = database.getElementsByTagName("Username");
                Element username = (Element)usernameList.item(0);
                Node uText = username.getChildNodes().item(0);
                
                
                if (uText != null)
                {
                    //this.txtUsername.setText(uText.getNodeValue());
                	System.out.println("Username = "+uText.getNodeValue());
                }
                else
                {
                    //this.txtUsername.setText("sa");
                }
                //Lay node Password
                NodeList passwordList = database.getElementsByTagName("Password");
                Element password = (Element)passwordList.item(0);
                Node pText = password.getChildNodes().item(0);
                
                if (pText != null)
                {
                   // this.txtPassword.setText(pText.getNodeValue());
                	System.out.println("Password = "+pText.getNodeValue());
                }
                else
                {
                    //this.txtPassword.setText("");
                }
            }*/
            
            Element  root = doc.getDocumentElement();
            Iterator elementIterator = ((Object) root).elementIterator();
            while(elementIterator.hasNext()){
              Element elmeent = (Element)elementIterator.next();
              System.out.println(element.getName());
            }
            
        }
        catch (Exception ex)
        {
            //this.txtServer.setText("localhost");
            //this.txtName.setText("QLSTK");
            //this.txtUsername.setText("sa");
            //this.txtPassword.setText("");
        }
        
	}

}
/*
 * <?xml version="1.0" encoding="utf-8" ?>
<Database>
<Server>localhost</Server>
<Name>QLSTK</Name>
<Username>sa</Username>
<Password></Password>
</Database>
*/
