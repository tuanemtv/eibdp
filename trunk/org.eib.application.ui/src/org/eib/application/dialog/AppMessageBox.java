package org.eib.application.dialog;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.internal.WorkbenchWindow;

public class AppMessageBox {
	
	private String _icon="";
	private String _button="";
	private String _title="";
	private String _message="";
	public String get_icon() {
		return _icon;
	}
	public void set_icon(String _icon) {
		this._icon = _icon;
	}
	public String get_button() {
		return _button;
	}
	public void set_button(String _button) {
		this._button = _button;
	}
	public String get_title() {
		return _title;
	}
	public void set_title(String _title) {
		this._title = _title;
	}
	public String get_message() {
		return _message;
	}
	public void set_message(String _message) {
		this._message = _message;
	}
	
	public AppMessageBox(String _title, String _message) {
		super();
		this._title = _title;
		this._message = _message;
	}
	
	public AppMessageBox() {
		// TODO Auto-generated constructor stub
	}
	
	public void getInfoMessageBox(){
		Shell lShell = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();  
		MessageDialog.openInformation(lShell, this._title, this._message);  
	}
	
	public void getErrorMessageBox(){
		Shell lShell = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();  
		MessageDialog.openError(lShell, this._title, this._message);
	}
	
	public void getConfirmMessageBox(){
		Shell lShell = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();  
		MessageDialog.openConfirm(lShell, this._title, this._message);
	}
	
	public void getWarningMessageBox(){
		Shell lShell = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();  
		MessageDialog.openWarning(lShell, this._title, this._message);
	}
	
	public void getQuestionMessageBox(){
		Shell lShell = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();  
		MessageDialog.openQuestion(lShell, this._title, this._message);
	}
}
