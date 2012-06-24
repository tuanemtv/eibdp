package test.org.eib.Zip;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipFiles {

	public static void main(String[] args) {

		try {
			FileOutputStream fos = new FileOutputStream("D:\\a.zip");
			ZipOutputStream zos = new ZipOutputStream(fos);

			String file1Name = "D:\\file.xml";
			//String file2Name = "D:\\so lieu\\File 2.xls";
			//String file3Name = "D:\\so lieu\\File 3.xls";
			//String file4Name = "D:\\so lieu\\File 4.xls";
			//String file5Name = "f1/f2/f3/file5.txt";

			addToZipFile(file1Name, zos);
			//addToZipFile(file2Name, zos);
			//addToZipFile(file3Name, zos);
			//addToZipFile(file4Name, zos);
			//addToZipFile(file5Name, zos);

			zos.close();
			fos.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public static void addToZipFile(String fileName, ZipOutputStream zos) throws FileNotFoundException, IOException {

		System.out.println("Writing '" + fileName + "' to zip file");

		File file = new File(fileName);
		FileInputStream fis = new FileInputStream(file);
		ZipEntry zipEntry = new ZipEntry(fileName);
		zos.putNextEntry(zipEntry);

		byte[] bytes = new byte[1024];
		int length;
		while ((length = fis.read(bytes)) >= 0) {
			zos.write(bytes, 0, length);
		}

		zos.closeEntry();
		fis.close();
	}

}
