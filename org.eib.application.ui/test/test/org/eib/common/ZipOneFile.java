package test.org.eib.common;

import java.io.File;

import org.eib.common.ZipUtil;

public class ZipOneFile {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		File outZipurl = new File("D:\\Query to Excel\\Log\\");
		ZipUtil.writeZipOneFile(outZipurl, "Querylog.log.2012-06-15");
	}

}
