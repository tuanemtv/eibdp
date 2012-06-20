package test.org.eib.database;

import java.util.HashMap;
import java.util.TreeMap;

import org.eib.database.Query;

public class TestMysql {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		Query query = new Query();
		query.set_module("DP");
		query.set_queryid("script1");
		query.set_querynm("Test");
		query.set_getquery("select * from athena.daily_stocks_transaction where idstock= h_idstock");
		
		
		TreeMap<String, String> a1 = new TreeMap<String, String>();
		a1.put("h_idstock", "'111'");
		//a1.put("h_opndt", "'20120529'");
		query.set_define(a1);
		
		System.out.println("[1]_exquery"+query.get_exquery());
		query.setquery();
		System.out.println("[2]_exquery"+query.get_exquery());
	}

}
