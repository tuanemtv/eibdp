package test.org.eib.common;

import java.io.File;

import org.eib.common.DateTimeUtil;
import org.eib.common.FolderUtil;

public class TestFolderUtil {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//FolderUtil.createFolder("D:\\", "GG Tran");
		//FolderUtil.createFolder("D:\\", DateTimeUtil.getDateYYYYMMDD());
		//
		
		File curFolder = new File("D:\\sdfdf\\");
		FolderUtil.deleteDirectory(curFolder);
	}

}
