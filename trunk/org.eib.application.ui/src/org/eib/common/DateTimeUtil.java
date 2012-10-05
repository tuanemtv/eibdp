package org.eib.common;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {

	
	/**
	 * Lay thoi gian hien tai cua he thong 
	 * @return
	 */
	public static String getDateTime(){
		String _datetime="";
		
		DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss,dd/MM/yyyy");
		
		Date date = new Date();
		_datetime= dateFormat.format(date);
		return _datetime;		
	}
	
	/**
	 * Lay gio he thong theo dinh dang. 
	 * Ap dung cho TH tao file
	 * @return
	 */
	public static String getDateYYYYMMDD(){
		String _datetime="";
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
		
		Date date = new Date();
		_datetime= dateFormat.format(date);
		return _datetime;		
	}
}
