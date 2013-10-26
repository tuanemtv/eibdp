package test.org.eib.String;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

public class WriteStringToFile {

	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		String string = "This is\na test";
		File file = new File("D:\\test.txt");
		FileUtils.writeStringToFile(file, string);
	}

}
