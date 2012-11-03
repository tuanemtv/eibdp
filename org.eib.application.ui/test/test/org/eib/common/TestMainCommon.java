package test.org.eib.common;

import org.eib.common.MainCommon;

public class TestMainCommon {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MainCommon a =new MainCommon("app");
		for (int i=0; i<a.get_query().length; i++){
			System.out.println("["+i+"]-----------------");
			a.get_query()[i].logQuery();
		}
		
		System.out.println("\n");
		
		a.sortQueryWithPriority();
		for (int i=0; i<a.get_query().length; i++){
			System.out.println("["+i+"]-----------------");
			a.get_query()[i].logQuery();
		}
		
	}

}
