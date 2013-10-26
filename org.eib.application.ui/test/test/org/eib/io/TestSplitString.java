package test.org.eib.io;

public class TestSplitString {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String a="dpcd01;bs_dpdaccc20500";
		 String [] strTemp = a.split(";", 0);
		 for (int i=0; i<strTemp.length; i++){
			 System.out.println("i["+i+"]= "+strTemp[i]);
		 }
	}

}
