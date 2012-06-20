
package org.eib.application.ui.views;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.ProgressBar;
import org.eclipse.swt.widgets.Label;

public class MultiProgressView extends ViewPart {

	public static final String ID = "org.eib.application.ui.views.MultiProgress"; //$NON-NLS-1$

	public MultiProgressView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		
		ProgressBar progressBar = new ProgressBar(container, SWT.NONE);
		progressBar.setBounds(10, 20, 225, 17);
		
		Label lblNewLabel = new Label(container, SWT.NONE);
		lblNewLabel.setBounds(10, 0, 55, 15);
		lblNewLabel.setText("New Label");

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
