package test.org.eib.Date;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.text.SimpleDateFormat;

public class Test {
	public static void main(String[] args) throws Exception 
	{
		
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    Calendar c1 = Calendar.getInstance();
	    c1.set(1999, 0 , 20); // 1999 jan 20
	    
	    System.out.println("Date is : " + sdf.format(c1.getTime()));
	    c1.roll(Calendar.MONTH, false); // roll down, substract 1 month
	    System.out.println ("Date roll down 1 month : "+ sdf.format(c1.getTime()));

	    c1.set(1999, 0 , 20); // 1999 jan 20
	    System.out.println("Date is : " + sdf.format(c1.getTime()));
	    c1.add(Calendar.MONTH, -1); // substract 1 month
	    System.out.println
	      ("Date minus 1 month : "
	          + sdf.format(c1.getTime()));
	    /*
	     * output :
	     * Date is : 1999-01-20
	     * Date roll down 1 month : 1999-12-20
	     * Date is : 1999-01-20
	     * Date minus 1 month : 1998-12-20
	     */
	    
	    
	    Calendar now = Calendar.getInstance();
	    System.out.println("Current Date : " + (now.get(Calendar.MONTH) + 1) + "-"
	        + now.get(Calendar.DATE) + "-" + now.get(Calendar.YEAR));
	    System.out.println("Current time : " + now.get(Calendar.HOUR_OF_DAY) + ":"
	        + now.get(Calendar.MINUTE) + ":" + now.get(Calendar.SECOND));

	    now = Calendar.getInstance();
	    now.add(Calendar.HOUR, -3);
	    System.out.println("Time before 3 hours : " + now.get(Calendar.HOUR_OF_DAY) + ":"
	        + now.get(Calendar.MINUTE) + ":" + now.get(Calendar.SECOND));
	    
	    
	    
	    Calendar now2 = Calendar.getInstance();
	    System.out.println("aa: " +now2.get(Calendar.HOUR_OF_DAY));
	    
	    
	    SimpleDateFormat formater=new SimpleDateFormat("yyyy-MM-dd");

	    long d1=formater.parse("2001-1-1").getTime();
	    long d2=formater.parse("2001-1-2").getTime();

	    System.out.println(Math.abs((d1-d2)/(1000*60*60*24)));
	  
	    Date date1 = new Date();
	    Date date2= new Date();
	    
	    Calendar cal = Calendar.getInstance();
	    cal.setTime(date1);
	    int d11 ;
	    d11= cal.get(Calendar.DATE);

	    cal.setTime(date2);

	    int d21 = cal.get(Calendar.DATE);

	    //System.out.println(ca1.get(Calendar.DATE)-cal.get(Calendar.DATE));
	 }
}
