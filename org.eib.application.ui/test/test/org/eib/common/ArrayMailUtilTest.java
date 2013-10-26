package test.org.eib.common;

import org.eib.common.ArrayCronUtil;
import org.eib.common.ArrayMailUtil;
import org.eib.common.MailUtil;

public class ArrayMailUtilTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ArrayMailUtil a = new ArrayMailUtil("D:\\Excel\\Congifure\\cron\\");
		
		a.log();
		
		
		MailUtil b = new MailUtil();
		b = a.getMailFromID("Mail01");
		
		try {
			b.sendMail();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		/*
		try {
			b.sendMail();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		/*
		for (int i=0; i< a.get_mailUtil().length; i++){
			//a.get_mailUtil()[i].set_subject("aaa");
			//a.get_mailUtil()[i].set_ContMail("Chao ca nha");
			//a.get_mailUtil()[i].set_bodyKind("1");
			//a.get_mailUtil()[i].set_fileName("test.txt");
			
			try {
				a.get_mailUtil()[i].sendMail();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}*/
		
	}

}
