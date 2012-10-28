package test.org.eib.ArrayQuartz;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
 
public class Job1 implements Job
{
	public void execute(JobExecutionContext context)
	throws JobExecutionException {
 
		System.out.println("Hello Job1");	
		
		DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss] dd/MM/yyyy");
		Date date = new Date();
		System.out.println(dateFormat.format(date));
		
		JobDataMap data = context.getJobDetail().getJobDataMap();
		//int count = data.getString("color");
		
		System.out.println("color = " + data.getString("color"));
		
		
 
	}
 
}