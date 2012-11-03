package test.org.eib.Date;

import java.text.*;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

public class TestDate {

	/**
	 * @param args
	 * @throws ParseException 
	 */
	public static void main(String[] args) throws ParseException {
		// TODO Auto-generated method stub
		DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss] dd/MM/yyyy");
		Date date = new Date();
		System.out.println(dateFormat.format(date));
		
		Date date2 = new Date();
		
		//System.out.println(date2.getSeconds() - date.getSeconds());
		
		 DateFormat df = DateFormat.getTimeInstance(DateFormat.MEDIUM);
		  df.setTimeZone(TimeZone.getTimeZone("GMT"));

		    //Date date1 = df.parse("10:00:00");
		    //Date date2 = df.parse("11:00:00");

		    long remainder = date2.getTime() - date.getTime();

		    System.out.println("Time Difference = "+df.format(remainder));
		    
		    Calendar ca1 = Calendar.getInstance();
		    
		    System.out.println(ca1.getTime());
		    
	}

}
