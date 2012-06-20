package test.org.eib.database;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.TreeMap;

import org.eib.database.Query;

public class TestQuery {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Query query = new Query();
		query.set_module("DP");
		query.set_queryid("script1");
		query.set_querynm("Test");
		query.set_getquery("select * from tbdp_Savmst where brcd = h_brcd and opndt = h_opndt");
		
		
		TreeMap<String, String> a1 = new TreeMap<String, String>();
		a1.put("h_brcd", "'2000'");
		a1.put("h_opndt", "'20120529'");
		query.set_define(a1);
		
		System.out.println("[1]_exquery"+query.get_exquery());
		query.setquery();
		System.out.println("[2]_exquery"+query.get_exquery());
		
		//String a="select * from tbdp_Savmst where brcd = h_brcd and opndt = h_opndt";
				
		//System.out.println("a="+a);
		/*
		//Lap lai chuoi/
		Set<Entry<String, String>> set = a1.entrySet();
		Iterator<Entry<String, String>> i = set.iterator();
		while(i.hasNext()) {
			Map.Entry me = i.next();
			
			a = a.replaceAll((String)me.getKey(), (String)me.getValue());
			
			System.out.println("a="+a);
			System.out.print(me.getKey() + ": ");
			System.out.println(me.getValue());
		}*/
		
		
		
	}

}
