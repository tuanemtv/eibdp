package test.org.eib.common;

import org.eib.common.ArrayCronUtil;
import org.eib.common.ArrayMailUtil;

public class ArrayMailUtilTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ArrayMailUtil a = new ArrayMailUtil("D:\\Project\\Report to Excel\\Workplace\\Report to Excel\\GG  Report to Excel\\Congifure\\cron\\");
		
		a.log();
		
		for (int i=0; i< a.get_mailUtil().length; i++){
			a.get_mailUtil()[i].set_subject("aaa");
			a.get_mailUtil()[i].set_ContMail("Chao ca nha");
			a.get_mailUtil()[i].set_bodyKind("1");
			a.get_mailUtil()[i].set_fileName("test.txt");
			
			try {
				a.get_mailUtil()[i].sendMail();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
	}

}
