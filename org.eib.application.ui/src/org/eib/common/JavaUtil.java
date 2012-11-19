package org.eib.common;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.TreeMap;

import org.apache.log4j.Logger;

public class JavaUtil {

	private static Logger logger =Logger.getLogger("JavaUtil");
	
	/**
	 * Sort Hashmap
	 * @param unsortMap
	 * @return
	 */
	public static Map sortByComparator(Map unsortMap) {
		 
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
	
	/**
	 * Hien thi HashMap
	 * @param hm_temp
	 */
	public static void showHashMap(TreeMap<String, String> hm_temp){
		Set<Entry<String, String>> set = hm_temp.entrySet();
		// Get an iterator
		Iterator<Entry<String, String>> j = set.iterator();
		while(j.hasNext()) {
			Entry<String, String> me = j.next();
			//System.out.println(me.getKey() + ": "+me.getValue());			
			logger.info("Key["+me.getKey() + "] --> Value["+me.getValue()+"]");
		}
	}
	
	
	/**
	 * 
	 * @param k
	 * @return
	 */
	public static String showLogScript(long k){
		String _strDesign ="|         ";
		String _strReturn="";
		
		if (k<10){
			_strReturn = _strDesign.substring(0, 5)+String.valueOf(k)+_strDesign.substring(6, 10);
		}else if (k<100){
			_strReturn = _strDesign.substring(0, 4)+String.valueOf(k)+_strDesign.substring(6, 10);
		}else if (k<1000){
			_strReturn = _strDesign.substring(0, 4)+String.valueOf(k)+_strDesign.substring(7, 10);
		}else if (k<10000){
			_strReturn = _strDesign.substring(0, 3)+String.valueOf(k)+_strDesign.substring(7, 10);
		}
		
		return _strReturn;
	}
}
