package test.org.eib.String;

import java.util.Iterator;
import java.util.Set;
import java.util.Map.Entry;

import org.eib.common.MainCommon;
import org.eib.common.QueryServer;
import org.eib.database.Query;

public class ReplaceString {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		MainCommon a =new MainCommon("app2");
		
		QueryServer _qurser = new QueryServer();
        Query _qur = new Query();
		_qurser = a.getQueryServerFromID("Oralce-AReport");                
        _qurser.connectDatabase();
        
        _qur = a.getQueryFromID("DEF001");
        _qur.queryToAppDefine(a.get_appcommon(), _qurser);
        
        
		String _exquery="";
		String _getquery="";
				
		_exquery = _getquery; 
		Set<Entry<String, String>> set = a.get_appcommon().get_define().entrySet();
		Iterator<Entry<String, String>> i = set.iterator();
		
		while(i.hasNext()) {
			Entry<String, String> me = i.next();
			//Chi & + tu ky tu thu 2(bo 01, 02..)
			System.out.println("a = "+me.getKey());
			System.out.println("b = "+"&"+(String)me.getKey().substring(2));
			System.out.println("getValue = "+(String)me.getValue());
			_exquery = _exquery.replaceAll("&"+(String)me.getKey().substring(2), (String)me.getValue());
		}
		
	}

}
