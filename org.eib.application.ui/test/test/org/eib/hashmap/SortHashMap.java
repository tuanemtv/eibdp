package test.org.eib.hashmap;

import java.util.*;

public class SortHashMap {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Map<String, String> yourMap = new HashMap<String, String>();
	    //yourMap.put("01", "one");
	    //yourMap.put("02", "two");
	    //yourMap.put("03", "three");
	    yourMap.put("01h_trdt", "20120608");
	    yourMap.put("02h_startdt", "20120601");
	    yourMap.put("03h_enddt", "20120531");
	    yourMap.put("04h_bstartdt", "20120601");
	    yourMap.put("05h_predt", "20120607");

	    Map<String, String> sortedMap = new TreeMap<String, String>(yourMap);
	    for (int i=0;i<sortedMap.size();i++){
	    	//sortedMap.
	    }
	    System.out.println(sortedMap);
	}	

}
