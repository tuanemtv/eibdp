package org.eib.application.ui.views;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.events.FocusAdapter;
import org.eclipse.swt.events.FocusEvent;
import org.eclipse.swt.events.DisposeListener;
import org.eclipse.swt.events.DisposeEvent;
import org.eclipse.swt.events.KeyAdapter;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.VerifyListener;
import org.eclipse.swt.events.VerifyEvent;
import org.eib.application.dialog.AppMessageBox;
import org.eib.application.dialog.AppStatusBar;

public class TestView extends ViewPart {

	public static final String ID = "org.eib.application.ui.views.TestView"; //$NON-NLS-1$
	private Text txt1;

	public TestView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		{
			Button btn1 = new Button(container, SWT.NONE);
			btn1.setBounds(191, 62, 75, 25);
			btn1.setText("New Button");
		}
		
		txt1 = new Text(container, SWT.BORDER);
		txt1.addVerifyListener(new VerifyListener() {
			public void verifyText(VerifyEvent e) {
				System.out.println("Su kien: verifyText");
			}
		});
		txt1.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetDefaultSelected(SelectionEvent e) {
				System.out.println("Su kien: widgetDefaultSelected");
			}
			@Override
			public void widgetSelected(SelectionEvent e) {
				System.out.println("Su kien: widgetSelected");
			}
		});
		txt1.addModifyListener(new ModifyListener() {
			public void modifyText(ModifyEvent e) {
				System.out.println("Su kien: modifyText");
			}
		});
		txt1.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				System.out.println("Su kien: keyPressed");
			}
			@Override
			public void keyReleased(KeyEvent e) {
				System.out.println("Su kien: keyReleased");
			}
		});
		txt1.addDisposeListener(new DisposeListener() {
			public void widgetDisposed(DisposeEvent e) {
				System.out.println("Su kien: widgetDisposed");
			}
		});
		txt1.addFocusListener(new FocusAdapter() {
			@Override
			public void focusLost(FocusEvent e) {
				System.out.println("Su kien: focusLost");
			}
		});
		txt1.setBounds(100, 66, 76, 21);
		
		Label lbl1 = new Label(container, SWT.NONE);
		lbl1.setBounds(26, 72, 55, 15);
		lbl1.setText("New Label");
		
		Button btnMessagebox = new Button(container, SWT.NONE);
		btnMessagebox.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				AppMessageBox messge = new AppMessageBox("Tieu de","Thong bao");
				messge.getErrorMessageBox();
				
				AppStatusBar.showStatusMessage("tuan em",true);
			}
		});
		btnMessagebox.setBounds(156, 120, 75, 25);
		btnMessagebox.setText("MessageBox");

		createActions();
		initializeToolBar();
		initializeMenu();
	}

	/**
	 * Create the actions.
	 */
	private void createActions() {
		// Create the actions
	}

	/**
	 * Initialize the toolbar.
	 */
	private void initializeToolBar() {
		IToolBarManager toolbarManager = getViewSite().getActionBars()
				.getToolBarManager();
	}

	/**
	 * Initialize the menu.
	 */
	private void initializeMenu() {
		IMenuManager menuManager = getViewSite().getActionBars()
				.getMenuManager();
	}

	@Override
	public void setFocus() {
		// Set the focus
	}
}
