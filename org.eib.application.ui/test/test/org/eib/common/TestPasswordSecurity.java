package test.org.eib.common;

import org.eib.common.PasswordSecurity;

public class TestPasswordSecurity {
	public static void main(String[] args) {
		String outputStr;		
				
		
		
		//PasswordSecurity.
		
		outputStr=PasswordSecurity.ConvertPassword("athenainvest");
		System.out.println("â= "+outputStr);
		//assertEquals("P6kzXXbxJB18zYwTKZ+NzQ==", outputStr);
		//PasswordSecurity.encode("P6kzXXbxJB18zYwTKZ+NzQ==");
	}
}
