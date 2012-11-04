package org.eib.cron.application.views;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eib.common.DateTimeUtil;
import org.eib.common.MainCommon;

public class CronView extends ViewPart {

	public static final String ID = "org.eib.cron.application.views.CronView"; //$NON-NLS-1$

	public CronView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		container.setLayout(null);
		
		Button btnStart = new Button(container, SWT.NONE);
		btnStart.addSelectionListener(new SelectionAdapter() {			
			@Override
			public void widgetSelected(SelectionEvent e) {
				System.out.println("Date = "+DateTimeUtil.getDateYYYYMMDD());
				
				MainCommon a =new MainCommon("/resource/app","1");
				a.get_appcommon().logAppCommon();
				for (int i=0; i<a.get_query().length; i++){
					//System.out.println("["+i+"]-----------------");
					a.get_query()[i].logQuery();
				}
				
				System.out.println("\n");
				
				a.sortQueryWithPriority();
				for (int i=0; i<a.get_query().length; i++){
					//System.out.println("["+i+"]-----------------");
					a.get_query()[i].logQuery();
				}
			}
		});
		btnStart.setBounds(10, 10, 75, 25);
		btnStart.setText("Start");
		{
			Button btnStop = new Button(container, SWT.NONE);
			btnStop.setBounds(91, 10, 75, 25);
			btnStop.setText("Stop");
		}

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
