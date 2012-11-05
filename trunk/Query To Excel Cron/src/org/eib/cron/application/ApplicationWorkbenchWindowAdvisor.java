package org.eib.cron.application;

import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.PropertyConfigurator;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.MenuDetectEvent;
import org.eclipse.swt.events.MenuDetectListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.ShellAdapter;
import org.eclipse.swt.events.ShellEvent;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
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
    configurer.setInitialSize(new Point(600, 500)); //dai, cao
    configurer.setShowCoolBar(false);
    configurer.setShowStatusLine(false);
    configurer.setTitle("Query To Excel Cron [em.tvt@eximbank.com.vn]"); //$NON-NLS-1$
    
  //Doc log 4 j
	Properties props = new Properties();
	try {
		props.load(getClass().getResourceAsStream("/Resource/log4j.properties"));
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	PropertyConfigurator.configure(props);
  }
  
  
  //TH2
  @Override  
  public boolean preWindowShellClose() {  
   final TrayItem item = new TrayItem(  
     Display.getCurrent().getSystemTray(), SWT.NONE);  
   final Image image = Activator.getImageDescriptor("icons/Main history.png")  
     .createImage();  
   item.setImage(image);  
   item.setToolTipText("RCPMail - Tray Icon");  
   getWindowConfigurer().getWindow().getShell().setVisible(false);  
   item.addSelectionListener(new SelectionAdapter() {  
    public void widgetDefaultSelected(SelectionEvent e) {  
     Shell workbenchWindowShell = getWindowConfigurer().getWindow()  
       .getShell();  
     workbenchWindowShell.setVisible(true);  
     workbenchWindowShell.setActive();  
     workbenchWindowShell.setFocus();  
     workbenchWindowShell.setMinimized(false);  
     image.dispose();  
     item.dispose();  
    }  
   });  
    
   Shell workbenchWindowShell = getWindowConfigurer().getWindow()  
     .getShell();  
   // Create a Menu  
   final Menu menu = new Menu(workbenchWindowShell, SWT.POP_UP);  
   // Create the exit menu item.  
   final MenuItem exit = new MenuItem(menu, SWT.PUSH);  
   exit.setText("Exit");  
    
   // Create the open menu item.  
   final MenuItem open = new MenuItem(menu, SWT.PUSH);  
   open.setText("Open");  
   // make the workbench visible in the event handler for exit menu item.  
   open.addListener(SWT.Selection, new Listener() {  
    public void handleEvent(Event event) {  
     // Do a workbench close in the event handler for exit menu item.  
     exit.addListener(SWT.Selection, new Listener() {  
      public void handleEvent(Event event) {  
       image.dispose();  
       item.dispose();  
       open.dispose();  
       exit.dispose();  
       menu.dispose();  
       getWindowConfigurer().getWorkbenchConfigurer().getWorkbench()  
         .close();  
      }  
     });    Shell workbenchWindowShell = getWindowConfigurer().getWindow()  
       .getShell();  
     workbenchWindowShell.setVisible(true);  
     workbenchWindowShell.setActive();  
     workbenchWindowShell.setFocus();  
     workbenchWindowShell.setMinimized(false);  
     image.dispose();  
     item.dispose();  
     open.dispose();  
     exit.dispose();  
     menu.dispose();  
    }  
   });  
   item.addListener(SWT.MenuDetect, new Listener() {  
    public void handleEvent(Event event) {  
     menu.setVisible(true);  
    }

	
   });  
   // Do a workbench close in the event handler for exit menu item.  
   exit.addListener(SWT.Selection, new Listener() {  
    public void handleEvent(Event event) {  
     image.dispose();  
     item.dispose();  
     open.dispose();  
     exit.dispose();  
     menu.dispose();  
     getWindowConfigurer().getWorkbenchConfigurer().getWorkbench()  
       .close();  
    }  
   });  
   return false;  
  }
  
  

  /* TH 1
  // As of here is the new stuff
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
  }
*/
} 
