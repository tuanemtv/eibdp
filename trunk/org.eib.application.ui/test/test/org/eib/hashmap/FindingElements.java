package test.org.eib.hashmap;

import java.util.Hashtable;

public class FindingElements {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Hashtable<String, String> table = new Hashtable<String, String>();
	    table.put("key1", "value1");
	    table.put("key2", "value2");
	    table.put("key3", "value3");

	    System.out.println(table.containsKey("key3"));
	}

}
