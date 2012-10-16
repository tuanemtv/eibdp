package test.org.eib.ArrayQuartz;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
 
public class Job2 implements Job
{
	public void execute(JobExecutionContext context)
	throws JobExecutionException {
 
		System.out.println("Hello Job1");	
		
		DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss] dd/MM/yyyy");
		Date date = new Date();
		System.out.println(dateFormat.format(date));
		
 
	}
 
}