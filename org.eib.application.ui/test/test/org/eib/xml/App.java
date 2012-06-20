package test.org.eib.xml;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;

/**
 * Hello world!
 *
 */
public class App extends Thread
{
    private static final String xml = 
        "<Session>"
            + "<child1 attribute1=\"attribute1value\" attribute2=\"attribute2value\">"
            + "ChildText1</child1>"
            + "<child2 attribute1=\"attribute1value\" attribute2=\"attribute2value\">"
            + "ChildText2</child2>" 
            + "<child3 attribute1=\"attribute1value\" attribute2=\"attribute2value\">"
            + "ChildText3</child3>"
        + "</Session>";

    private static Document document;

    private static Element root;

    public static void main( String[] args ) throws DocumentException
    {
        document = DocumentHelper.parseText(xml);
        root = document.getRootElement();

        Thread t1 = new Thread(){
            public void run(){
                while(true){

                    try {
                        sleep(3);
                    } catch (InterruptedException e) {                  
                        e.printStackTrace();
                    }

                    Node n1 = root.selectSingleNode("/Session/child1");                 
                    if(!n1.getText().equals("ChildText1")){                     
                        System.out.println("WRONG!");
                    }
                }
            }
        };

        Thread t2 = new Thread(){
            public void run(){
                while(true){

                    try {
                        sleep(3);
                    } catch (InterruptedException e) {                  
                        e.printStackTrace();
                    }

                    Node n1 = root.selectSingleNode("/Session/child2");                 
                    if(!n1.getText().equals("ChildText2")){                     
                        System.out.println("WRONG!");
                    }
                }
            }
        };

        Thread t3 = new Thread(){
            public void run(){
                while(true){

                    try {
                        sleep(3);
                    } catch (InterruptedException e) {                  
                        e.printStackTrace();
                    }

                    Node n1 = root.selectSingleNode("/Session/child3");                 
                    if(!n1.getText().equals("ChildText3")){                     
                        System.out.println("WRONG!");
                    }
                }
            }
        };

        t1.start();
        t2.start();
        t3.start();
        System.out.println( "Hello World!" );
    }    

}
