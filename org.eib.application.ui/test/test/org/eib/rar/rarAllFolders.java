package test.org.eib.rar;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class rarAllFolders
{
   
   public static void main(String args[])
   {
      //File directory = new File(System.getProperty("user.dir"));
	   
	   File directory = new File("D:\\TEST");
      File folders[] = directory.listFiles();

      for(int i = 0; i < folders.length; i++)
      {
         if(folders[i].getName().indexOf(".") == -1)
         {
            //rar all the folders
            try {
               System.out.println(folders[i].getName()+"                  " + folders[i]);
               //Process pros = Runtime.getRuntime().exec(new String[] {"cmd.exe", "/c", "start", "rar a compressed text.txt"}); //" + folders[i].getName() + " " + folders[i].getName()});
               //Process pros = Runtime.getRuntime().exec(new String[] {"cmd.exe", "/c", "start", "D:\\"}); //" + folders[i].getName() + " " + folders[i].getName()});
               //Process pros = Runtime.getRuntime().exec(new String[]{"C:\\Program Files (x86)\\WinRAR\\UnRAR.exe", "e","D:\\76 do an cntt khoa toan tin.rar"});  
               
               //Process pros = Runtime.getRuntime().exec(new String[]{"C:\\Program Files (x86)\\WinRAR\\WinRAR.exe", "e","D:\\TEST\\"});
               
               Process pros = Runtime.getRuntime().exec(new String[]{"C:\\Program Files (x86)\\WinRAR\\WinRAR.exe", "a","-r","d:\\yourfiles2.rar","D:\\TEMP\\DP Manager 2\\"});
               
               try {
            	   System.out.println("Chay...");
            	   pros.waitFor();
            	   System.out.println("Thanh cong");
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
               
               //rar a -r d:\yourfiles.rar d:\test
               
                /* BufferedReader in = new BufferedReader(
                            new InputStreamReader(
                            pros.getInputStream()));
                String inputLine;
            
                while ((inputLine = in.readLine()) != null) 
                    System.out.println(inputLine);
                in.close();*/
            
            } catch (IOException e) {
               // TODO Auto-generated catch block
               e.printStackTrace();
            }
         }
      }
      
   }
   
}