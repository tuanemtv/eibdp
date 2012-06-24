package test.org.eib.application.control;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eib.application.control.ScrollingLabel;


public class ScrollingLabelDemo {
	
	private static final String H_TEXT = "A very long text message that will be shown";
	private static final String V_TEXT = "In a Galaxy\nFar Far\nBlah Blah\nMore text\nCredits:\nNext Row etc\n";
	
	public static void main(String[] args) {
		final Display display = new Display();
		final Shell shell = getShell(display);
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
	}

	public static Shell getShell(Display display){
		final Shell shell = new Shell(display);
		shell.setText("Scrolling Text Demo");
		shell.setLayout(new GridLayout());
		new ScrollingLabelDemo(shell);
		shell.setLocation(Display.getDefault().getBounds().width/2 - 100,
				Display.getDefault().getBounds().height/2 - 50);
		shell.open();
		shell.pack();
		shell.setSize(230, 150);
		return shell;
	}
	
	public ScrollingLabelDemo(Shell shell){
		final Composite composite = new Composite(shell,SWT.NONE);
		composite.setLayout(new GridLayout(2,false));
		composite.setLayoutData(new GridData(SWT.FILL,SWT.FILL,true,true));

		new Label(composite,SWT.NONE).setText("Horizontal:");
		final ScrollingLabel label = new ScrollingLabel(composite,SWT.H_SCROLL);	
		label.setLayoutData(new GridData(SWT.FILL,SWT.BEGINNING,true,false));
		label.setBackground(Display.getDefault().getSystemColor(SWT.COLOR_WHITE));
		label.setText(H_TEXT);
		
		new Label(composite,SWT.NONE).setText("Vertical:");
		final ScrollingLabel labelV = new ScrollingLabel(composite,SWT.V_SCROLL|SWT.BORDER);	
		labelV.setLayoutData(new GridData(SWT.FILL,SWT.FILL,true,true));
		labelV.setBackground(Display.getDefault().getSystemColor(SWT.COLOR_WHITE));
		labelV.setText(V_TEXT);
	}
}
