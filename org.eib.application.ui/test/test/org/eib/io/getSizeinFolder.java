package test.org.eib.io;

import java.io.File;
import java.util.Scanner;

public class getSizeinFolder {

	public static void main(String[] args) {
		//Prompt the user to enter a directory or a file
		//System.out.print("Enter a directory or a file: ");
		//Scanner input = new Scanner(System.in);
		//String file = input.nextLine();
		//Display the size
		System.out.println(getSize(new File("D:\\Project\\Query to Excel\\libs")) + " files");
		
		File curFolder = new File("D:\\Project\\Query to Excel\\libs");
        int totalFiles = 0;
        //for loop to count the files in the directory using listfiles method
        for (File file : curFolder.listFiles()) {
            //determine if the file object is a file
            if (file.isFile()) {
                //count files ++
                totalFiles++;
            }
        }
        //display number of files in directory
        System.out.println("Number of files: " + totalFiles);
        
		}
		public static long getSize(File file){
		//Store the total size of all files
		long size = 0;
		
		if(file.isDirectory()){
		//All files and subdirectories
			File[] files = file.listFiles();
			for (int i = 0; i < files.length; i++){
				//Recursive call
			size += getSize(files[i]);
			}
		}
		//Base case
		else{
			size += file.length();
		}
		return size;
		}

}
