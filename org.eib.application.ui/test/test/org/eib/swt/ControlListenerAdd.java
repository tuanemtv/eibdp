package test.org.eib.swt;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ControlEvent;
import org.eclipse.swt.events.ControlListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.RowLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

public class ControlListenerAdd {
  static int count = 0;

  public static void main(String[] args) {
    Display display = new Display();
    final Shell shell = new Shell(display);

    shell.setLayout(new RowLayout());

    final Composite composite = new Composite(shell, SWT.BORDER);
    composite.setLayout(new RowLayout());
    composite.setBackground(display.getSystemColor(SWT.COLOR_YELLOW));
    composite.addControlListener(new ControlListener() {
      public void controlMoved(ControlEvent e) {
      }

      public void controlResized(ControlEvent e) {
        System.out.println("Composite resize.");
      }
    });    
    
    Button buttonAdd = new Button(shell, SWT.PUSH);
    buttonAdd.setText("Add new button");
    buttonAdd.addSelectionListener(new SelectionAdapter() {
      public void widgetSelected(SelectionEvent e) {
        Button button = new Button(composite, SWT.PUSH);
        button.setText("Button #" + (count++));
        composite.layout(true);
        composite.pack();
      }
    });

    shell.setSize(450, 100);
    shell.open();

    while (!shell.isDisposed()) {
      if (!display.readAndDispatch()) {
        display.sleep();
      }
    }
    display.dispose();
  }
}