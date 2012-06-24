package org.eib.application.ui.views;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.TreeMap;
import java.util.Map.Entry;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.dialogs.ProgressMonitorDialog;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.DirectoryDialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eib.application.dialog.AppMessageBox;
import org.eib.common.AppCommon;
import org.eib.common.FolderUtil;
import org.eib.common.JavaUtil;
import org.eib.common.QueryServer;
import org.eib.common.ZipUtil;
import org.eib.database.CommandQuery;
import org.eib.database.JDBCURLHelper;
import org.eib.database.Query;
import org.xml.sax.SAXException;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.DateTime;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.MouseAdapter;
import org.eclipse.swt.events.MouseEvent;

public class TellerView extends ViewPart {

	public static final String ID = "org.eib.application.ui.views.TellerView"; //$NON-NLS-1$
	private static Logger logger =Logger.getLogger("TellerView");
	private AppCommon _app;
	private QueryServer queryser;
	private Connection _conn = null; 
	private Query[] _query;
	
	private Label lblReport;
	private Combo cboReport;
	private Text txtOutUrl;
	private Text txtTK;
	private Text txtCIF;
	
	private Combo cboCN;
	private DateTime dTfrdt;
	private DateTime dTtodt;
	private DateTime dTdt;
	private Combo cboCNQD;
	private Combo cboPGD;
	private Combo cboCCY;
	private Combo cboKH;
	private Button btnVip;
	
	private Button btnChkZip;
	
	StyledText styledTxtDesc;
	StyledText styledTxtNote;
	AppMessageBox _appMes;

	Display display;
	Shell shell;
	private Text text;
	
	public TellerView() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(final Composite parent) {
		_appMes = new AppMessageBox();
		
		Composite container = new Composite(parent, SWT.NONE);
		//display = new Display();
	   // shell = new Shell(display);
	    
		container.setLayout(null);
		{
			cboReport = new Combo(container, SWT.NONE);
			cboReport.setBounds(53, 36, 531, 23);
			cboReport.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(SelectionEvent e) {
					//Chon
					setinitializeControl(false);
					
					for (int i=0; i< _query.length; i++){
						if (cboReport.getText().equals(_query[i].get_querynm())){
							//logger.info("Choose Report : " + _query[i].get_querynm());
							styledTxtDesc.setText(_query[i].get_description());
							styledTxtNote.setText(_query[i].get_note());
							
							text.setText(_query[i].get_description());
							Set<Entry<String, String>> set = _query[i].get_define().entrySet();
							// Get an iterator
							Iterator<Entry<String, String>> j = set.iterator();
							while(j.hasNext()) {
								Entry<String, String> me = j.next();
								//System.out.println(me.getKey() + ": "+me.getValue());			
								//logger.info(me.getKey() + ": "+me.getValue());
								showControl(me.getKey().substring(3));
							}
						}							
						//cboServer.getText().equals("1. Oracle - A Report")}
					}
				}
			});
		}
		{
			lblReport = new Label(container, SWT.NONE);
			lblReport.setBounds(10, 40, 43, 15);
			lblReport.setText("Report");
		}
		
		Group grpTiuCh = new Group(container, SWT.NONE);
		grpTiuCh.setText("Ti\u00EAu ch\u00ED");
		grpTiuCh.setBounds(10, 177, 574, 160);
		
		Label lblChiNhnh = new Label(grpTiuCh, SWT.NONE);
		lblChiNhnh.setBounds(10, 22, 55, 15);
		lblChiNhnh.setText("Chi nh\u00E1nh");
		
		dTfrdt = new DateTime(grpTiuCh, SWT.BORDER);
		dTfrdt.setBounds(315, 17, 93, 24);
		
		Label lblTNgy = new Label(grpTiuCh, SWT.NONE);
		lblTNgy.setBounds(259, 22, 55, 15);
		lblTNgy.setText("T\u1EEB ng\u00E0y");
		
		Label lblnNgy = new Label(grpTiuCh, SWT.NONE);
		lblnNgy.setBounds(259, 48, 55, 15);
		lblnNgy.setText("\u0110\u1EBFn ng\u00E0y");
		
		dTtodt = new DateTime(grpTiuCh, SWT.BORDER);
		dTtodt.setBounds(315, 43, 93, 24);
		
		cboCN = new Combo(grpTiuCh, SWT.NONE);
		cboCN.setItems(new String[] {"1000 - EXIMBANK HOI SO", "1001 - EIB HA NOI", "1002 - EIB DA NANG", "1003 - EIB CAN THO", "1004 - EIB CHO LON", "1007 - EIB HOA BINH", "1012 - EIB QUAN 10", "1015 - EIB QUAN 11", "1200 - EIB NHA TRANG", "1201 - EIB BUON MA THUOT", "1202 - EIB DA LAT", "1400 - EIB TAN DINH", "1401 - EIB SAI GON", "1402 - EIB QUAN 4", "1403 - EIB QUAN 7", "1404 - EIB CONG HOA", "1500 - EIB TAY DO", "1501 - EIB MY THO", "1502 - EIB AN GIANG", "1503 - EIB LONG AN", "1504 - EIB BAC LIEU", "1600 - EIB HUNG VUONG", "1601 - EIB QUANG NGAI", "1602 - EIB VINH", "1603 - EIB HAI PHONG", "1604 - EIB HUE", "1700 - EIB LANG HA", "1701 - EIB LONG BIEN", "1702 - EIB HAI BA TRUNG", "1703 - EIB DONG DA", "1704 - EIB CAU GIAY", "1800 - EIB BINH DUONG", "1801 - EIB DONG NAI", "1802 - EIB THU DUC", "1803 - EIB BA RIA - VUNG TAU", "1900 - EIB QUANG NINH", "1901 - EIB QUANG NAM", "2000 - EIB SO GIAO DICH 1", "2100 - EIB BINH PHU", "2101 - EIB PHU MY HUNG", "2102 - EIB TAN SON NHAT", "2103 - EIB BINH TAN", "2104 - EIB QUAN 3", "9999 - All Branch"});
		cboCN.setBounds(72, 18, 181, 23);
		
		Label lblCnQi = new Label(grpTiuCh, SWT.NONE);
		lblCnQi.setBounds(10, 48, 55, 15);
		lblCnQi.setText("CN Q \u0110\u1ED5i");
		
		cboCNQD = new Combo(grpTiuCh, SWT.NONE);
		cboCNQD.setItems(new String[] {"1000 - EXIMBANK HOI SO", "1001 - EIB HA NOI", "1002 - EIB DA NANG", "1003 - EIB CAN THO", "1004 - EIB CHO LON", "1007 - EIB HOA BINH", "1012 - EIB QUAN 10", "1015 - EIB QUAN 11", "1200 - EIB NHA TRANG", "1201 - EIB BUON MA THUOT", "1202 - EIB DA LAT", "1400 - EIB TAN DINH", "1401 - EIB SAI GON", "1402 - EIB QUAN 4", "1403 - EIB QUAN 7", "1404 - EIB CONG HOA", "1500 - EIB TAY DO", "1501 - EIB MY THO", "1502 - EIB AN GIANG", "1503 - EIB LONG AN", "1504 - EIB BAC LIEU", "1600 - EIB HUNG VUONG", "1601 - EIB QUANG NGAI", "1602 - EIB VINH", "1603 - EIB HAI PHONG", "1604 - EIB HUE", "1700 - EIB LANG HA", "1701 - EIB LONG BIEN", "1702 - EIB HAI BA TRUNG", "1703 - EIB DONG DA", "1704 - EIB CAU GIAY", "1800 - EIB BINH DUONG", "1801 - EIB DONG NAI", "1802 - EIB THU DUC", "1803 - EIB BA RIA - VUNG TAU", "1900 - EIB QUANG NINH", "1901 - EIB QUANG NAM", "2000 - EIB SO GIAO DICH 1", "2100 - EIB BINH PHU", "2101 - EIB PHU MY HUNG", "2102 - EIB TAN SON NHAT", "2103 - EIB BINH TAN", "2104 - EIB QUAN 3", "9999 - All Branch"});
		cboCNQD.setBounds(72, 45, 181, 23);
		
		Label lblPgd = new Label(grpTiuCh, SWT.NONE);
		lblPgd.setBounds(10, 77, 55, 15);
		lblPgd.setText("PGD");
		
		cboPGD = new Combo(grpTiuCh, SWT.NONE);
		cboPGD.setBounds(72, 73, 181, 23);
		
		Label lblTiKhon = new Label(grpTiuCh, SWT.NONE);
		lblTiKhon.setBounds(10, 105, 55, 15);
		lblTiKhon.setText("T\u00E0i kho\u1EA3n");
		
		txtTK = new Text(grpTiuCh, SWT.BORDER);
		txtTK.setBounds(72, 102, 181, 21);
		
		Label lblCif = new Label(grpTiuCh, SWT.NONE);
		lblCif.setBounds(259, 105, 49, 15);
		lblCif.setText("Custseq");
		
		txtCIF = new Text(grpTiuCh, SWT.BORDER);
		txtCIF.setBounds(315, 102, 93, 21);
		
		Label lblNgy = new Label(grpTiuCh, SWT.NONE);
		lblNgy.setText("Ng\u00E0y");
		lblNgy.setBounds(259, 77, 55, 15);
		
		dTdt = new DateTime(grpTiuCh, SWT.BORDER);
		dTdt.setBounds(315, 72, 93, 24);
		
		Label lblLoiTin = new Label(grpTiuCh, SWT.NONE);
		lblLoiTin.setBounds(414, 22, 55, 15);
		lblLoiTin.setText("Lo\u1EA1i ti\u1EC1n");
		
		cboCCY = new Combo(grpTiuCh, SWT.NONE);
		cboCCY.setItems(new String[] {"AUD", "CAD", "CHF", "CNY", "DEM", "DKK", "EUR", "FRF", "GBP", "GD1", "GD2", "GD3", "GD4", "HKD", "IDR", "JPY", "KRW", "MYR", "NOK", "NZD", "SEK", "SGD", "THB", "USD", "VND", "ZAR"});
		cboCCY.setBounds(475, 18, 91, 23);
		
		Label lblKh = new Label(grpTiuCh, SWT.NONE);
		lblKh.setBounds(414, 48, 55, 15);
		lblKh.setText("Kh h\u00E0ng");
		
		cboKH = new Combo(grpTiuCh, SWT.NONE);
		cboKH.setItems(new String[] {"01 - CN", "02 - DN", "03 - TC", "04 - T\u1EA5t c\u1EA3"});
		cboKH.setBounds(475, 44, 91, 23);
		
		btnVip = new Button(grpTiuCh, SWT.CHECK);
		btnVip.setBounds(414, 76, 93, 16);
		btnVip.setText("Vip");
		
		Combo combo = new Combo(container, SWT.NONE);
		combo.setItems(new String[] {"S\u1EA3n ph\u1EA9m d\u1EF1 th\u01B0\u1EDFng", "\u0110\u00E1o h\u1EA1n", "Doanh s\u1ED1", "T\u00E0i kho\u1EA3n", "L\u00E3i su\u1EA5t", "FTP", "S\u1ED1 d\u01B0 b\u00ECnh qu\u00E2n", "Kh\u00E1c"});
		combo.setBounds(418, 7, 166, 23);
		
		Button btnRun = new Button(container, SWT.NONE);
		
		btnRun.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseDown(MouseEvent e) {
				//Run
				
				//Doc lai map
				int i;
				for (i=0; i< _query.length; i++){
					
					if (cboReport.getText().equals(_query[i].get_querynm())){
						_appMes.set_title("Information");
						logger.info("Run Report: "+_query[i].get_querynm());
						String _filename="";						
						//Them ngay he thong lay bao cao
						DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
						Date date = new Date();
						_filename =dateFormat.format(date);
						
						TreeMap<String, String> _tMap = new TreeMap<String, String>();
						//_tMap = _query[i].get_define();
						Set<Entry<String, String>> set = _query[i].get_define().entrySet();
						// Get an iterator
						Iterator<Entry<String, String>> j = set.iterator();
						while(j.hasNext()) {
							Entry<String, String> me = j.next();
							//System.out.println(me.getKey() + ": "+me.getValue());			
							//logger.info(me.getKey() + ": "+me.getValue());
							//showControl(me.getKey().substring(3));
							_tMap.put(me.getKey(), "'"+getTextControl(me.getKey().substring(3))+"'");//Them 1 ky tu vao gia tri		
							_filename = _filename +"_"+ getTextControl(me.getKey().substring(3)); //Them cai gia tri tham so chon vao ten file
						}
						
						//JavaUtil.showHashMap(_tMap);
						//Run scipt do
						logger.info("\nRun: "+_query[i].get_querynm());
						//JavaUtil.showHashMap(_tMap);
						_query[i].set_define(_tMap);//Tham so nhap							
						_query[i].setquery();//Set lai cau script lay
						//System.out.print("query= "+ _query[i].get_exquery());
						_app.set_outurl(txtOutUrl.getText()+"\\");//lay duong dan chon
						CommandQuery.set_Excelrow(_app.get_excelrows());
						//try {
							
						//Show Dialog Progress
						//CommandQuery.commandQueryExcel(_conn, _query[i].get_exquery(),true,false, _app.get_outurl_excel(_filename+"_"+_query[i].get_querynm()));
						
						_query[i].set_exquery("select * from athena.daily_stocks_transaction");
						try {
					          new ProgressMonitorDialog(parent.getShell()).run(true, true, new RunScriptProgressBar(_conn, _query[i], _app.get_excelrows(),_app.get_outurl_excel(_filename+"_"+_query[i].get_querynm())));
					    } catch (InvocationTargetException e3) {
					          MessageDialog.openError(shell, "Error", e3.getMessage());
					    } catch (InterruptedException e3) {
					          MessageDialog.openInformation(shell, "Cancelled", e3.getMessage());
					    }							
						
						if (btnChkZip.getSelection()){
							logger.info("out file: "+ _app.get_outurl());
							logger.info("file name: "+ _filename+"_"+_query[i].get_querynm());
							
							File outZipurl = new File(_app.get_outurl());				
							//Zip
							ZipUtil.writeZipOneFile(outZipurl, _filename+"_"+_query[i].get_querynm()+".xls");
							//Xoa file
							FolderUtil.deleteFile(_app.get_outurl() + _filename+"_"+_query[i].get_querynm() +".xls");
						}
						_appMes.set_message("Successful \n\nOut File:  "+_app.get_outurl_excel(_filename+"_"+_query[i].get_querynm()));						
						_appMes.getInfoMessageBox();
						logger.info("OK: "+_query[i].get_querynm());
					}
					//cboServer.getText().equals("1. Oracle - A Report")}
				}
			}
		});
		btnRun.setBounds(10, 341, 75, 25);
		btnRun.setText("Run");
		
		txtOutUrl = new Text(container, SWT.BORDER);
		txtOutUrl.setEnabled(false);
		txtOutUrl.setBounds(91, 343, 391, 21);
		
		Button btnNewButton = new Button(container, SWT.NONE);
		btnNewButton.addMouseListener(new MouseAdapter() {		
			@Override
			public void mouseDown(MouseEvent e) {							       
			  DirectoryDialog dlg = new DirectoryDialog(parent.getShell());

		      // Set the initial filter path according
		      // to anything they've selected or typed in
		      dlg.setFilterPath(txtOutUrl.getText());
		      // Change the title bar text
		      dlg.setText("Chon duong dan luu file");
		      // Customizable message displayed in the dialog
		      dlg.setMessage("Chon duong dan.");

		      // Calling open() will open and run the dialog.
		      // It will return the selected directory, or
		      // null if user cancels
		      String dir = dlg.open();
		      if (dir != null) {
		        // Set the text box to the new selection
		    	  txtOutUrl.setText(dir);
		      }
			}
		});
		btnNewButton.setBounds(488, 341, 26, 25);
		btnNewButton.setText("...");
		
		Label lblNote = new Label(container, SWT.NONE);
		lblNote.setBounds(10, 145, 34, 15);
		lblNote.setText("Note");
		
		Label lblDesc = new Label(container, SWT.NONE);
		lblDesc.setBounds(10, 88, 34, 15);
		lblDesc.setText("Desc");
		
		styledTxtDesc = new StyledText(container, SWT.BORDER | SWT.READ_ONLY | SWT.WRAP);
		styledTxtDesc.setBounds(53, 65, 531, 61);
		
		styledTxtNote = new StyledText(container, SWT.BORDER | SWT.READ_ONLY | SWT.WRAP);
		styledTxtNote.setBounds(53, 132, 531, 39);

		btnChkZip = new Button(container, SWT.CHECK);
		btnChkZip.setBounds(521, 345, 57, 16);
		btnChkZip.setText("Zip file");
		
		text = new Text(container, SWT.BORDER | SWT.WRAP | SWT.V_SCROLL);
		text.setBounds(101, 370, 285, 48);
		
		createActions();
		initializeToolBar();
		initializeMenu();
		
		setinitializeControl(false); //an tat ca
				
		getApp();//setcontrol				
		getConnectDatabase(); //Ket noi server	
		getLoadReport(); //Add bao cao
		
		//an hien control
		
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
	
	public void setinitializeControl(boolean _bl){
		//cboCN.set
		cboCN.setEnabled(_bl);
		cboCNQD.setEnabled(_bl);
		
		dTfrdt.setEnabled(_bl);
		dTtodt.setEnabled(_bl);
		dTdt.setEnabled(_bl);
		cboPGD.setEnabled(_bl);
		cboCCY.setEnabled(_bl);
		cboKH.setEnabled(_bl);
		btnVip.setEnabled(_bl);
		txtTK.setEnabled(_bl);
		txtCIF.setEnabled(_bl);
	}
	
	/**
	 * Hien thi cac tieu chi lien quan
	 * @param _def
	 */
	public void showControl(String _def){
		if (_def.equals("h_brcd")){
			cboCN.setEnabled(true);
		}
		if (_def.equals("h_brcd_ex")){
			cboCNQD.setEnabled(true);
		}
		if (_def.equals("h_frdt")){
			dTfrdt.setEnabled(true);
		}
		if (_def.equals("h_todt")){
			dTtodt.setEnabled(true);
		}
		if (_def.equals("h_trdt")){
			dTdt.setEnabled(true);
		}
		if (_def.equals("h_detpcd")){
			cboPGD.setEnabled(true);
		}
		if (_def.equals("h_ccycd")){
			cboCCY.setEnabled(true);
		}
		if (_def.equals("h_custtpcd")){
			cboKH.setEnabled(true);
		}
		if (_def.equals("h_vip")){
			btnVip.setEnabled(true);
		}
		if (_def.equals("h_acctno")){
			txtTK.setEnabled(true);
		}
		if (_def.equals("h_custseq")){
			txtCIF.setEnabled(true);
		}
	}
	
	/**
	 * Lay gia tri cua cac tieu chi duoc chon
	 * @param _def
	 * @return
	 */
	public String getTextControl(String _def){
		String _return="";
		int iDay;
		int iMonth;
		if (_def.equals("h_brcd")){
			_return = cboCN.getText().substring(0, 4);
		}
		if (_def.equals("h_brcd_ex")){
			_return = cboCNQD.getText().substring(0, 4);
		}
		if (_def.equals("h_frdt")){
			iDay = dTfrdt.getDay();
			iMonth =  dTfrdt.getMonth()+1;
			if (iMonth >= 10) 
				_return = String.valueOf(dTfrdt.getYear()) + String.valueOf(iMonth);
			else
				_return = String.valueOf(dTfrdt.getYear()) +"0"+ String.valueOf(iMonth);
			
			if (iDay >= 10) 
				_return = _return + String.valueOf(iDay);
			else
				_return = _return + "0"+ String.valueOf(iDay);
		}
		if (_def.equals("h_todt")){
			//_return = String.valueOf(dTtodt.getYear()) + String.valueOf(dTtodt.getMonth()) + String.valueOf(dTtodt.getDay());
			iDay = dTtodt.getDay();
			iMonth =  dTtodt.getMonth()+1;
			if (iMonth >= 10) 
				_return = String.valueOf(dTtodt.getYear()) + String.valueOf(iMonth);
			else
				_return = String.valueOf(dTtodt.getYear()) +"0"+ String.valueOf(iMonth);
			
			if (iDay >= 10) 
				_return = _return + String.valueOf(iDay);
			else
				_return = _return + "0"+ String.valueOf(iDay);
			
		}
		if (_def.equals("h_trdt")){
			//_return = String.valueOf(dTdt.getYear()) + String.valueOf(dTdt.getMonth()) + String.valueOf(dTdt.getDay());
			iDay = dTdt.getDay();
			iMonth =  dTdt.getMonth()+1;
			if (iMonth >= 10) 
				_return = String.valueOf(dTdt.getYear()) + String.valueOf(iMonth);
			else
				_return = String.valueOf(dTdt.getYear()) +"0"+ String.valueOf(iMonth);
			
			if (iDay >= 10) 
				_return = _return + String.valueOf(iDay);
			else
				_return = _return + "0"+ String.valueOf(iDay);
		}
		if (_def.equals("h_detpcd")){
			_return = cboPGD.getText().substring(0, 34);
		}
		if (_def.equals("h_ccycd")){
			_return = cboCCY.getText();
		}
		if (_def.equals("h_custtpcd")){
			_return = cboKH.getText().substring(0, 1);
		}
		if (_def.equals("h_vip")){
			_return = btnVip.getText();
		}
		if (_def.equals("h_acctno")){
			_return = txtTK.getText().substring(0, 15);
		}
		if (_def.equals("h_custseq")){
			_return = txtCIF.getText().substring(0, 9);
		}		
		return _return;
	}
	
	/**
	 * 	Lay thong tin cau hinh
	 */
	public void getApp(){
		//lay thong tin
		_app = new AppCommon();
		_appMes.set_title("Get congifure");		
		try {
			ResourceBundle rb = ResourceBundle.getBundle("/resource/app");
			//_app.getAppCom("D:\\Query to Excel\\Congifure\\app.xml", "Common2");
			_app.getAppCom(rb.getString("app_configure_url")+"app.xml",rb.getString("app_configure_common"));
			txtOutUrl.setText(_app.get_outurl());
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			_appMes.set_message(e.getMessage());
			_appMes.getErrorMessageBox();	
			logger.error(e.getMessage());
			e.printStackTrace();
			return;	
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			_appMes.set_message(e.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e.getMessage());
			e.printStackTrace();
			return;	
		} catch (IOException e) {
			// TODO Auto-generated catch block
			_appMes.set_message(e.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e.getMessage());
			e.printStackTrace();
			return;	
		}
	}
	
	/**
	 * Ket noi database
	 */
	public void getConnectDatabase(){
		queryser =new QueryServer();
		_appMes.set_title("Connect database");
		try {
			queryser.getServer(_app.get_configureurl()+"database.xml",_app.get_servernm());
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			_appMes.set_message(e.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e.getMessage());
			e.printStackTrace();
			return;
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			_appMes.set_message(e.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e.getMessage());
			e.printStackTrace();
			return;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			_appMes.set_message(e.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e.getMessage());
			e.printStackTrace();
			return;
		}
		queryser.setUrl(JDBCURLHelper.generateURL(queryser.getDriver(), queryser.getHost(), queryser.getPort(), queryser.getDatabase()));
		logger.info("url = "+queryser.getUrl());
        	
		try {
			Class.forName(queryser.getDriver()).newInstance();
			_conn = DriverManager.getConnection(queryser.getUrl(), queryser.getUser(), queryser.getPassword());
			//System.out.println("Connect Successful !!!");
			logger.info("Connect Successful !!!");
        } catch (Exception e2) {
        	_appMes.set_message(e2.getMessage());
			_appMes.getErrorMessageBox();			
			logger.error("Unable to load driver " + queryser.getDriver());
			logger.error("ERROR " + e2.getMessage());    
			return;		        
        }
	}
	
	/**
	 * Lay cac bao cao
	 */
	public void getLoadReport(){
		_appMes.set_title("Load Report");
		Query qur = new Query();//luc khoi dau lay duoc gia tri ko?
		_query = new Query[_app.get_scriptcount()];
		try {
			qur.getXMLToScript(_app.get_configureurl()+"script.xml", "Query", _query);
			for (int i=0; i< _query.length; i++){
				//logger.info("["+(i+1)+"] queryid: " + _query[i].get_queryid()+", name: "+_query[i].get_querynm());
				//System.out.println("\n["+(i+1)+"] queryid : " + _query[i].get_queryid());
				//System.out.println("["+(i+1)+"] querynm : " + _query[i].get_querynm());
				//System.out.println("["+i+"] module : " + _query[i].get_module());
				//System.out.println("["+i+"] getquery : " + qur2[i].get_getquery());
				
				_query[i].setquery();
				//logger.info("\n"+_query[i].get_exquery());
				
				cboReport.add(_query[i].get_querynm(), i);
				//JavaUtil.showHashMap(_query[i].get_define());
				
				//System.out.println("["+i+"] exequery : " + _query[i].get_exquery());
				
				//Lay duong dan out file
				_query[i].set_queryouturl(_app.get_outurl_excel(_query[i].get_querynm()));
				//System.out.println("["+i+"] out file : " + _query[i].get_queryouturl());						
				//System.out.println("["+i+"] status : " + _query[i].get_status());						
			}
			//System.out.println("> Load script Done. With= "+_query.length+" scripts");
		} catch (ParserConfigurationException e1) {
			// TODO Auto-generated catch block
			_appMes.set_message(e1.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		} catch (SAXException e1) {
			// TODO Auto-generated catch block
			_appMes.set_message(e1.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			_appMes.set_message(e1.getMessage());
			_appMes.getErrorMessageBox();
			logger.error(e1.getMessage());
			e1.printStackTrace();
			return;	
		}		
	}
}


/**
 * 
 * @author tuanemtv
 *
 */
class RunScriptProgressBar implements IRunnableWithProgress{
	
	private static Logger logger =Logger.getLogger("RunScriptProgressBar");
	private static Query query;
	private Connection conn = null;
	private static long rowexcel;
	private static String outfileurl;
  

  public static Query getQuery() {
	return query;
  }

  public static void setQuery(Query query) {
	  RunScriptProgressBar.query = query;
  }
  
  public RunScriptProgressBar(Connection _conn, Query _query, long _rowexcel, String _outfileurl) {
    this.conn = _conn;
    RunScriptProgressBar.query = _query;
    RunScriptProgressBar.rowexcel = _rowexcel;
    RunScriptProgressBar.outfileurl = _outfileurl;
  }

  public void run(IProgressMonitor monitor) throws InvocationTargetException, InterruptedException {
	 monitor.beginTask(query.get_querynm(), true ? IProgressMonitor.UNKNOWN: 100); //true la chay ko biet thoi gian dung
	 try {
		CommandQuery.set_Excelrow(rowexcel);
		CommandQuery.commandQueryExcel(conn, query.get_exquery(),true,false, outfileurl);
		
		//monitor.subTask(CommandQuery.get_message()); //hien thi thong diep ben duoi
	} catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		logger.error(e.getMessage());
		e.printStackTrace();		
	} catch (IOException e) {
		// TODO Auto-generated catch block
		logger.error(e.getMessage());
		e.printStackTrace();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		logger.error(e.getMessage());
		e.printStackTrace();
	}
	 
	// Thread.sleep(INCREMENT);
	 /*
    for (int total = 0; total < TOTAL_TIME && !monitor.isCanceled(); total += INCREMENT) {
      Thread.sleep(INCREMENT);
      monitor.worked(INCREMENT);
      if (total == TOTAL_TIME / 2)
        monitor.subTask("Doing second half");
    }*/
    monitor.done();
    
    if (monitor.isCanceled()){
    	//Phai stop query luon
      throw new InterruptedException(query.get_querynm() + " -> running operation was cancelled");
    }
  }
}
