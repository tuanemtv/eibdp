package test.org.eib.hashmap;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
 
//Map ---> List ---> Sort ---> Map

public class SortMapExample{
 
   public static void main(String[] args) {
 
	System.out.println("Unsort Map......");
	HashMap<String,String> unsortMap = new HashMap<String,String>();
	unsortMap.put("01h_trdt", "20120608");
	unsortMap.put("02h_startdt", "20120601");
	unsortMap.put("03h_enddt", "20120531");
	unsortMap.put("04h_bstartdt", "20120601");
	unsortMap.put("05h_predt", "20120607");
	//unsortMap.put("6", "c");
	//unsortMap.put("7", "b");
	//unsortMap.put("8", "a");
 
	Iterator<Entry<String, String>> iterator=unsortMap.entrySet().iterator();
 
        for (Map.Entry entry : unsortMap.entrySet()) {
        	System.out.println("Key : " + entry.getKey() 
       			+ " Value : " + entry.getValue());
        }
 
        System.out.println("Sorted Map......");
        Map<String,String> sortedMap =  sortByComparator(unsortMap);
 
        for (Map.Entry entry : sortedMap.entrySet()) {
        	System.out.println("Key : " + entry.getKey() 
       			+ " Value : " + entry.getValue());
        }
   }
 
   private static Map sortByComparator(Map unsortMap) {
 
        List list = new LinkedList(unsortMap.entrySet());
 
        //sort list based on comparator
        Collections.sort(list, new Comparator() {
             public int compare(Object o1, Object o2) {
	           return ((Comparable) ((Map.Entry) (o1)).getValue())
	           .compareTo(((Map.Entry) (o2)).getValue());
             }
	});
 
        //put sorted list into map again
	Map sortedMap = new LinkedHashMap();
	for (Iterator it = list.iterator(); it.hasNext();) {
	     Map.Entry entry = (Map.Entry)it.next();
	     sortedMap.put(entry.getKey(), entry.getValue());
	}
	return sortedMap;
   }	
}