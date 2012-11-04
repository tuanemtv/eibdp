package org.eib.cron.application;

import java.io.PrintStream;

import org.eclipse.ui.IPageLayout;
import org.eclipse.ui.IPerspectiveFactory;
import org.eclipse.ui.console.ConsolePlugin;
import org.eclipse.ui.console.IConsole;
import org.eclipse.ui.console.MessageConsole;
import org.eclipse.ui.console.MessageConsoleStream;


public class Perspective implements IPerspectiveFactory {
	
	public void createInitialLayout(IPageLayout layout) {
				
			  
			//lam mat view ko can thiet
				layout.setEditorAreaVisible(false);
				layout.setFixed(true);
			  
	}
}
