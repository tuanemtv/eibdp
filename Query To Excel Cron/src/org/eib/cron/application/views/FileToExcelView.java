package org.eib.cron.application.views;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.DirectoryDialog;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.ModifyEvent;

public class FileToExcelView extends ViewPart {

	public static final String ID = "org.eib.cron.application.views.FileToExcelView"; //$NON-NLS-1$
	private Text txtFile;
	private Text txtFolder;
	private static Button btnFile;
	private static Button btnFolder;
	private static Combo cboChoice;
	private Text txtOutFolder;
	private static Combo cboDBA;
	private static Combo cboDefine;
	public FileToExcelView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(final Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		container.setLayout(null);
		{
			cboChoice = new Combo(container, SWT.NONE);
			cboChoice.addModifyListener(new ModifyListener() {
				public void modifyText(ModifyEvent e) {
					if (cboChoice.getText().equals("File")){
						btnFile.setEnabled(true);
						btnFolder.setEnabled(false);
					}
					else if (cboChoice.getText().equals("Folder")){
						btnFile.setEnabled(false);
						btnFolder.setEnabled(true);
					}
				}
			});
			cboChoice.setItems(new String[] {"File", "Folder"});
			cboChoice.setBounds(10, 10, 100, 23);
		}
		
		txtFile = new Text(container, SWT.BORDER);
		txtFile.setEnabled(false);
		txtFile.setBounds(55, 36, 384, 21);
		
		Label lblFile = new Label(container, SWT.NONE);
		lblFile.setBounds(10, 39, 36, 15);
		lblFile.setText("File");
		
		btnFile = new Button(container, SWT.NONE);
		btnFile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				FileDialog  dlg = new FileDialog (parent.getShell());

			      // Set the initial filter path according
			      // to anything they've selected or typed in
			      dlg.setFilterPath(txtFile.getText());
			      // Change the title bar text
			      dlg.setText("Chon script");
			      dlg.setFileName("*.sql");
			      // Customizable message displayed in the dialog
			      //dlg.setMessage("Chon duong dan.");

			      // Calling open() will open and run the dialog.
			      // It will return the selected directory, or
			      // null if user cancels
			      String dir = dlg.open();
			      if (dir != null) {
			        // Set the text box to the new selection
			    	  txtFile.setText(dir);
			      }
			}
		});
		btnFile.setBounds(445, 34, 36, 25);
		btnFile.setText("...");
		
		Label lblFolder = new Label(container, SWT.NONE);
		lblFolder.setBounds(10, 67, 41, 15);
		lblFolder.setText("Folder");
		
		txtFolder = new Text(container, SWT.BORDER);
		txtFolder.setEnabled(false);
		txtFolder.setBounds(55, 63, 384, 21);
		
		btnFolder = new Button(container, SWT.NONE);
		btnFolder.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				DirectoryDialog dlg = new DirectoryDialog(parent.getShell());

			      // Set the initial filter path according
			      // to anything they've selected or typed in
			      dlg.setFilterPath(txtFolder.getText());
			      // Change the title bar text
			      dlg.setText("Chon folder luu script");
			      // Customizable message displayed in the dialog
			      //dlg.setMessage("Chon duong dan.");

			      // Calling open() will open and run the dialog.
			      // It will return the selected directory, or
			      // null if user cancels
			      String dir = dlg.open();
			      if (dir != null) {
			        // Set the text box to the new selection
			    	  txtFolder.setText(dir);
			      }
			}
		});
		btnFolder.setBounds(445, 63, 36, 25);
		btnFolder.setText("...");
		
		Label lblNewLabel = new Label(container, SWT.NONE);
		lblNewLabel.setBounds(10, 151, 62, 15);
		lblNewLabel.setText("Out Folder");
		
		txtOutFolder = new Text(container, SWT.BORDER);
		txtOutFolder.setEnabled(false);
		txtOutFolder.setBounds(75, 145, 364, 21);
		
		Button btnOutFolder = new Button(container, SWT.NONE);
		btnOutFolder.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				DirectoryDialog dlg = new DirectoryDialog(parent.getShell());

			      // Set the initial filter path according
			      // to anything they've selected or typed in
			      dlg.setFilterPath(txtOutFolder.getText());
			      // Change the title bar text
			      dlg.setText("Chon folder luu file excel");
			      // Customizable message displayed in the dialog
			      //dlg.setMessage("Chon duong dan.");

			      // Calling open() will open and run the dialog.
			      // It will return the selected directory, or
			      // null if user cancels
			      String dir = dlg.open();
			      if (dir != null) {
			        // Set the text box to the new selection
			    	  txtOutFolder.setText(dir);
			      }
			}
		});
		btnOutFolder.setBounds(445, 143, 36, 25);
		btnOutFolder.setText("...");
		
		Button btnRun = new Button(container, SWT.NONE);
		btnRun.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			}
		});
		btnRun.setBounds(10, 112, 75, 25);
		btnRun.setText("Run");
		
		Label label = new Label(container, SWT.NONE);
		label.setText("Database");
		label.setBounds(10, 91, 48, 15);
		
		cboDBA = new Combo(container, SWT.NONE);
		cboDBA.setItems(new String[] {"Oralce-ALONE29", "Oralce-AReport", "Oralce-ALive", "MySQL-test"});
		cboDBA.setBounds(62, 88, 149, 23);
		cboDBA.setText("Oralce-ALONE29");
		
		Label label_1 = new Label(container, SWT.NONE);
		label_1.setText("Define");
		label_1.setBounds(217, 91, 34, 15);
		
		cboDefine = new Combo(container, SWT.NONE);
		cboDefine.setItems(new String[] {"DEF002", "DEF001", "DEF003"});
		cboDefine.setBounds(257, 88, 74, 23);
		cboDefine.setText("DEF002");

		createActions();
		initializeToolBar();
		initializeMenu();
	}

	/**
	 * Create the actions.
	 */
	private void createActions() {
		// Create the actions
		cboDBA.setText("Oralce-ALONE29");
		cboDefine.setText("DEF002");
		cboChoice.setText("File");
		btnFile.setEnabled(true);
		btnFolder.setEnabled(false);
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
