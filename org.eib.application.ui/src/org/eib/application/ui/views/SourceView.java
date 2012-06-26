package org.eib.application.ui.views;

import java.io.IOException;
import java.util.ResourceBundle;

import javax.xml.parsers.ParserConfigurationException;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Table;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eib.common.AppCommon;
import org.eib.ftp.FTPdownload;
import org.xml.sax.SAXException;

public class SourceView extends ViewPart {

	public static final String ID = "org.eib.application.ui.views.SourceView"; //$NON-NLS-1$
	private Table table1;

	public SourceView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		container.setLayout(null);
		
		table1 = new Table(container, SWT.BORDER | SWT.FULL_SELECTION);
		table1.setBounds(24, 51, 360, 69);
		table1.setHeaderVisible(true);
		table1.setLinesVisible(true);
		TableColumn tc1 = new TableColumn(table1, SWT.CENTER);
		tc1.setText("Duong dan");
		
		TableItem item1 = new TableItem(table1, SWT.NONE);
	    item1.setText(new String[] { "Tim", "Hatton", "Kentucky" });
	    
	    Button btnGet = new Button(container, SWT.NONE);
	    btnGet.addSelectionListener(new SelectionAdapter() {
	    	@Override
	    	public void widgetSelected(SelectionEvent e) {
	    		AppCommon _app;
	    		_app = new AppCommon();
	    		try {
	    			ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
	    			_app.getAppCom("D:\\Query to Excel\\Congifure\\app.xml", "Common2");
	    			//_app.getAppCom("D:\\Query to Excel\\Congifure\\app.xml","Common2");
	    			
	    		} catch (ParserConfigurationException e1) {
	    			// TODO Auto-generated catch block
	    			e1.printStackTrace();
	    			return;	
	    		} catch (SAXException e1) {
	    			// TODO Auto-generated catch block
	    			e1.printStackTrace();
	    			return;	
	    		} catch (IOException e1) {
	    			// TODO Auto-generated catch block
	    			e1.printStackTrace();
	    			return;	
	    		}
	    		
	    		
	    		//ResourceBundle rb = ResourceBundle.getBundle("configure");
	    		  //String server = rb.getString("server"); ;
	    	     // String user = rb.getString("user"); ;
	    	      //String pass = rb.getString("pass"); 
	    	      //String serverDir = rb.getString("serverDir");;
	    	     // String clientDir = rb.getString("clientDir");

	    	       FTPdownload upload = null;
	    		try {
	    			upload = new FTPdownload (_app.get_srcFTPServer(),_app.get_srcFTPUser(), _app.get_srcFTPPass());
	    		} catch (IOException e1) {
	    			// TODO Auto-generated catch block
	    			e1.printStackTrace();
	    		} catch (Exception e1) {
	    			// TODO Auto-generated catch block
	    			e1.printStackTrace();
	    		}
	    		
	    	      // File f = new File(_app.get_srcFTPCliUrl());
	    	      // upload.copyFile(f,_app.get_srcFTPSerUrl());
	    		upload.showModifyFile(_app);
	    	}
	    });
	    btnGet.setBounds(24, 10, 75, 25);
	    btnGet.setText("Get");
	    
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
