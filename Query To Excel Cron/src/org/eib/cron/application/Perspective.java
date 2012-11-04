package org.eib.cron.application;

import org.eclipse.ui.IPageLayout;
import org.eclipse.ui.IPerspectiveFactory;

public class Perspective implements IPerspectiveFactory {
	
	public void createInitialLayout(IPageLayout layout) {
		
		//lam mat view ko can thiet
		layout.setEditorAreaVisible(false);
		layout.setFixed(true);
	}
}
