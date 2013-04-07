package org.eib.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.log4j.Logger;

/**
 * Dung de nen file va folder
 * @author GG Tran
 *
 */
public class ZipUtil {
	
	private static Logger logger =Logger.getLogger("ZipUtil");
	
	/*
	 * 
	 */
	public static void creatZipFoler(String _folderurl){
		File directoryToZip = new File(_folderurl);

		List<File> fileList = new ArrayList<File>();
		//System.out.println("> Getting references to all files in: " + _folderurl);
		logger.info("> Getting references to all files in: " + _folderurl);
		getAllFiles(directoryToZip, fileList);
		
		//System.out.println("> Reating zip file");
		logger.info("> Reating zip file");
		//System.out.println(">> directoryToZip= "+directoryToZip);
		logger.info(">> directoryToZip= "+directoryToZip);
		
		writeZipFile(directoryToZip, fileList);
		logger.info("> Zip Done.");
		//System.out.println("> Zip Done.");
	}
	
	/**
	 * 
	 * @param _rarUrl
	 * @param _fileNameUrl
	 * @param _folderUrl
	 */
	public static void createRARFolder(String _rarUrl, String _fileNameUrl, String _folderUrl){
		try {
			Process pros = Runtime.getRuntime().exec(new String[]{_rarUrl, "a","-r",_fileNameUrl,_folderUrl});
			/*BufferedReader in = new BufferedReader(new InputStreamReader(pros.getInputStream()));
			
			String inputLine;
			while ((inputLine = in.readLine()) != null) 
			logger.info(inputLine);
			in.close();
        */
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void creatZipFoler(String _folderurl, String _outUrl, String _fileName){
		File directoryToZip = new File(_folderurl);

		List<File> fileList = new ArrayList<File>();
		//System.out.println("> Getting references to all files in: " + _folderurl);
		logger.info("> Getting references to all files in: " + _folderurl);
		getAllFiles(directoryToZip, fileList);
		
		//System.out.println("> Reating zip file");
		logger.info("> Reating zip file");
		//System.out.println(">> directoryToZip= "+directoryToZip);
		logger.info(">> directoryToZip= "+directoryToZip);		
		
		File directoryOut = new File(_outUrl);
		
		writeZipFile(directoryOut, _fileName, fileList);
		logger.info("> Zip Done.");
		//System.out.println("> Zip Done.");
	}
	
	/**
	 * 
	 * @param dir
	 * @param fileList
	 */
	public static void getAllFiles(File dir, List<File> fileList) {
		try {
			File[] files = dir.listFiles();
			for (File file : files) {
				fileList.add(file);
				if (file.isDirectory()) {
					//System.out.println("> directory:" + file.getCanonicalPath());
					logger.info("> directory:" + file.getCanonicalPath());
					getAllFiles(file, fileList);
				} else {
					//System.out.println("     file:" + file.getCanonicalPath());
					logger.info("     file:" + file.getCanonicalPath());
				}
			}
		} catch (IOException e) {
			logger.error(e.getMessage());	
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * @param directoryToZip
	 * @param fileList
	 */
	public static void writeZipFile(File directoryToZip, List<File> fileList) {

		try {
			//FileOutputStream fos = new FileOutputStream(directoryToZip.getName() + ".zip");
			FileOutputStream fos = new FileOutputStream(directoryToZip + ".zip");
			ZipOutputStream zos = new ZipOutputStream(fos);

			for (File file : fileList) {
				if (!file.isDirectory()) { // we only zip files, not directories
					addToZip(directoryToZip, file, zos);
				}
			}

			zos.close();
			fos.close();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());	
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());	
			e.printStackTrace();
		}
	}
	
	
	/**
	 * Ghi Zip voi filename 
	 * @param directoryToZip
	 * @param fileName
	 * @param fileList
	 */
	public static void writeZipFile(File directoryToZip, String fileName, List<File> fileList) {
		try {
			//FileOutputStream fos = new FileOutputStream(directoryToZip.getName() + ".zip");
			FileOutputStream fos = new FileOutputStream(directoryToZip +"\\"+ fileName+".zip");
			ZipOutputStream zos = new ZipOutputStream(fos);

			for (File file : fileList) {
				if (!file.isDirectory()) { // we only zip files, not directories
					addToZip(directoryToZip, file, zos);
				}
			}

			zos.close();
			fos.close();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());	
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());	
			e.printStackTrace();
		}
	}

	/**
	 * Tao file bang 1 file duy nhat
	 * @param directoryToZip: File directoryToZip = new File(_folderurl);
	 * @param fileList
	 */
	public static void writeZipOneFile(File directoryToZip, String fileName) {
		try {
			//FileOutputStream fos = new FileOutputStream(directoryToZip.getName() + ".zip");
			FileOutputStream fos = new FileOutputStream(directoryToZip +"\\"+ fileName.replace(".xls", "")+".zip");
			ZipOutputStream zos = new ZipOutputStream(fos);

			File file = new File(directoryToZip + "\\"+ fileName);
			addToZip(directoryToZip, file, zos);

			zos.close();
			fos.close();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());	
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());	
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @param directoryToZip
	 * @param file
	 * @param zos
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static void addToZip(File directoryToZip, File file, ZipOutputStream zos) throws FileNotFoundException,
			IOException {

		FileInputStream fis = new FileInputStream(file);

		// we want the zipEntry's path to be a relative path that is relative
		// to the directory being zipped, so chop off the rest of the path
		String zipFilePath = file.getCanonicalPath().substring(directoryToZip.getCanonicalPath().length() + 1,
				file.getCanonicalPath().length());
		//System.out.println("   writing '"+ zipFilePath + "' to zip file");
		logger.info("   writing '"+ zipFilePath + "' to zip file");
		ZipEntry zipEntry = new ZipEntry(zipFilePath);
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
