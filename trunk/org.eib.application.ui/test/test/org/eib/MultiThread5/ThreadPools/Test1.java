package test.org.eib.MultiThread5.ThreadPools;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
 
 
//class Processor implements Runnable {
class Processor	extends Thread{
     
    private int id;
     
    public Processor(int id) {
        this.id = id;
    }
     
    public void run() {
        System.out.println("Starting: " + id);
         
        try {
            Thread.sleep(5000);
        	//Thread.sleep(1000);
        } catch (InterruptedException e) {
        }
         
        System.out.println("--> Completed: " + id);
    }
}

public class Test1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ExecutorService executor = Executors.newFixedThreadPool(4);
        
        for(int i=0; i<5; i++) {
            executor.submit(new Processor(i));
        }
         
        executor.shutdown();
         
        System.out.println("All tasks submitted.");
         
        try {
            executor.awaitTermination(1, TimeUnit.DAYS);
        } catch (InterruptedException e) {
        }
         
        System.out.println("All tasks completed.");
	}

}
