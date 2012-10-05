package test.org.eib.quartz;

import java.util.Date;  

import org.quartz.DisallowConcurrentExecution;  
import org.quartz.Job;  
import org.quartz.JobExecutionContext;  
import org.quartz.JobExecutionException;  
  
// Disallow running multiple jobs based on this class at the same time.  
@DisallowConcurrentExecution  
public class JobTask implements Job {  
  
  @Override  
  public void execute(JobExecutionContext executionContext)  
          throws JobExecutionException {  
  
    // It's a good idea to wrap the entire body in a try-block, in order to  
    // catch every exception thrown.  
    try {  
      // Retrieve the state object.  
      JobContext jobContext = (JobContext) executionContext  
            .getJobDetail().getJobDataMap().get("jobContext");  
  
      // Update state.  
      jobContext.setState(new Date().toString());  
  
      // This is just a simulation of something going wrong.  
     int number = 0;  
     number = 123 / number;  
    } catch (Exception e) {  
      throw new JobExecutionException(e);  
    }  
  }  
}  