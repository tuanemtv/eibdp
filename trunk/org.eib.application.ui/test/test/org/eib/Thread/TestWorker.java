package test.org.eib.Thread;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class TestWorker {

	/**
	 * @param args
	 * @throws InterruptedException 
	 */
	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		int capacity = 10;
	    BlockingQueue<Integer> queue = new ArrayBlockingQueue<Integer>(capacity);

	    int numWorkers = 2;
	    Worker[] workers = new Worker[numWorkers];
	    for (int i = 0; i < workers.length; i++) {
	      workers[i] = new Worker(queue);
	      workers[i].start();
	    }

	    for (int i = 0; i < 100; i++) {
	      queue.put(i);
	    }
	  }

}
