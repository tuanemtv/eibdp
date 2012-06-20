package test.org.eib.Thread;

class XThread extends Thread {

	XThread() {
	}
	
	XThread(String threadName) {
		super(threadName); // Initialize thread.
		System.out.println(" XThread= "+this);
		start();
	}
	public void run() {
		//Display info about this particular thread
		System.out.println(" run = "+Thread.currentThread().getName());
	}
}
