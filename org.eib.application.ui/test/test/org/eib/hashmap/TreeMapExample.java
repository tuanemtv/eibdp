package test.org.eib.hashmap;

import java.util.*;

public class TreeMapExample{
	public static void main(String[] args) {
		System.out.println("Tree Map Example!\n");
		TreeMap <String, String>tMap = new TreeMap<String, String>();
		//Addding data to a tree map
		tMap.put("05h_predt", "20120607");
		tMap.put("01h_trdt", "20120608");
		tMap.put("02h_startdt", "20120601");
		tMap.put("03h_enddt", "20120531");
		tMap.put("04h_bstartdt", "20120601");
		
		
		/*
		//Rerieving all keys
		System.out.println("Keys of tree map: " + tMap.keySet());
		//Rerieving all values
		System.out.println("Values of tree map: " + tMap.values());
		//Rerieving the value from key with key number 5
		System.out.println("Key: 03h_enddt value: " + tMap.get("03h_enddt")+ "\n");
		//Rerieving the First key and its value
		System.out.println("First key: " + tMap.firstKey() + " Value: " + tMap.get(tMap.firstKey()) + "\n");
		//Rerieving the Last key and value
		System.out.println("Last key: " + tMap.lastKey() + " Value: " + tMap.get(tMap.lastKey()) + "\n");
		//Removing the first key and value
		System.out.println("Removing first data: " + tMap.remove(tMap.firstKey()));
		System.out.println("Now the tree map Keys: " + tMap.keySet());
		System.out.println("Now the tree map contain: " + tMap.values() + "\n");
		//Removing the last key and value
		System.out.println("Removing last data: " + tMap.remove(tMap.lastKey()));
		System.out.println("Now the tree map Keys: " + tMap.keySet());
		System.out.println("Now the tree map contain: " + tMap.values());
		*/
		
		Set set = tMap.entrySet();
		// Get an iterator
		Iterator i = set.iterator();
		// Display elements
		while(i.hasNext()) {
			Map.Entry me = (Map.Entry)i.next();
			System.out.print(me.getKey() + ": ");
			System.out.println(me.getValue());
		} 
		
	}
}