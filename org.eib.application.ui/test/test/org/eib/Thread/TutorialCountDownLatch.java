package test.org.eib.Thread;

import java.util.concurrent.CountDownLatch;

public class TutorialCountDownLatch {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		CountDownLatch cdl = new CountDownLatch(6);
	    new MyThread(cdl);
	   
	    try {
	      cdl.await();
	      
	    } catch (InterruptedException exc) {
	      System.out.println(exc);
	    }
	    System.out.println("Done");
	  }
	

}
