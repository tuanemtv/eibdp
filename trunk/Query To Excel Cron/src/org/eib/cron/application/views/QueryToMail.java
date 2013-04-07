package org.eib.cron.application.views;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.DirectoryDialog;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.custom.CLabel;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eib.common.MailUtil;
import org.eclipse.swt.widgets.Table;

public class QueryToMail extends ViewPart {

	public static final String ID = "org.eib.cron.application.views.QueryToMail"; //$NON-NLS-1$
	private Text txtScript;
	private Text txtFrMail;
	private Text txtPass;
	private Text txtToMail;
	private Text txtFolder;
	private Text txtSmtpServer;
	private Text txtFileName;
	private Text txtSubject;
	private Text txtContent;
	private Table table;

	public QueryToMail() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(final Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		container.setLayout(null);
		
		txtScript = new Text(container, SWT.BORDER | SWT.WRAP | SWT.H_SCROLL | SWT.V_SCROLL | SWT.CANCEL);
		txtScript.setBounds(10, 31, 574, 204);
		
		Label lblFromMail = new Label(container, SWT.NONE);
		lblFromMail.setBounds(10, 266, 55, 15);
		lblFromMail.setText("From Mail");
		
		txtFrMail = new Text(container, SWT.BORDER);
		txtFrMail.setText("tuanemtv.gogo@gmail.com");
		txtFrMail.setBounds(71, 266, 198, 21);
		
		Label lblPass = new Label(container, SWT.NONE);
		lblPass.setBounds(285, 266, 28, 15);
		lblPass.setText("Pass");
		
		txtPass = new Text(container, SWT.BORDER);
		txtPass.setText("tuan1985em");
		txtPass.setBounds(319, 263, 146, 21);
		txtPass.setEchoChar('*');
		
		Label lblToMail = new Label(container, SWT.NONE);
		lblToMail.setText("To Mail");
		lblToMail.setBounds(10, 296, 55, 15);
		
		txtToMail = new Text(container, SWT.BORDER);
		txtToMail.setText("tuanemtv@gmail.com");
		txtToMail.setBounds(71, 293, 172, 21);
		
		Button button = new Button(container, SWT.NONE);
		button.addSelectionListener(new SelectionAdapter() {
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
		button.setText("...");
		button.setBounds(558, 0, 36, 25);
		
		txtFolder = new Text(container, SWT.BORDER);
		txtFolder.setText("D:\\\\");
		txtFolder.setEnabled(false);
		txtFolder.setBounds(243, 2, 310, 21);
		
		Label lblOutFolder = new Label(container, SWT.NONE);
		lblOutFolder.setText("Out Folder");
		lblOutFolder.setBounds(185, 5, 65, 15);
		
		CLabel lblNewLabel = new CLabel(container, SWT.NONE);
		lblNewLabel.setBounds(10, 241, 65, 21);
		lblNewLabel.setText("smtpServer");
		
		txtSmtpServer = new Text(container, SWT.BORDER);
		txtSmtpServer.setText("smtp.gmail.com");
		txtSmtpServer.setBounds(81, 241, 139, 21);
		
		Button btnSend = new Button(container, SWT.NONE);
		btnSend.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				MailUtil mail = new MailUtil();
				mail.set_smtpServer(txtSmtpServer.getText());
				mail.set_frMail(txtFrMail.getText());
				mail.set_passFrMail(txtPass.getText());
				
				String[] toMail = new String[1];
				toMail[0] = txtToMail.getText();
				mail.set_toMail(toMail);
				
				mail.set_subject(txtSubject.getText());
				mail.set_ContMail(txtContent.getText());
				mail.set_bodyKind("1");
				mail.set_fileName(txtFileName.getText());
				mail.set_fileUrl(txtFolder.getText());
				
				try {
					mail.sendMail();
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		btnSend.setBounds(478, 433, 75, 25);
		btnSend.setText("Send");
		
		Label label = new Label(container, SWT.NONE);
		label.setText("Database");
		label.setBounds(10, 5, 48, 15);
		
		Combo combo = new Combo(container, SWT.NONE);
		combo.setItems(new String[] {"Oralce-ALONE29", "Oralce-AReport", "Oralce-ALive", "MySQL-test"});
		combo.setBounds(62, 2, 119, 23);
		combo.setText("Oralce-ALONE29");
		
		Label lblNewLabel_1 = new Label(container, SWT.NONE);
		lblNewLabel_1.setBounds(224, 241, 55, 15);
		lblNewLabel_1.setText("File Name");
		
		txtFileName = new Text(container, SWT.BORDER);
		txtFileName.setText("test.txt");
		txtFileName.setBounds(344, 241, 180, 21);
		
		Label lblNewLabel_2 = new Label(container, SWT.NONE);
		lblNewLabel_2.setBounds(10, 372, 55, 15);
		lblNewLabel_2.setText("Subject");
		
		txtSubject = new Text(container, SWT.BORDER);
		txtSubject.setBounds(71, 369, 394, 21);
		
		txtContent = new Text(container, SWT.BORDER | SWT.WRAP | SWT.V_SCROLL);
		txtContent.setBounds(71, 396, 394, 62);
		
		table = new Table(container, SWT.BORDER | SWT.FULL_SELECTION);
		table.setBounds(249, 295, 275, 68);
		table.setHeaderVisible(true);
		table.setLinesVisible(true);
		
		Button btnAdd = new Button(container, SWT.NONE);
		btnAdd.setBounds(208, 320, 36, 25);
		btnAdd.setText(">>");

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
