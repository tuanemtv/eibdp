package test.org.eib.MultiThread1.Starting;

public class Runner implements Runnable  {
	 @Override
	    public void run() {
	        for(int i=0; i<5; i++) {
	            System.out.println("Hello: " + i);
	             
	            try {
	                Thread.sleep(100);
	            } catch (InterruptedException e) {
	                // TODO Auto-generated catch block
	                e.printStackTrace();
	            }
	        }
	         
	    }
	     
	}

