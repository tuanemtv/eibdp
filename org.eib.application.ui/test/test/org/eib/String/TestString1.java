package test.org.eib.String;

public class TestString1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String str1 = "Cron02.S3";
		String str2 = "S3";
		
		String str3 = "Cron02";
		
		if (str1.equals("Cron02."+str2)){
			System.out.println("Bang nhau");
		}
		
		System.out.println(str1.substring(0,6));
		System.out.println(str1.substring(7));
		
		if (str3.equals(str1.substring(0,6))){
			System.out.println("Bang nhau 2");
		}
	}

}
