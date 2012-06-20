package test.org.eib.excel;

import java.io.FileOutputStream;

import junit.framework.Assert;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

public class CreateExcel {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Throwable {
		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet worksheet = workbook.createSheet("POI Worksheet");
				
        //Workbook wb = new SXSSFWorkbook(100); // keep 100 rows in memory, exceeding rows will be flushed to disk
        //Sheet sh = wb.createSheet();
        for(int rownum = 0; rownum < 1000; rownum++){
        	HSSFRow row = worksheet.createRow(rownum);
            for(int cellnum = 0; cellnum < 10; cellnum++){
            	HSSFCell cell = row.createCell(cellnum);
                String address = new CellReference(cell).formatAsString();
                cell.setCellValue(address);
            }

        }

        /*
        // Rows with rownum < 900 are flushed and not accessible
        for(int rownum = 0; rownum < 900; rownum++){
          Assert.assertNull(sh.getRow(rownum));
        }

        // ther last 100 rows are still in memory
        for(int rownum = 900; rownum < 1000; rownum++){
            Assert.assertNotNull(sh.getRow(rownum));
        }*/
        
        FileOutputStream out = new FileOutputStream("D:\\1.xls");
        workbook.write(out);
        out.close();
    }

}
