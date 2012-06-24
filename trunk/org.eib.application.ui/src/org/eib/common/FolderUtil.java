package org.eib.common;

import java.io.File;

import org.apache.log4j.Logger;

/**
 * Tao folder theo duong dan
 * @author GG Tran
 *
 */
public class FolderUtil {
	private static Logger logger =Logger.getLogger("FolderUtil");
	
	public static void createFolder(String _folderurl){
		File f = new File(_folderurl);
		try{
			if(f.mkdir()){
				logger.info("Directory Created: " + _folderurl);
				System.out.println("Directory Created: "+ _folderurl);				
			}
			else{
				logger.info("Directory is not created: " + _folderurl);
				System.out.println("Directory is not created: " + _folderurl);
			}
		}catch(Exception e){
			logger.error(e.getMessage());
			e.printStackTrace();			
		}
	}
	
	public static void deleteFile(String file){
		File f1 = new File(file);
		boolean success = f1.delete();
		if (!success){
			logger.info("Deletion failed.");
			//System.out.println("Deletion failed.");
			//System.exit(0);
		 }else{
			logger.info("File deleted.");
			//System.out.println("File deleted.");
		 }
	}
}
