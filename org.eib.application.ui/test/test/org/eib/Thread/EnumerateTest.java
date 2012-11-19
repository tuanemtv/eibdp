package test.org.eib.Thread;

class EnumerateTest {
	  public void listCurrentThreads() {
	    ThreadGroup currentGroup = Thread.currentThread().getThreadGroup();
	    int numThreads = currentGroup.activeCount();
	    Thread[] listOfThreads = new Thread[numThreads];

	    
	    currentGroup.enumerate(listOfThreads);
	    for (int i = 0; i < numThreads; i++)
	      System.out.println("Thread #" + i + " = "
	          + listOfThreads[i].getName());
	    
	    //listOfThreads[i].isAlive()
	  }
	}