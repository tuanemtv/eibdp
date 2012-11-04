package test.org.eib.Date;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TestDate2 {
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Date d1 = new Date();
		Date d2 = new Date();
		System.out.println((d2.getTime()-d1.getTime())/1000);
		
		
		System.out.println(Math.abs(d2.getTime()-d1.getTime())/1000);
	}
}
