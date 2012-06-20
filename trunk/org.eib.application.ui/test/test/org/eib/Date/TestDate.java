package test.org.eib.Date;

import java.text.*;
import java.util.Date;

public class TestDate {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss] dd/MM/yyyy");
		Date date = new Date();
		System.out.println(dateFormat.format(date));
	}

}
