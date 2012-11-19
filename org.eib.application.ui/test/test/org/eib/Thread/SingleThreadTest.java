package test.org.eib.Thread;

import java.util.concurrent.*;
import java.util.*;
import java.text.*;
import java.io.*;

public class SingleThreadTest {

  public static void main(String[] args) {
    int nTasks = 10;
    int fib =5;
    SingleThreadAccess sta = new SingleThreadAccess();
    for (int i = 0; i < nTasks; i++)
      sta.invokeLater(new Task(fib, "Task " + i));
    sta.shutdown();
  }
}

class SingleThreadAccess {

  private ThreadPoolExecutor tpe;

  public SingleThreadAccess() {
        tpe = new ThreadPoolExecutor(
          1, 1, 50000L, TimeUnit.SECONDS,
          new LinkedBlockingQueue<Runnable>());
    }  public void invokeLater(Runnable r) {
    tpe.execute(r);
  }

  public void invokeAneWait(Runnable r) throws InterruptedException,
      ExecutionException {
    FutureTask task = new FutureTask(r, null);
    tpe.execute(task);
    task.get();
  }

  public void shutdown() {
    tpe.shutdown();
  }
}

class Task implements Runnable {
  long n;

  String id;

  private long fib(long n) {
    if (n == 0)
      return 0L;
    if (n == 1)
      return 1L;
    return fib(n - 1) + fib(n - 2);
  }

  public Task(long n, String id) {
    this.n = n;
    this.id = id;
  }

  public void run() {
    Date d = new Date();
    DateFormat df = new SimpleDateFormat("HH:mm:ss:SSS");
    long startTime = System.currentTimeMillis();
    d.setTime(startTime);
    System.out.println("Starting task " + id + " at " + df.format(d));
    
    fib(n);
    long endTime = System.currentTimeMillis();
    d.setTime(endTime);
    System.out.println("Ending task " + id + " at " + df.format(d)
        + " after " + (endTime - startTime) + " milliseconds");
    try {
		Thread.sleep(1000);
	} catch (InterruptedException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
  }
}