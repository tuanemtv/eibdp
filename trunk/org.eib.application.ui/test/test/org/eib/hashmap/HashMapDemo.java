package test.org.eib.hashmap;

import java.util.*; 
import java.util.Map.Entry;

public class HashMapDemo {

	/**
	 * @param args
	 */
	public static void main(String args[]) {
		// Create a hash map
		HashMap<String, String> hm = new HashMap<String, String>();
		// Put elements to the map
		hm.put("&h_trdt", "20120608");
		hm.put("&h_startdt", "20120601");
		hm.put("&h_enddt", "20120531");
		hm.put("&h_bstartdt", "20120601");
		hm.put("&h_predt", "20120607");
		
		
		// Get a set of the entries
		Set<Entry<String, String>> set = hm.entrySet();
		// Get an iterator
		Iterator<Entry<String, String>> i = set.iterator();
		// Display elements
		while(i.hasNext()) {
			Map.Entry me = i.next();
			System.out.print(me.getKey() + ": ");
			System.out.println(me.getValue());
		}
		System.out.println();
		// Deposit 1000 into John Doe's account
		//double balance = hm.get("John Doe").doubleValue();
		//hm.put("John Doe", new Double(balance + 1000));
		//System.out.println("John Doe's new balance: " +
		//hm.get("John Doe"));
		} 

}
