package test.org.eib.database;

import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;

import org.eib.common.QueryServer;
import org.xml.sax.SAXException;

public class TestQueryServer2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		QueryServer queryser =new QueryServer();
		try {
			queryser.getServer("D:\\database.xml","MySQL-test");
			
			System.out.println("[1] driver : " + queryser.getDriver());
			System.out.println("[1] host : " + queryser.getHost());
			System.out.println("[1] port : " + queryser.getPort());
			System.out.println("[1] database : " + queryser.getDatabase());
			System.out.println("[1] user : " + queryser.getUser());
			System.out.println("[1] password : " + queryser.getPassword());
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
