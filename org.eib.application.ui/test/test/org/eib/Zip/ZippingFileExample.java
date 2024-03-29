package test.org.eib.Zip;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
 
public class ZippingFileExample {
    public static void main(String[] args) {
    	
    	
        String source = "File 1.xls";
        String target = "D:\\File 1.zip";
 
        try {
            ZipOutputStream zos = new ZipOutputStream(
                    new FileOutputStream(target));
 
            //
            // Create input stream to read file from resource folder.
            //
            Class clazz = ZippingFileExample.class;
            //InputStream is = clazz.getResourceAsStream("/" + source);
            InputStream is = clazz.getResourceAsStream("D:\\" + source);
            
 
            //
            // Put a new ZipEntry in the ZipOutputStream
            //
            zos.putNextEntry(new ZipEntry(source));
 
            int size;
            byte[] buffer = new byte[1024];
 
            //
            // Read data to the end of the source file and write it
            // to the zip output stream.
            //
            while ((size = is.read(buffer, 0, buffer.length)) > 0) {
                zos.write(buffer, 0, size);
            }
 
            zos.closeEntry();
            is.close();
 
            //
            // Finish zip process
            //
            zos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
