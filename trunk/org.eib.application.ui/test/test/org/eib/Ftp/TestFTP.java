package test.org.eib.Ftp;

import org.eib.common.FTPUtil;

public class TestFTP {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		FTPUtil _ftp = new FTPUtil();
		_ftp.set_ftpServer("127.0.0.1");
		_ftp.set_user("tuanemtv");
		_ftp.set_password("h74Cb7sh/Nru3fM2Shy0pw==");
		_ftp.set_port(21);
		_ftp.createFolder("abcd\\12\\22");
	}

}
