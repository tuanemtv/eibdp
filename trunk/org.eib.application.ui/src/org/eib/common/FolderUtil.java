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
	
	
	/**
	 * Tao folder tu duong dan cong voi ten folder 
	 * @param _folderurl: Duong dan chua folder
	 * @param _folderName: Ten folder
	 */
	public static void createFolder(String _folderurl, String _folderName){
		File f = new File(_folderurl+_folderName);
		try{
			if(f.mkdir()){
				logger.info("Directory Created: " + _folderurl + _folderName);
				System.out.println("Directory Created: "+ _folderurl + _folderName);				
			}
			else{
				logger.info("Directory is not created: " + _folderurl + _folderName);
				System.out.println("Directory is not created: " + _folderurl + _folderName);
			}
		}catch(Exception e){
			logger.error(e.getMessage());
			e.printStackTrace();			
		}
	}
	
	/**
	 * 
	 * @param file
	 */
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
	
	/**
	 * Dem so luong file trong folder
	 * @param folder
	 * @return
	 */
	public static int getFileInFolder(String folder){
		File curFolder = new File(folder);
        int totalFiles = 0;
        //for loop to count the files in the directory using listfiles method
        for (File file : curFolder.listFiles()) {
            //determine if the file object is a file
            if (file.isFile()) {
                //count files ++
                totalFiles++;
            }
        }
        
        return totalFiles;
	}
}
