package org.eib.application.ui.views;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.Map.Entry;
import java.util.TreeMap;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.eclipse.jface.action.IStatusLineManager;
import org.eclipse.jface.action.Separator;
import org.eclipse.jface.viewers.IStructuredContentProvider;
import org.eclipse.jface.viewers.ITableLabelProvider;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.jface.viewers.Viewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.ISharedImages;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.custom.CLabel;
import org.eclipse.swt.events.MouseAdapter;
import org.eclipse.swt.events.MouseEvent;
import org.eib.application.ui.Activator;
import org.eib.application.ui.CustomAction;
import org.eib.common.AppCommon;
import org.eib.common.FTPUtil;
import org.eib.common.FolderUtil;
import org.eib.common.JavaUtil;
import org.eib.common.QueryServer;
import org.eib.common.ZipUtil;
import org.eib.database.CommandQuery;
import org.eib.database.JDBCURLHelper;
import org.eib.database.Query;
import org.eib.thread.RunMulConScript;
import org.eib.thread.RunMulScript;
import org.xml.sax.SAXException;
import org.eclipse.wb.swt.layout.grouplayout.GroupLayout;
import org.eclipse.wb.swt.layout.grouplayout.LayoutStyle;
import org.eclipse.wb.swt.SWTResourceManager;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.FocusAdapter;
import org.eclipse.swt.events.FocusEvent;

public class MultiScriptView extends ViewPart {

	public static final String ID = "org.eib.application.ui.MultiScriptView"; //$NON-NLS-1$

	public MultiScriptView() {
	}

	private Text txtConfigureUrl;
	private Text txtScriptNum;
	
	private static Logger logger =Logger.getLogger("MultiScriptView");
	private AppCommon _app;
	private QueryServer queryser;
	private Connection _conn = null; 
	private Query[] _query;
	
	private Text txtOutUrl;
	private Text txtExelRownum;
	
	
	private Text txtdefine1; //define value 1
	private Text txtdefine2;
	private Text txtdefine3;
	private Text txtdefine4;
	private Text txtdefine5;
	private Text txtdefine6;
	
	private Label lbldefine1;
	private Label lbldefine2;
	private Label lbldefine3;
	private Label lbldefine4;
	private Label lbldefine5;
	private Label lbldefine6;
	
	
	/**
	 * The content provider class is responsible for providing objects to the
	 * view. It can wrap existing objects in adapters or simply return objects
	 * as-is. These objects may be sensitive to the current input of the view,
	 * or ignore it and always show the same content (like Task List, for
	 * example).
	 */
	class ViewContentProvider implements IStructuredContentProvider {
		public void inputChanged(Viewer v, Object oldInput, Object newInput) {
		}

		public void dispose() {
		}

		public Object[] getElements(Object parent) {
			if (parent instanceof Object[]) {
				return (Object[]) parent;
			}
	        return new Object[0];
		}
	}

	class ViewLabelProvider extends LabelProvider implements
			ITableLabelProvider {
		public String getColumnText(Object obj, int index) {
			return getText(obj);
		}

		public Image getColumnImage(Object obj, int index) {
			return getImage(obj);
		}

		public Image getImage(Object obj) {
			return PlatformUI.getWorkbench().getSharedImages().getImage(
					ISharedImages.IMG_OBJ_ELEMENT);
		}
	}

	/**
	 * This is a callback that will allow us to create the viewer and initialize
	 * it.
	 */
	public void createPartControl(Composite parent) {
		
		// Custom Action for the View's Menu  
		CustomAction lCustomAction = new CustomAction();  
		lCustomAction.setText("Open Dialog Box");  
		lCustomAction.setImageDescriptor(Activator.getImageDescriptor("icons/bomb.png"));  
		getViewSite().getActionBars().getMenuManager().add(lCustomAction);  
		getViewSite().getActionBars().getMenuManager().add(new Separator()); //Add a horizontal separator  
		getViewSite().getActionBars().getMenuManager().add(lCustomAction);  
		getViewSite().getActionBars().getMenuManager().add(lCustomAction);  			
		//QueryServer qserver=null;
		//qserver.
		
		Composite composite = new Composite(parent, SWT.NONE);
		
		Label lblServer = new Label(composite, SWT.NONE);
		lblServer.setText("Server");
		
		final Combo cboServer = new Combo(composite, SWT.NONE);
		cboServer.setItems(new String[] {"1. Oracle - A Report", "2. MySQL", "3. Oralce - A Live", "4. SQL Server"});
		
		Label lblScript = new Label(composite, SWT.NONE);
		lblScript.setText("Script");
		
		final Combo cboScript = new Combo(composite, SWT.NONE);
		
		final CLabel lblconnect = new CLabel(composite, SWT.NONE);
		lblconnect.setForeground(SWTResourceManager.getColor(SWT.COLOR_RED));
		lblconnect.setText("DisConnect");
		
		Button btnload = new Button(composite, SWT.NONE);
		btnload.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				//System.out.println("Load");	
				logger.info("Log Script");
				System.out.println("> Log script");
				Query qur = new Query();//luc khoi dau lay duoc gia tri ko?
					
				//System.out.println("script Count ="+_app.get_scriptcount());
				logger.info("Script count= "+_app.get_scriptcount());
				_query = new Query[_app.get_scriptcount()];
				//_query = new Query[13];
				try {
					qur.getXMLToScript(_app.get_configureurl()+"script.xml", "Query", _query);
					for (int i=0; i< _query.length; i++){
						logger.info("["+(i+1)+"] queryid: " + _query[i].get_queryid()+", name: "+_query[i].get_querynm());
						//System.out.println("\n["+(i+1)+"] queryid : " + _query[i].get_queryid());
						//System.out.println("["+(i+1)+"] querynm : " + _query[i].get_querynm());
						//System.out.println("["+i+"] module : " + _query[i].get_module());
						//System.out.println("["+i+"] getquery : " + qur2[i].get_getquery());
						
						_query[i].setquery();
						//logger.info("\n"+_query[i].get_exquery());
						
						cboScript.add(_query[i].get_querynm(), i);
						
						TreeMap<String, String> hm_temp = new TreeMap<String, String>();
						hm_temp =_query[i].get_define();
						Set<Entry<String, String>> set = hm_temp.entrySet();
						// Get an iterator
						Iterator<Entry<String, String>> j = set.iterator();
						while(j.hasNext()) {
							Map.Entry me = j.next();
							//System.out.print(me.getKey() + ": ");
							//System.out.println(me.getValue());
						}
						
						//System.out.println("["+i+"] exequery : " + _query[i].get_exquery());
						
						//Lay duong dan out file
						_query[i].set_queryouturl(_app.get_outurl_excel(_query[i].get_querynm()));
						//System.out.println("["+i+"] out file : " + _query[i].get_queryouturl());						
						//System.out.println("["+i+"] status : " + _query[i].get_status());						
					}
					System.out.println("> Load script Done. With= "+_query.length+" scripts");
				} catch (ParserConfigurationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (SAXException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
			}
		});
		btnload.setText("Load");
		
		Label lblConfigureUrl = new Label(composite, SWT.NONE);
		lblConfigureUrl.setText("Configure Url");
		
		txtConfigureUrl = new Text(composite, SWT.BORDER);
		txtConfigureUrl.setEditable(false);
		
		Label lblScriptNum = new Label(composite, SWT.NONE);
		lblScriptNum.setText("Script Num");
		
		txtScriptNum = new Text(composite, SWT.BORDER);
		txtScriptNum.setEditable(false);
		
		Button btnRunOne = new Button(composite, SWT.NONE);
		btnRunOne.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (_conn!=null){
					//Chay run 1 scipt
					if (_query !=null){
						for (int i=0; i< _query.length; i++){
							if (cboScript.getText().equals( _query[i].get_querynm())){
								//Run scipt do
								System.out.println("Run 1 script.");
								CommandQuery.set_Excelrow(_app.get_excelrows());
								CommandQuery.commandQueryExcel(_conn, _query[i].get_exquery(),true,false, _app.get_outurl_excel(_query[i].get_querynm()));
							}
						}
					}else{
						System.out.println("Chua load script");
					}
				}else{
					System.out.println("Chua ket  noi");
				}
			}
		});
		btnRunOne.setText("Run 1 script");
		
		Button btnRunAll = new Button(composite, SWT.NONE);
		btnRunAll.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				//Set folder va tao folder
				_app.set_outurl(_app.get_outurl() + txtdefine1.getText());
				txtOutUrl.setText(_app.get_outurl());
				
				//Tao folder
				FolderUtil.createFolder(_app.get_outurl());
				
				if(_conn!=null){
					if (_query!=null)
					{
						//Tao duong dan luu file
						
						
						//Xet lai gia tri cua app common
						for (int i=0; i<_query.length;i++)
						{				
							_query[i].set_define(_app.get_define());							
							_query[i].setquery();//Set lai cau script lay
							//Set duong dan
						}
						
						//Chay 1 connect
						//RunMulScript.commandMulQueryExcel(_conn,_query,_app);
						
						//Chay nhieu connect
						RunMulConScript.commandMulQueryExcel(queryser,_query, _app);						
					}
					else
						System.out.println("Chua Load script.");
				}else{
					System.out.println("Chua ket noi.");
				}
					
			}
		});
		btnRunAll.setText("Run all scripts");
		
		Label lblOutFileUrl = new Label(composite, SWT.NONE);
		lblOutFileUrl.setText("Out File Url");
		
		txtOutUrl = new Text(composite, SWT.BORDER);
		txtOutUrl.setEditable(false);
		
		final Button btnConnect = new Button(composite, SWT.NONE);
		btnConnect.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseDown(MouseEvent e) {		
				
				if (btnConnect.getText().equals("Connect")){					
					System.out.println("Connecting........");	
					//System.out.println("\nscript nums : " + _app.get_scriptnums());
					
						if (cboServer.getText().equals("")){
							System.out.println("Phai chon Server.");	
						}
						else{
							cboServer.setEnabled(false);
							btnConnect.setText("No Connect");
							try {
							queryser =new QueryServer();
							if (cboServer.getText().equals("1. Oracle - A Report")){
								queryser.getServer(_app.get_configureurl()+"database.xml","Oralce-AReport");
							}
							else if (cboServer.getText().equals("2. MySQL")){
								queryser.getServer(_app.get_configureurl()+"database.xml","MySQL-test");
							}
							else if (cboServer.getText().equals("3. Oralce - A Live")){
								queryser.getServer(_app.get_configureurl()+"database.xml","Oralce-ALive");
							}
													
							//_queryser.getServer("E:\\BACKUP\\DROPBOX\\Dropbox\\WORK\\Project\\database.xml","MySQL-test");
							//System.out.println("getDriver : " + queryser.getDriver());
							//System.out.println("getDatabase : " + queryser.getDatabase());
							//System.out.println("getHost : " + queryser.getHost());
							//System.out.println("getPassword : " + queryser.getPassword());						
							//System.out.println("getPort : " + queryser.getPort());
							
							queryser.setUrl(JDBCURLHelper.generateURL(queryser.getDriver(), queryser.getHost(), queryser.getPort(), queryser.getDatabase()));
					        System.out.println("url = "+queryser.getUrl());
					        	
							try {
								Class.forName(queryser.getDriver()).newInstance();
								_conn = DriverManager.getConnection(queryser.getUrl(), queryser.getUser(), queryser.getPassword());
								System.out.println("Connect Successful !!!");
					        } catch (Exception e2) {
					            System.out.println("Unable to load driver " + queryser.getDriver());
					            System.out.println("ERROR " + e2.getMessage());
					            //return;				        
					        }/*
					        try {
					        	System.out.println("Da dong ket noi");
					        	_conn.close();
					        } catch (SQLException ex) {
					        }*/	
						
							
						} catch (ParserConfigurationException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						} catch (SAXException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						} catch (IOException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}	
					}
						
					lblconnect.setText("DisConnect");
					
				}else{//Nhan Disconnect
					cboServer.setEnabled(true);
					btnConnect.setText("Connect");
					lblconnect.setText("Connect");
					System.out.println("DisConnect !!!");
				}
					
			}
		});
		btnConnect.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			}
		});
		btnConnect.setText("Connect");
		//color = new Color(shell.getDisplay(), dlg.getRGB());
		//lblconnect.setForeground(Color.class);
		
		//Load app
		_app = new AppCommon();
		try {
			ResourceBundle rb = ResourceBundle.getBundle("app");
			_app.getAppCom(rb.getString("app_configure_url")+"app.xml",rb.getString("app_configure_common"));
			txtConfigureUrl.setText(_app.get_configureurl());
			txtScriptNum.setText(String.valueOf(_app.get_scriptnums()));
			txtOutUrl.setText(_app.get_outurl());
			
			Label lblExcelRownum = new Label(composite, SWT.NONE);
			lblExcelRownum.setText("Excel Rownum");
			
			txtExelRownum = new Text(composite, SWT.BORDER);
			txtExelRownum.setEditable(false);
			txtExelRownum.setText("0");
			
			Button btnMultiServer = new Button(composite, SWT.CHECK);
			btnMultiServer.setText("Multi Server");
			
			final Label lbldefine1 = new Label(composite, SWT.NONE);
			lbldefine1.setText("New Label");
			
			final Label lbldefine2 = new Label(composite, SWT.NONE);
			lbldefine2.setText("New Label");
			
			final Label lbldefine3 = new Label(composite, SWT.NONE);
			lbldefine3.setText("New Label");
			
			final Label lbldefine4 = new Label(composite, SWT.NONE);
			lbldefine4.setText("New Label");
			
			final Label lbldefine5 = new Label(composite, SWT.NONE);
			lbldefine5.setText("New Label");
			
			final Label lbldefine6 = new Label(composite, SWT.NONE);
			lbldefine6.setText("New Label");
			
			txtdefine1 = new Text(composite, SWT.BORDER);
			txtdefine1.addFocusListener(new FocusAdapter() {
				@Override
				public void focusLost(FocusEvent e) {
					
					System.out.println("\n\n. Dang test modify.");
					System.out.println("txtdefine1 = "+txtdefine1.getText());
					
					TreeMap<String, String> tMapdefine = new TreeMap<String, String>();
					//TreeMap<String, String> tMapdefine = null;
					_app.seth_trdt(txtdefine1.getText());
					
					tMapdefine = CommandQuery.queryGetVar(_conn, _app.get_defscript2());
					//JavaUtil.showHashMap(tMapdefine);
					
					
					_app.set_define(tMapdefine);//Set lai define
					JavaUtil.showHashMap(_app.get_define());
					//setSetDefine();//Goi ham set define
					Set<Entry<String, String>> set = _app.get_define().entrySet();
					// Get an iterator
					Iterator<Entry<String, String>> j = set.iterator();
					int k=1;
					while(j.hasNext()) {
						Entry<String, String> me = j.next();
						System.out.println(me.getKey() + ": "+me.getValue()+" "+_app.get_definenm().get(me.getKey()));				
						logger.info(me.getKey() + ": "+me.getValue());
						
						if (k==1){//define 1
							lbldefine1.setVisible(true);
							lbldefine1.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine1.setVisible(true);
							txtdefine1.setText(me.getValue());
						}
						else if (k==2){
							lbldefine2.setVisible(true);
							lbldefine2.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine2.setVisible(true);
							txtdefine2.setText(me.getValue());
							txtdefine2.setEnabled(false);
						}
						else if (k==3){
							lbldefine3.setVisible(true);
							lbldefine3.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine3.setVisible(true);
							txtdefine3.setText(me.getValue());
							txtdefine3.setEnabled(false);
						}
						else if (k==4){
							lbldefine4.setVisible(true);
							lbldefine4.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine4.setVisible(true);
							txtdefine4.setText(me.getValue());
							txtdefine4.setEnabled(false);
						}
						else if (k==5){
							lbldefine5.setVisible(true);
							lbldefine5.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine5.setVisible(true);
							txtdefine5.setText(me.getValue());
							txtdefine5.setEnabled(false);
						}
						else if (k==6){
							lbldefine6.setVisible(true);
							lbldefine6.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine6.setVisible(true);
							txtdefine6.setText(me.getValue());
						}
						k++;
					}
				}
			});
			txtdefine1.addModifyListener(new ModifyListener() {
				public void modifyText(ModifyEvent e) {
					
					//Chinh ngay h_trdt --> goi tinh lai
					
				}
			});
			
			txtdefine2 = new Text(composite, SWT.BORDER);
			txtdefine3 = new Text(composite, SWT.BORDER);
			txtdefine4 = new Text(composite, SWT.BORDER);
			txtdefine5 = new Text(composite, SWT.BORDER);
			txtdefine6 = new Text(composite, SWT.BORDER);
			
			Button btnZip = new Button(composite, SWT.NONE);
			btnZip.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(SelectionEvent e) {
					ZipUtil.creatZipFoler(txtOutUrl.getText());
				}
			});
			btnZip.setText("Zip");
			
			Button btnUploadFTP = new Button(composite, SWT.NONE);
			btnUploadFTP.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(SelectionEvent e) {
					FTPUtil ftpclient= new FTPUtil();
					ftpclient.set_ftpServer(_app.get_ftpServer());
					ftpclient.set_user(_app.get_ftpUsr());
					ftpclient.set_password(_app.get_ftpPass());
					ftpclient.set_filename(_app.get_ftpFilename());
					ftpclient.set_ftpurl(_app.get_ftpUrl());
					ftpclient.set_inturl(_app.get_ftpInurl());
					
					logger.info(ftpclient.get_ftpServer());
					logger.info(ftpclient.get_user());
					logger.info(ftpclient.get_password());
					logger.info(ftpclient.get_filename());
					logger.info(ftpclient.get_ftpurl());				
					logger.info(ftpclient.get_inturl());
					
					System.out.println("> Upload file: "+ftpclient.get_inturl()+ftpclient.get_filename());
					ftpclient.sendUpload();//day len upload
					System.out.println("> Upload Done");
				}
			});
			btnUploadFTP.setText("Upload FTP");
			
			Button btnTest = new Button(composite, SWT.NONE);
			btnTest.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(SelectionEvent e) {
					TreeMap<String, String> tMapdefine = new TreeMap<String, String>();
					//TreeMap<String, String> tMapdefine = null;
					tMapdefine = CommandQuery.queryGetVar(_conn, _app.get_defscript());
					//JavaUtil.showHashMap(tMapdefine);
					_app.set_define(tMapdefine);//Set lai define
					JavaUtil.showHashMap(_app.get_define());
					//setSetDefine();//Goi ham set define
					Set<Entry<String, String>> set = _app.get_define().entrySet();
					// Get an iterator
					Iterator<Entry<String, String>> j = set.iterator();
					int k=1;
					while(j.hasNext()) {
						Entry<String, String> me = j.next();
						System.out.println(me.getKey() + ": "+me.getValue()+" "+_app.get_definenm().get(me.getKey()));				
						logger.info(me.getKey() + ": "+me.getValue());
						
						if (k==1){//define 1
							lbldefine1.setVisible(true);
							lbldefine1.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine1.setVisible(true);
							txtdefine1.setText(me.getValue());
						}
						else if (k==2){
							lbldefine2.setVisible(true);
							lbldefine2.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine2.setVisible(true);
							txtdefine2.setText(me.getValue());
							txtdefine2.setEnabled(false);
						}
						else if (k==3){
							lbldefine3.setVisible(true);
							lbldefine3.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine3.setVisible(true);
							txtdefine3.setText(me.getValue());
							txtdefine3.setEnabled(false);
						}
						else if (k==4){
							lbldefine4.setVisible(true);
							lbldefine4.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine4.setVisible(true);
							txtdefine4.setText(me.getValue());
							txtdefine4.setEnabled(false);
						}
						else if (k==5){
							lbldefine5.setVisible(true);
							lbldefine5.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine5.setVisible(true);
							txtdefine5.setText(me.getValue());
							txtdefine5.setEnabled(false);
						}
						else if (k==6){
							lbldefine6.setVisible(true);
							lbldefine6.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
							txtdefine6.setVisible(true);
							txtdefine6.setText(me.getValue());
						}
						k++;
					}					
				}
			});
			btnTest.setText("Test");
			
			Button btnA = new Button(composite, SWT.NONE);
			btnA.setText("a");
			GroupLayout gl_composite = new GroupLayout(composite);
			gl_composite.setHorizontalGroup(
				gl_composite.createParallelGroup(GroupLayout.LEADING)
					.add(gl_composite.createSequentialGroup()
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING, false)
							.add(gl_composite.createSequentialGroup()
								.addContainerGap()
								.add(gl_composite.createParallelGroup(GroupLayout.TRAILING, false)
									.add(gl_composite.createSequentialGroup()
										.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
											.add(lbldefine1, GroupLayout.PREFERRED_SIZE, 201, GroupLayout.PREFERRED_SIZE)
											.add(lbldefine5)
											.add(lbldefine6)
											.add(lbldefine2))
										.addPreferredGap(LayoutStyle.RELATED))
									.add(gl_composite.createSequentialGroup()
										.add(lbldefine3)
										.add(4))
									.add(gl_composite.createSequentialGroup()
										.add(lbldefine4)
										.add(4)))
								.add(gl_composite.createParallelGroup(GroupLayout.LEADING, false)
									.add(txtdefine1, GroupLayout.PREFERRED_SIZE, 86, GroupLayout.PREFERRED_SIZE)
									.add(txtdefine2, GroupLayout.PREFERRED_SIZE, 86, GroupLayout.PREFERRED_SIZE)
									.add(txtdefine3, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
									.add(txtdefine4, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
									.add(txtdefine5, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
									.add(txtdefine6, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lblOutFileUrl)
								.add(20)
								.add(txtOutUrl, GroupLayout.PREFERRED_SIZE, 335, GroupLayout.PREFERRED_SIZE))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lblScriptNum)
								.add(19)
								.add(txtScriptNum, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
								.addPreferredGap(LayoutStyle.RELATED)
								.add(lblExcelRownum)
								.add(18)
								.add(txtExelRownum, GroupLayout.PREFERRED_SIZE, 52, GroupLayout.PREFERRED_SIZE))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lblConfigureUrl)
								.add(8)
								.add(txtConfigureUrl, GroupLayout.PREFERRED_SIZE, 335, GroupLayout.PREFERRED_SIZE))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lblServer)
								.add(6)
								.add(cboServer, GroupLayout.PREFERRED_SIZE, 145, GroupLayout.PREFERRED_SIZE)
								.addPreferredGap(LayoutStyle.UNRELATED)
								.add(btnConnect, GroupLayout.PREFERRED_SIZE, 78, GroupLayout.PREFERRED_SIZE)
								.addPreferredGap(LayoutStyle.RELATED)
								.add(lblconnect, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
								.addPreferredGap(LayoutStyle.RELATED)
								.add(btnTest)
								.addPreferredGap(LayoutStyle.RELATED)
								.add(btnA))
							.add(gl_composite.createSequentialGroup()
								.add(12)
								.add(lblScript)
								.add(6)
								.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
									.add(gl_composite.createSequentialGroup()
										.add(btnRunOne)
										.addPreferredGap(LayoutStyle.RELATED)
										.add(btnRunAll)
										.addPreferredGap(LayoutStyle.UNRELATED)
										.add(btnMultiServer)
										.addPreferredGap(LayoutStyle.RELATED)
										.add(btnZip)
										.addPreferredGap(LayoutStyle.RELATED)
										.add(btnUploadFTP))
									.add(gl_composite.createSequentialGroup()
										.add(cboScript, GroupLayout.PREFERRED_SIZE, 355, GroupLayout.PREFERRED_SIZE)
										.add(6)
										.add(btnload)))))
						.add(118))
			);
			gl_composite.setVerticalGroup(
				gl_composite.createParallelGroup(GroupLayout.LEADING)
					.add(gl_composite.createSequentialGroup()
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
									.add(gl_composite.createSequentialGroup()
										.add(5)
										.add(lblServer))
									.add(gl_composite.createSequentialGroup()
										.add(2)
										.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
											.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
												.add(btnTest)
												.add(btnA))
											.add(lblconnect, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)))))
							.add(gl_composite.createSequentialGroup()
								.add(11)
								.add(cboServer, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(btnConnect)))
						.addPreferredGap(LayoutStyle.RELATED)
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(gl_composite.createSequentialGroup()
								.add(3)
								.add(lblConfigureUrl))
							.add(txtConfigureUrl, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
						.addPreferredGap(LayoutStyle.RELATED)
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(gl_composite.createSequentialGroup()
								.add(3)
								.add(lblScriptNum))
							.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
								.add(txtScriptNum, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
								.add(lblExcelRownum)
								.add(txtExelRownum, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)))
						.add(7)
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(gl_composite.createSequentialGroup()
								.add(5)
								.add(lblScript))
							.add(gl_composite.createSequentialGroup()
								.add(1)
								.add(cboScript, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
							.add(btnload))
						.addPreferredGap(LayoutStyle.RELATED)
						.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
							.add(btnRunOne)
							.add(btnRunAll)
							.add(btnMultiServer)
							.add(btnZip)
							.add(btnUploadFTP))
						.addPreferredGap(LayoutStyle.RELATED)
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(lblOutFileUrl)
							.add(txtOutUrl, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
						.add(18)
						.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
							.add(lbldefine1)
							.add(txtdefine1, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
						.addPreferredGap(LayoutStyle.RELATED)
						.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
							.add(txtdefine2, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
							.add(lbldefine2))
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(gl_composite.createSequentialGroup()
								.addPreferredGap(LayoutStyle.RELATED)
								.add(txtdefine3, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lbldefine3)))
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(gl_composite.createSequentialGroup()
								.addPreferredGap(LayoutStyle.RELATED)
								.add(txtdefine4, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lbldefine4)))
						.addPreferredGap(LayoutStyle.RELATED)
						.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
							.add(lbldefine5)
							.add(txtdefine5, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
						.addPreferredGap(LayoutStyle.RELATED)
						.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
							.add(lbldefine6)
							.add(txtdefine6, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
						.addContainerGap(96, Short.MAX_VALUE))
			);
			gl_composite.linkSize(new Control[] {lbldefine1, lbldefine2, lbldefine3, lbldefine4, lbldefine5, lbldefine6}, GroupLayout.HORIZONTAL);
			gl_composite.linkSize(new Control[] {txtdefine1, txtdefine2, txtdefine3, txtdefine4, txtdefine5, txtdefine6}, GroupLayout.HORIZONTAL);
			composite.setLayout(gl_composite);
			
			txtExelRownum.setText(String.valueOf(_app.get_excelrows()));
			
			//Set control			
			txtdefine1.setVisible(true);
			txtdefine2.setVisible(false);
			txtdefine3.setVisible(false);
			txtdefine4.setVisible(false);
			txtdefine5.setVisible(false);
			txtdefine6.setVisible(false);
			
			lbldefine1.setVisible(false);
			lbldefine2.setVisible(false);
			lbldefine3.setVisible(false);
			lbldefine4.setVisible(false);
			lbldefine5.setVisible(false);
			lbldefine6.setVisible(false);
			
			
			lbldefine1.setText("");
			lbldefine2.setText("");
			lbldefine3.setText("");
			lbldefine4.setText("");
			lbldefine5.setText("");
			lbldefine6.setText("");			
			
			//Add gia tri cac define
			/*
			if (_app.get_definenm().get("&h_trdt (Ngay query du lieu)") != ""){
				lbldefine1.setVisible(true);
				lbldefine1.setText("&h_trdt (Ngay query du lieu)");					
				txtdefine1.setVisible(true);
				txtdefine1.setText(_app.get_definenm().get("&h_trdt (Ngay query du lieu)"));				
			}
			
			if (_app.get_definenm().get("&h_startdt (Ngay dau thang)") != ""){
				lbldefine2.setVisible(true);
				lbldefine2.setText("&h_startdt (Ngay dau thang)");					
				txtdefine2.setVisible(true);
				txtdefine2.setText(_app.get_definenm().get("&h_startdt (Ngay dau thang)"));
				txtdefine2.setEnabled(false);
			}
			
			if (_app.get_definenm().get("&h_enddt (Ngay cuoi thang truoc)") != ""){
				lbldefine3.setVisible(true);
				lbldefine3.setText("&h_enddt (Ngay cuoi thang truoc)");					
				txtdefine3.setVisible(true);
				txtdefine3.setText(_app.get_definenm().get("&h_enddt (Ngay cuoi thang truoc)"));
				txtdefine3.setEnabled(false);
			}
			
			if (_app.get_definenm().get("&h_bstartdt (Ngay gdich dau thang nay)") != ""){
				lbldefine4.setVisible(true);
				lbldefine4.setText("&h_bstartdt (Ngay gdich dau thang nay)");					
				txtdefine4.setVisible(true);
				txtdefine4.setText(_app.get_definenm().get("&h_bstartdt (Ngay gdich dau thang nay)"));
				txtdefine4.setEnabled(false);
			}
			
			if (_app.get_definenm().get("&h_predt (Ngay giao dich truoc)") != ""){
				lbldefine5.setVisible(true);
				lbldefine5.setText("&h_predt (Ngay giao dich truoc)");					
				txtdefine5.setVisible(true);
				txtdefine5.setText(_app.get_definenm().get("&h_predt (Ngay giao dich truoc)"));
				txtdefine5.setEnabled(false);
			}*/
			
			
			Set<Entry<String, String>> set = _app.get_define().entrySet();
			// Get an iterator
			Iterator<Entry<String, String>> j = set.iterator();
			int k=1;
			while(j.hasNext()) {
				Entry<String, String> me = j.next();
				System.out.println(me.getKey() + ": "+me.getValue()+" "+_app.get_definenm().get(me.getKey()));				
				logger.info(me.getKey() + ": "+me.getValue());
				
				if (k==1){//define 1
					lbldefine1.setVisible(true);
					lbldefine1.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
					txtdefine1.setVisible(true);
					txtdefine1.setText(me.getValue());
				}
				else if (k==2){
					lbldefine2.setVisible(true);
					lbldefine2.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
					txtdefine2.setVisible(true);
					txtdefine2.setText(me.getValue());
					txtdefine2.setEnabled(false);
				}
				else if (k==3){
					lbldefine3.setVisible(true);
					lbldefine3.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
					txtdefine3.setVisible(true);
					txtdefine3.setText(me.getValue());
					txtdefine3.setEnabled(false);
				}
				else if (k==4){
					lbldefine4.setVisible(true);
					lbldefine4.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
					txtdefine4.setVisible(true);
					txtdefine4.setText(me.getValue());
					txtdefine4.setEnabled(false);
				}
				else if (k==5){
					lbldefine5.setVisible(true);
					lbldefine5.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
					txtdefine5.setVisible(true);
					txtdefine5.setText(me.getValue());
					txtdefine5.setEnabled(false);
				}
				else if (k==6){
					lbldefine6.setVisible(true);
					lbldefine6.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
					txtdefine6.setVisible(true);
					txtdefine6.setText(me.getValue());
				}
				k++;
			}
			
		} catch (ParserConfigurationException e1) {
			// TODO Auto-generated catch block
			logger.error("Error 1 ");
			e1.printStackTrace();
		} catch (SAXException e1) {
			// TODO Auto-generated catch block
			logger.error("Error 2 ");
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			logger.error("Error: Khong doc duoc file App.xml [D:\\Query to Excel\\Congifure]");
			e1.printStackTrace();
		}
		
		//Ghi thong tin tren Status
		IStatusLineManager manager = getViewSite().getActionBars().getStatusLineManager();
		manager.setMessage("Configure server");		
	}
	

	/**
	 * Passing the focus request to the viewer's control.
	 */
	public void setFocus() {
		//viewer.getControl().setFocus();
	}
	
	//Set lai cai define voi Tree map
	public void setSetDefine(){
		Set<Entry<String, String>> set = _app.get_define().entrySet();
		// Get an iterator
		Iterator<Entry<String, String>> j = set.iterator();
		int k=1;
		while(j.hasNext()) {
			Entry<String, String> me = j.next();
			//System.out.println(me.getKey() + ": "+me.getValue()+" "+_app.get_definenm().get(me.getKey()));				
			logger.info(me.getKey() + ": "+me.getValue());
			
			if (k==1){//define 1
				lbldefine1.setVisible(true);
				//lbldefine1.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
				txtdefine1.setVisible(true);
				txtdefine1.setText(me.getValue());
			}
			else if (k==2){
				lbldefine2.setVisible(true);
				//lbldefine2.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
				txtdefine2.setVisible(true);
				txtdefine2.setText(me.getValue());
				txtdefine2.setEnabled(false);
			}
			else if (k==3){
				lbldefine3.setVisible(true);
				//lbldefine3.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
				txtdefine3.setVisible(true);
				txtdefine3.setText(me.getValue());
				txtdefine3.setEnabled(false);
			}
			else if (k==4){
				lbldefine4.setVisible(true);
				//lbldefine4.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
				txtdefine4.setVisible(true);
				txtdefine4.setText(me.getValue());
				txtdefine4.setEnabled(false);
			}
			else if (k==5){
				lbldefine5.setVisible(true);
				//lbldefine5.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
				txtdefine5.setVisible(true);
				txtdefine5.setText(me.getValue());
				txtdefine5.setEnabled(false);
			}
			else if (k==6){
				lbldefine6.setVisible(true);
				//lbldefine6.setText(me.getKey().substring(2)+" "+_app.get_definenm().get(me.getKey()));					
				txtdefine6.setVisible(true);
				txtdefine6.setText(me.getValue());
			}
			k++;
		}
		
	}
}
