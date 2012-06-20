package test.org.eib.swt.progressBar;

import org.eclipse.swt.SWT;
import org.eclipse.swt.browser.Browser;
import org.eclipse.swt.browser.ProgressEvent;
import org.eclipse.swt.browser.ProgressListener;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.ProgressBar;
import org.eclipse.swt.widgets.Shell;

public class BrowserProgress {
  public static void main(String[] args) {
    Display display = new Display();
    Shell shell = new Shell(display);

    
    Browser browser = new Browser(shell, SWT.NONE);
    browser.setBounds(5,5,600,600);

    final ProgressBar progressBar = new ProgressBar(shell, SWT.NONE);
    progressBar.setBounds(5,650,600,20);
    
    browser.addProgressListener(new ProgressListener() {
      public void changed(ProgressEvent event) {
          if (event.total == 0) return;                            
          int ratio = event.current * 100 / event.total;
          progressBar.setSelection(ratio);
      }
      public void completed(ProgressEvent event) {
        progressBar.setSelection(0);
      }
    });

    
    browser.setUrl("http://www.vogella.com");    
    shell.open();

    while (!shell.isDisposed()) {
      if (!display.readAndDispatch())
        display.sleep();
    }
    display.dispose();
  }
}