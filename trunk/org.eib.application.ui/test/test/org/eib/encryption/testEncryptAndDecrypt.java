package test.org.eib.encryption;

import java.math.BigDecimal;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.jasypt.util.text.BasicTextEncryptor;

public class testEncryptAndDecrypt {
	
	 
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
		textEncryptor.setPassword("smilesunny");
		
		String myEncryptedText = textEncryptor.encrypt("123456");
		
		System.out.println("myEncryptedText= "+myEncryptedText);
		
		String plainText = textEncryptor.decrypt(myEncryptedText);
		
		System.out.println("plainText= "+plainText);
        
	}

}
