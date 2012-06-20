package test.org.eib.view.statusline;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseMoveListener;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.ToolBar;
import org.eclipse.swt.widgets.ToolItem;

public class ToolItemStatusLine {

  static String statusText = "";

  public static void main(String[] args) {
    final Display display = new Display();
    Shell shell = new Shell(display);
    shell.setBounds(10, 10, 200, 200);
    final ToolBar bar = new ToolBar(shell, SWT.BORDER);
    bar.setBounds(10, 10, 150, 50);
    final Label statusLine = new Label(shell, SWT.BORDER);
    statusLine.setBounds(10, 90, 150, 30);
    new ToolItem(bar, SWT.NONE).setText("item 1");
    new ToolItem(bar, SWT.NONE).setText("item 2");
    new ToolItem(bar, SWT.NONE).setText("item 3");
    bar.addMouseMoveListener(new MouseMoveListener() {
      public void mouseMove(MouseEvent e) {
        ToolItem item = bar.getItem(new Point(e.x, e.y));
        String name = "";
        if (item != null) {
          name = item.getText();
        }
        if (!statusText.equals(name)) {
          statusLine.setText(name);
          statusText = name;
        }
      }
    });
    shell.open();
    while (!shell.isDisposed()) {
      if (!display.readAndDispatch())
        display.sleep();
    }
    display.dispose();
  }

}
