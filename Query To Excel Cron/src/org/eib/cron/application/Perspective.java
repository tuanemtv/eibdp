package org.eib.cron.application;

import java.io.PrintStream;

import org.eclipse.ui.IFolderLayout;
import org.eclipse.ui.IPageLayout;
import org.eclipse.ui.IPerspectiveFactory;
import org.eclipse.ui.console.ConsolePlugin;
import org.eclipse.ui.console.IConsole;
import org.eclipse.ui.console.IConsoleConstants;
import org.eclipse.ui.console.MessageConsole;
import org.eclipse.ui.console.MessageConsoleStream;


public class Perspective implements IPerspectiveFactory {
	
	public void createInitialLayout(IPageLayout layout) {
				
			  
			//lam mat view ko can thiet
				layout.setEditorAreaVisible(false);
				layout.setFixed(false);//true
				
		
		//test
				//String editorArea = layout.getEditorArea();

				//layout.setEditorAreaVisible(true);
				//layout.setFixed(false);

				//layout.addStandaloneView("testRCPView.views.SampleView", true, IPageLayout.LEFT, .35f, editorArea);
				//layout.addView(IConsoleConstants.ID_CONSOLE_VIEW, IPageLayout.BOTTOM, .5f, editorArea); 
			
				//IFolderLayout consoleFolder = layout.createFolder("console",
						//IPageLayout.BOTTOM, 0.65f, "messages");
				//consoleFolder.addView(IConsoleConstants.ID_CONSOLE_VIEW);

			  
	}
}
