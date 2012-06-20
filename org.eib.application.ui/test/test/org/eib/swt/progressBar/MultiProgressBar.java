package test.org.eib.swt.progressBar;

import org.eclipse.swt.*;
import org.eclipse.swt.custom.*;
import org.eclipse.swt.graphics.*;
import org.eclipse.swt.layout.*;
import org.eclipse.swt.widgets.*;

public class MultiProgressBar {
	public static void main (String [] args) {
		Display display = new Display ();
		ProgressBar progressBar;
		Label lbl;
		
		Shell shell = new Shell (display);
		shell.setSize(200, 500);
		//.setSize(132, 321);
		GridLayout gridLayout = new GridLayout ();
		shell.setLayout (gridLayout);

		Button button0 = new Button (shell, SWT.PUSH);
		button0.setText ("button0");
		
		Button button1 = new Button (shell, SWT.PUSH);
		button1.setText ("button1");
		
		Button button2 = new Button (shell, SWT.PUSH);
		button2.setText ("button2");
		
		for (int i =0; i<3; i++){
			lbl = new Label(shell, SWT.NONE);
			lbl.setText("i = "+i);
			progressBar = new ProgressBar(shell, SWT.SMOOTH);
		}
		 
		 
		shell.pack ();
		shell.open ();

		while (!shell.isDisposed ()) {
			if (!display.readAndDispatch ())
				display.sleep ();
		}
		display.dispose ();
	}
}
