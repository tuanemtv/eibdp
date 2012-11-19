package test.org.eib.Thread;

import java.util.concurrent.BlockingQueue;

public class Worker extends Thread {
	  BlockingQueue<Integer> q;

	  Worker(BlockingQueue<Integer> q) {
	    this.q = q;
	  }

	  public void run() {
	    try {
	      while (true) {
	        Integer x = q.take();
	        if (x == null) {
	          break;
	        }
	        System.out.println(x);
	      }
	    } catch (InterruptedException e) {
	    }
	  }
	}