package test.org.eib.mail;

import org.eib.common.MailUtil;

public class TestMailUtil {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MailUtil mail = new MailUtil();
		mail.set_smtpServer("smtp.gmail.com");
		//mail.set_toMail("tuanemtv@gmail.com");
		mail.set_frMail("tuanemtv.gogo@gmail.com");
		mail.set_passFrMail("tuan1985em");
		mail.set_subject("Tieu de mail");
		mail.set_bodyKind("1");
		mail.set_ContMail("<h2>Noi dung mail</h2>");
		mail.set_fileUrl("D:\\test.txt");
		mail.set_fileName("test1.txt");
		try {
			mail.sendMail();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
