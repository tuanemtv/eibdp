package test.org.eib.swt.List;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.*;
import org.eclipse.swt.widgets.*;
import org.eclipse.swt.layout.RowLayout;

public class ListExample {
 Display display = new Display();
 Shell shell = new Shell(display);
 List list;
 
 public ListExample() {
 RowLayout rowLayout = new RowLayout();
 shell.setLayout(rowLayout);
 shell.setText("List");
 
 Button btnNewButton = new Button(shell, SWT.NONE);
 btnNewButton.addSelectionListener(new SelectionAdapter() {
 	@Override
 	public void widgetSelected(SelectionEvent e) {
 		list.removeAll();
 	}
 });
 btnNewButton.setText("New Button");
 (new Label(shell, SWT.NULL)).setText("Which game you like most? ");
 
 list = new List(shell, SWT.MULTI |  SWT.V_SCROLL);
 final Text text = new Text(shell,  SWT.BORDER);
 String[] sports = new String[]{"Chess", "Cricket", "FootBall","Lawn Tennis","Badminton","Hockey","BasketBall","Golf","Table ", "Tennis","VolleyBall"};
 
 for(int i=0; i<sports.length; i++)
	 list.add(sports[i]);
 list.addSelectionListener(new SelectionListener() {
 
 public void widgetSelected(SelectionEvent e) {
	 System.err.println(list.getSelectionIndex());
	 int[] indices = list.getSelectionIndices();
	 String[] items = list.getSelection();
	 StringBuffer buffer = new StringBuffer(" ");
	 for(int i=0; i < indices.length; i++) {
		 buffer.append(items[i]);
		 if(i == indices.length-1)
			 buffer.append('.');
		 else
			 buffer.append(", ");
	 }
	 System.out.println(buffer.toString());
	 text.setText(buffer.toString());
 	}

 public void widgetDefaultSelected(SelectionEvent e) {
	 int[] indices = list.getSelectionIndices();
	 String[] items = list.getSelection();
	 StringBuffer buffer = new StringBuffer(" ");
	 for(int i=0; i < indices.length; i++) {
		 buffer.append(items[i]);
		 if(i == indices.length-1)
			 buffer.append('.');
		 else
			 buffer.append(", ");
	 }
	 System.out.println(buffer.toString());
	 text.setText(buffer.toString());
 	}
 });
 
 shell.pack();
 shell.setSize(350,180);
 shell.open();
 
 while (!shell.isDisposed()) {
 if (!display.readAndDispatch()) {
 display.sleep();
 }
 }
 display.dispose();
 }
 public static void main(String[] args) {
 new ListExample();
 }
}