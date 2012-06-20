package test.org.eib.swt;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.ProgressBar;
import org.eclipse.swt.widgets.Shell;

public class ProgressBarExample {
	
	
  public static void main(String[] args) {
	  
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new GridLayout());

    // Create a smooth ProgressBar
    ProgressBar pb1 = new ProgressBar(shell, SWT.HORIZONTAL | SWT.SMOOTH);
    pb1.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
    pb1.setMinimum(0);
    pb1.setMaximum(30);

    // Start the first ProgressBar
    new LongRunningOperation(display, pb1).start();

    shell.open();
    while (!shell.isDisposed()) {
      if (!display.readAndDispatch()) {
        display.sleep();
      }
    }
  }
}

