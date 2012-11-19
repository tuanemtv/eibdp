package test.org.eib.Thread;

import java.util.concurrent.CountDownLatch;

public class MyThread implements Runnable {
	  CountDownLatch latch;
	   
	  MyThread(CountDownLatch c) {
	    latch = c;
	    new Thread(this).start();
	  }
	   
	  public void run() {
	    for(int i = 0; i<6; i++) {
	      System.out.println(i);
	      latch.countDown(); // decrement count
	    }
	  }
	}
