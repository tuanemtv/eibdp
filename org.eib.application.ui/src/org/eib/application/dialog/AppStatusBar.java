package org.eib.application.dialog;

import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.internal.WorkbenchWindow;

public class AppStatusBar {
	
	/**
     * Shows status message in RCP
     * @param message message to be displayed
     * @param isError if its an error message or normal message
     */
    public static void showStatusMessage(final String message, final boolean isError) {
        Display.getDefault().syncExec(new Runnable() {

            public void run() {
                IWorkbenchWindow window = PlatformUI.getWorkbench().getActiveWorkbenchWindow();
                if (window instanceof WorkbenchWindow) {
                    WorkbenchWindow w = (WorkbenchWindow) window;
                    if (isError) {
                        w.getStatusLineManager().setErrorMessage(message);
                    } else {
                        w.getStatusLineManager().setMessage(message);
                    }
                }
            }
        });
    }
}
