package test.org.eib.Thread.Semaphore;


import java.util.*;import java.util.concurrent.*;

public class SemApp
{
	
    public static void main(String[] args)
    {
        Runnable limitedCall = new Runnable() {
            final Random rand = new Random();
            final Semaphore available = new Semaphore(5);
            int count = 0;
            
            public void run()
            {
                int time = rand.nextInt(15);
                int num = count++; //Dung cho mang
                
                try
                {
                    available.acquire();
                    
                    System.out.println("Executing " + "long-running action for " +  time + " seconds... #" + num);             
                    Thread.sleep(time * 500);
                    System.out.println("Done with #" + num + "!");

                    available.release();
                }
                catch (InterruptedException intEx)
                {
                    intEx.printStackTrace();
                }
            }
        };
        
        //Doc mang
        
        //Chay
        
        for (int i=0; i<20; i++)
            new Thread(limitedCall).start();
    }
}


