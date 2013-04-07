package org.eib.common;

import java.io.File;

import org.apache.log4j.Logger;
import org.eib.database.Query;

public class ArrayScriptUtil {
	private static Logger logger =Logger.getLogger("ArrayScriptUtil");
	
	private Query[] script ;

	public Query[] getScript() {
		return script;
	}

	public void setScript(Query[] script) {
		this.script = script;
	}
	
	public ArrayScriptUtil(String _folderUtl){
		File file = new File(_folderUtl); 
		File[] files = file.listFiles();  
		script = new Query[files.length];
		
		for (int fileInList = 0; fileInList < files.length; fileInList++)  
		{  
			script[fileInList] = new Query();
			script[fileInList].set_queryid(files[fileInList].getName().substring(0, 3));
			script[fileInList].set_priority(Integer.valueOf(files[fileInList].getName().substring(0, 3)));
			script[fileInList].set_querynm(files[fileInList].getName().substring(4,files[fileInList].getName().length()-4));
			script[fileInList].set_fileurl(files[fileInList].toString());
			//System.out.println("No: "+Integer.valueOf(files[fileInList].getName().substring(0, 3)));
			//System.out.println("Name: "+files[fileInList].getName().substring(4,files[fileInList].getName().length()-4));//Bo 001_ va .sql
			//System.out.println("Url: "+files[fileInList].toString());  
			// System.out.println(files[fileInList].getName());			 
		} 
	}
	
	
	public void log(){
		for (int i=0; i< script.length; i++){
			logger.info("i: "+i);
			script[i].logQuery();
		}
	}
	
}
