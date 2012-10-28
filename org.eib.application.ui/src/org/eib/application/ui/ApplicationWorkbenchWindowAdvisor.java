package org.eib.application.ui;

import java.io.*;
import java.net.URL;
import java.util.Properties;

import org.apache.log4j.PropertyConfigurator;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.MenuDetectEvent;
import org.eclipse.swt.events.MenuDetectListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.ShellAdapter;
import org.eclipse.swt.events.ShellEvent;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Menu;
import org.eclipse.swt.widgets.MenuItem;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Tray;
import org.eclipse.swt.widgets.TrayItem;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.application.ActionBarAdvisor;
import org.eclipse.ui.application.IActionBarConfigurer;
import org.eclipse.ui.application.IWorkbenchWindowConfigurer;
import org.eclipse.ui.application.WorkbenchWindowAdvisor;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.chainsaw.Main;

public class ApplicationWorkbenchWindowAdvisor extends WorkbenchWindowAdvisor {
	
	private IWorkbenchWindow window;
	private TrayItem trayItem;
	private Image trayImage;
	
	public ApplicationWorkbenchWindowAdvisor(IWorkbenchWindowConfigurer configurer) {
		super(configurer);
	}

	public ActionBarAdvisor createActionBarAdvisor(IActionBarConfigurer configurer) {
		return new ApplicationActionBarAdvisor(configurer);
	}

	public void preWindowOpen() {
		IWorkbenchWindowConfigurer configurer = getWindowConfigurer();
		configurer.setInitialSize(new Point(630, 520));//
		configurer.setShowCoolBar(false);
		configurer.setShowStatusLine(true);//show satusline
		configurer.setShowPerspectiveBar(true);//Show PerspectiveBar
		configurer.setTitle("Query to Excel [em.tvt@eximbank.com.vn]");
		
		//File log4jfile = new File("./resource/log4j.properties");
		//PropertyConfigurator.configure(log4jfile.getAbsolutePath());
			
		
		//OK
		Properties props = new Properties();
		try {
			props.load(getClass().getResourceAsStream("/resource/log4j.properties"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PropertyConfigurator.configure(props);
		
		
		//PropertyConfigurator.configure((new Properties()).load(new FileInputStream ("log4j.properties")));

		//
		//File propertiesFile = new File( "resource/log4j.properties");
       // PropertyConfigurator.configure(propertiesFile.toString());
		//URL confURL = getBundle().getEntry("log4j.properties");
	    //PropertyConfigurator.configure( FileLocator.toFileURL(confURL).getFile());
		/*
		File log4jFile = new File("log4j.properties");
	    if (log4jFile.exists() & log4jFile.canRead()) {
	        PropertyConfigurator.configure(log4jFile.getAbsolutePath());
	    }
	    else {
	        try {
	            int sep = 0;
				String sepd = null;
				InputStream log4jJarstream = Main.class.getResourceAsStream(sepd + "resources" + sep + "log4j.properties");
	            OutputStream outStream = new FileOutputStream(new File("log4j.properties"));
	            int read = 0;
	            byte[] bytes = new byte[1024];

	            while ((read = log4jJarstream.read(bytes)) != -1) {
	                outStream.write(bytes, 0, read);
	            }
	            log4jJarstream.close();
	            outStream.flush();
	            outStream.close();
	        }
	        catch (Exception e) {
	            BasicConfigurator.configure();
	            //log.warn("Error writing log4j.properties, falling back to defaults.");
	        }
	    }*/
		
				

	}
	
	//System Tray
	
	// As of here is the new stuff
	
	/*
	@Override
	public void postWindowOpen() {
		super.postWindowOpen();
		window = getWindowConfigurer().getWindow();
		trayItem = initTaskItem(window);
		
		// Some OS might not support tray items
		if (trayItem != null) {
			minimizeBehavior();
			// Create exit and about action on the icon
			hookPopupMenu();
		}
	}

	// Add a listener to the shell

	private void minimizeBehavior() {
		window.getShell().addShellListener(new ShellAdapter() {
			// If the window is minimized hide the window
			public void shellIconified(ShellEvent e) {
				window.getShell().setVisible(false);
			}
		});
		// If user double-clicks on the tray icons the application will be
		// visible again
		trayItem.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				Shell shell = window.getShell();
				if (!shell.isVisible()) {
					window.getShell().setMinimized(false);
					shell.setVisible(true);
				}
			}
		});
	}

	// We hook up on menu entry which allows to close the application
	private void hookPopupMenu() {
		trayItem.addMenuDetectListener(new MenuDetectListener() {

			@Override
			public void menuDetected(MenuDetectEvent e) {
				Menu menu = new Menu(window.getShell(), SWT.POP_UP);
				// Creates a new menu item that terminates the program
				MenuItem exit = new MenuItem(menu, SWT.NONE);
				exit.setText("Goodbye!");
				exit.addSelectionListener(new SelectionAdapter() {
					@Override
					public void widgetSelected(SelectionEvent e) {
						window.getWorkbench().close();
					}
				});
				// We need to make the menu visible
				menu.setVisible(true);
			}
		});
	}

	// This methods create the tray item and return a reference
	private TrayItem initTaskItem(IWorkbenchWindow window) {
		final Tray tray = window.getShell().getDisplay().getSystemTray();
		TrayItem trayItem = new TrayItem(tray, SWT.NONE);
		trayImage = Activator.getImageDescriptor("/icons/alt_about.gif")
				.createImage();
		trayItem.setImage(trayImage);
		trayItem.setToolTipText("TrayItem");
		return trayItem;

	}

	// We need to clean-up after ourself
	@Override
	public void dispose() {
		if (trayImage != null) {
			trayImage.dispose();
		}
		if (trayItem != null) {
			trayItem.dispose();
		}
	}*/
}	
