package test.org.eib.view.table;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ControlEditor;
import org.eclipse.swt.custom.TableCursor;
import org.eclipse.swt.events.KeyAdapter;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.swt.widgets.Text;

public class TableCursorTableEditor {
  public static void main(String[] args) {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setText("Table Cursor Test");

    shell.setLayout(new FillLayout());

    final Table table = new Table(shell, SWT.SINGLE | SWT.FULL_SELECTION);
    table.setHeaderVisible(true);
    table.setLinesVisible(true);

    for (int i = 0; i < 5; i++) {
      TableColumn column = new TableColumn(table, SWT.CENTER);
      column.setText("Column " + (i + 1));
      column.pack();
    }

    for (int i = 0; i < 5; i++) {
      new TableItem(table, SWT.NONE);
    }

    final TableCursor cursor = new TableCursor(table, SWT.NONE);

    final ControlEditor editor = new ControlEditor(cursor);
    editor.grabHorizontal = true;
    editor.grabVertical = true;

    cursor.addSelectionListener(new SelectionAdapter() {
      // This is called as the user navigates around the table
      public void widgetSelected(SelectionEvent event) {
        // Select the row in the table where the TableCursor is
        table.setSelection(new TableItem[] { cursor.getRow() });
      }

      // This is called when the user hits Enter
      public void widgetDefaultSelected(SelectionEvent event) {
        final Text text = new Text(cursor, SWT.NONE);
        text.setFocus();
        // Copy the text from the cell to the Text control
        text.setText(cursor.getRow().getText(cursor.getColumn()));
        text.setFocus();
        // Add a handler to detect key presses
        text.addKeyListener(new KeyAdapter() {
          public void keyPressed(KeyEvent event) {
            switch (event.keyCode) {
            case SWT.CR:
              cursor.getRow().setText(cursor.getColumn(), text.getText());
            case SWT.ESC:
              text.dispose();
              break;
            }
          }
        });
        editor.setEditor(text);
      }
    });

    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
      if (!display.readAndDispatch()) {
        display.sleep();
      }
    }
    display.dispose();
  }
}