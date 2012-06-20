package test.org.eib.swt;

import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.ProgressBar;

public class LongRunningOperation extends Thread {
	
	  private Display display;
	  private ProgressBar progressBar;

	  public LongRunningOperation(Display display, ProgressBar progressBar) {
	    this.display = display;
	    this.progressBar = progressBar;
	  }

	  public void run() {
	    for (int i = 0; i < 30; i++) {
	      try {
	        Thread.sleep(100);
	      } catch (InterruptedException e) {
	      }
	      
	      display.asyncExec(new Runnable() {
	        public void run() {
	          if (progressBar.isDisposed())
	            return;
	          progressBar.setSelection(progressBar.getSelection() + 1);
	        }
	      });
	    }
	  }
	}