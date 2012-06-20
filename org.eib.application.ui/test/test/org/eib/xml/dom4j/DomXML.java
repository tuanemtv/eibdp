package test.org.eib.xml.dom4j;

import java.util.Iterator;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class DomXML
{
Document doc;
Element root;
public DomXML(){}
public void printXML() throws org.dom4j.DocumentException
{
SAXReader reader=new SAXReader();
doc=reader.read("D:\test.xml");
root=doc.getRootElement();
for(
Iterator iter=(Iterator)root.elementIterator("Database");iter.hasNext();)
{
Element ele=(Element)iter.next();
System.out.println(ele.getText()+ele.getName());
}

}
public static void main(String []arg) throws org.dom4j.DocumentException
{
DomXML dxml=new DomXML();
dxml.printXML();
}
}