package test.org.eib.Thread;

import java.util.concurrent.CountDownLatch;

class MyThread2 implements Runnable {
	  String name;

	  CountDownLatch latch;

	  MyThread2(CountDownLatch c, String n) {
	    latch = c;
	    name = n;
	    new Thread(this);
	  }

	  public void run() {
	    for (int i = 0; i < 5; i++) {
	    	System.out.println(this.name+" ="+i);
	      latch.countDown();
	    }
	  }
	}