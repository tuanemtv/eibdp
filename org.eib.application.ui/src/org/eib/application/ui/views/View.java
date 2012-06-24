package org.eib.application.ui.views;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.TreeMap;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.eclipse.jface.action.IStatusLineManager;
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
import org.eib.common.AppCommon;
import org.eib.common.QueryServer;
import org.eib.database.CommandQuery;
import org.eib.database.JDBCURLHelper;
import org.eib.database.Query;
import org.eib.thread.RunMulConScript;
import org.eib.thread.RunMulScript;
import org.xml.sax.SAXException;
import org.eclipse.wb.swt.layout.grouplayout.GroupLayout;
import org.eclipse.wb.swt.layout.grouplayout.LayoutStyle;
import org.eclipse.wb.swt.SWTResourceManager;

public class View extends ViewPart {
	public View() {
	}
	public static final String ID = "org.eib.application.ui.view";
	private Text txtConfigureUrl;
	private Text txtScriptNum;
	
	private AppCommon _app;
	private QueryServer queryser;
	private Connection _conn = null; 
	private Query[] _query;
	
	private Text txtOutUrl;
	private Text txtExelRownum;
	private static Logger logger =Logger.getLogger("View");

	
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
				logger.info("Click Load.");
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
								try {
									CommandQuery.commandQueryExcel(_conn, _query[i].get_exquery(),true,false, _app.get_outurl_excel(_query[i].get_querynm()));
								} catch (FileNotFoundException e1) {
									// TODO Auto-generated catch block
									e1.printStackTrace();
								} catch (IOException e1) {
									// TODO Auto-generated catch block
									e1.printStackTrace();
								} catch (SQLException e1) {
									// TODO Auto-generated catch block
									e1.printStackTrace();
								}
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
			_app.getAppCom("E:\\BACKUP\\DROPBOX\\Dropbox\\WORK\\Project\\app.xml", "Common2");
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
			GroupLayout gl_composite = new GroupLayout(composite);
			gl_composite.setHorizontalGroup(
				gl_composite.createParallelGroup(GroupLayout.LEADING)
					.add(gl_composite.createSequentialGroup()
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lblServer)
								.add(6)
								.add(cboServer, GroupLayout.PREFERRED_SIZE, 145, GroupLayout.PREFERRED_SIZE)
								.addPreferredGap(LayoutStyle.UNRELATED)
								.add(btnConnect, GroupLayout.PREFERRED_SIZE, 78, GroupLayout.PREFERRED_SIZE)
								.addPreferredGap(LayoutStyle.RELATED)
								.add(lblconnect, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lblConfigureUrl)
								.add(8)
								.add(txtConfigureUrl, GroupLayout.PREFERRED_SIZE, 335, GroupLayout.PREFERRED_SIZE))
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
								.add(12)
								.add(lblScript)
								.add(6)
								.add(cboScript, GroupLayout.PREFERRED_SIZE, 355, GroupLayout.PREFERRED_SIZE)
								.add(6)
								.add(btnload))
							.add(gl_composite.createSequentialGroup()
								.add(124)
								.add(btnRunOne)
								.add(16)
								.add(btnRunAll)
								.add(18)
								.add(btnMultiServer))
							.add(gl_composite.createSequentialGroup()
								.add(10)
								.add(lblOutFileUrl)
								.add(20)
								.add(txtOutUrl, GroupLayout.PREFERRED_SIZE, 335, GroupLayout.PREFERRED_SIZE)))
						.addContainerGap(147, Short.MAX_VALUE))
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
										.add(lblconnect, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))))
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
						.add(6)
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
						.add(5)
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(btnRunOne)
							.add(gl_composite.createParallelGroup(GroupLayout.BASELINE)
								.add(btnRunAll)
								.add(btnMultiServer)))
						.add(6)
						.add(gl_composite.createParallelGroup(GroupLayout.LEADING)
							.add(lblOutFileUrl)
							.add(txtOutUrl, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE))
						.addContainerGap(289, Short.MAX_VALUE))
			);
			composite.setLayout(gl_composite);
			
			txtExelRownum.setText(String.valueOf(_app.get_excelrows()));
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
}