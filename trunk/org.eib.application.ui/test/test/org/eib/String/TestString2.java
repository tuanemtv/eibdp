package test.org.eib.String;

public class TestString2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String t1="dfgdfg dfg;1 dfgdg;";
		String t2;
		
		t2 = t1.replaceAll(";", "");
		System.out.println(t2);
		
		long k;
		String t3= "|        |"; //10 ky ty
		String t4="";
		k = 9999;
		
		if (k<10){
			t4 = t3.substring(0, 5)+String.valueOf(k)+t3.substring(6, 10);
		}else if (k<100){
			t4 = t3.substring(0, 4)+String.valueOf(k)+t3.substring(6, 10);
		}else if (k<1000){
			t4 = t3.substring(0, 4)+String.valueOf(k)+t3.substring(7, 10);
		}else if (k<10000){
			t4 = t3.substring(0, 3)+String.valueOf(k)+t3.substring(7, 10);
		}
		
		
		System.out.println(t4);
	}

}
