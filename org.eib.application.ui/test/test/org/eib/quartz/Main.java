package test.org.eib.quartz;

import org.quartz.JobBuilder;  
import org.quartz.JobDataMap;  
import org.quartz.JobDetail;  
import org.quartz.JobKey;  
import org.quartz.JobListener;  
import org.quartz.Scheduler;  
import org.quartz.SchedulerException;  
import org.quartz.SchedulerFactory;  
import org.quartz.SimpleScheduleBuilder;  
import org.quartz.Trigger;  
import org.quartz.TriggerBuilder;  
import org.quartz.impl.StdSchedulerFactory;  
import org.quartz.impl.matchers.KeyMatcher;  
  
public class Main {  
  
  @SuppressWarnings("unchecked")  
  public void run() {  
  
    // The state of the job.  
    JobContext jobContext = new JobContext();  
  
    // The value or transfer object provided by Quartz that contains the  
    // state of the job. Save it in JobDetail or Trigger.  
    JobDataMap jobDataMap = new JobDataMap();  
    jobDataMap.put("jobContext", jobContext);  
  
    // Create an identifier for the job.  
    JobKey jobKey = new JobKey("jobId", "jobGroup");  
  
    // Object that contains the job class and transfer object.  
    JobDetail jobDetail = JobBuilder.newJob(JobTask.class)  
            .withIdentity(jobKey).usingJobData(jobDataMap).build();  
  
    // Create the trigger that will instantiate and execute the job.  
    // Execute the job with a 5 seconds interval.  
    Trigger trigger = TriggerBuilder  
            .newTrigger()  
            .withIdentity("triggerId")  
            .withSchedule(  
                    SimpleScheduleBuilder.simpleSchedule()  
                            .withIntervalInSeconds(5).repeatForever())  
            .build();  
  
    // Setup a listener for the job.  
    JobListener jobListener = new JobTaskListener();  
  
    // Use the Quartz scheduler to schedule the job.  
    try {  
      SchedulerFactory schedulerFactory = new StdSchedulerFactory();  
      Scheduler scheduler = schedulerFactory.getScheduler();  
      scheduler.scheduleJob(jobDetail, trigger);  
  
      // Tell scheduler to listen for jobs with a particular key.  
      scheduler.getListenerManager().addJobListener(  
              jobListener,  
              KeyMatcher.keyEquals(jobKey));  
  
      // Start the scheduler after 5 seconds.  
      scheduler.startDelayed(5);  
    } catch (SchedulerException e) {  
      e.printStackTrace();  
    }  
  
    // Print the job state with a 3 seconds interval.  
    while (true) {  
      try {  
        System.out.println(jobContext.getState());  
        Thread.sleep(3000);  
      } catch (InterruptedException e) {  
        e.printStackTrace();  
      }  
    }  
  }  
  
  public static void main(String[] args) {  
    new Main().run();  
  }  
}  
