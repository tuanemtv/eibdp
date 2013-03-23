package test.org.eib.mail;

import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class SendMailOK 
{
	public static void send(String smtpServer, String to, String from,String psw,
			String subject, String body) throws Exception
	{
		// java.security.Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
		Properties props = System.getProperties();
		// –
		props.put("mail.smtp.host", smtpServer);
		props.put("mail.smtp.port", "587");
		props.put("mail.smtp.starttls.enable","true");
		final String login = from;//”nth001@gmail.com”;//usermail
		final String pwd = psw;//”password cua ban o day”;
		
		Authenticator pa = null; //default: no authentication
			
		if (login != null && pwd != null) { //authentication required?
			props.put("mail.smtp.auth", "true");
			pa = new Authenticator (){
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(login, pwd);
				}
			};
		}//else: no authentication
		
		Session session = Session.getInstance(props, pa);
		/*
		// — Create a new message –
		Message msg = new MimeMessage(session);
		// — Set the FROM and TO fields –
		msg.setFrom(new InternetAddress(from));
		msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
		// — Set the subject and body text –
		msg.setSubject(subject);
		
		//Neu muon dinh dang thi dung cai nay. Bo setText
		//msg.setContent("<h1>This is actual message</h1>","text/html" );		
		msg.setText(body);
		
		// — Set some other header information –
		msg.setHeader("X-Mailer", "LOTONtechEmail");
		msg.setSentDate(new Date());
		msg.saveChanges();
		
		*/
		
		 // Create a default MimeMessage object.
        MimeMessage msg = new MimeMessage(session);

        // Set From: header field of the header.
        msg.setFrom(new InternetAddress(from));

        // Set To: header field of the header.
        msg.addRecipient(Message.RecipientType.TO,
                                 new InternetAddress(to));

        // Set Subject: header field
        msg.setSubject("This is the Subject Line!");

        // Create the message part 
        BodyPart messageBodyPart = new MimeBodyPart();

        // Fill the message
        messageBodyPart.setText("This is message body 22");
        
        // Create a multipar message
        Multipart multipart = new MimeMultipart();

        // Set text message part
        multipart.addBodyPart(messageBodyPart);

        // Part two is attachment
        messageBodyPart = new MimeBodyPart();
        
        String filename = "D:\\test.txt";
        
        DataSource source = new FileDataSource(filename);
        messageBodyPart.setDataHandler(new DataHandler(source));
        
        messageBodyPart.setFileName("Ten file.txt");
        multipart.addBodyPart(messageBodyPart);

        // Send the complete message parts
        msg.setContent(multipart );        
				
		// — Send the message –
		Transport.send(msg);
		System.out.println("Message sent OK.");

	}
	
	/**
	* Main method to send a message given on the command line.
	*/
	public static void main(String[] args) 
	{
		try
		{
			String smtpServer="smtp.gmail.com";
			String to="tuanemtv@gmail.com";
			String from="tuanemtv.gogo@gmail.com";
			String subject="Hello from Java";
			String body="Test using java to send mail. dff";
			String password="tuan1985em";
			send(smtpServer, to, from, password, subject, "Body thử nhe");
			
			
			/**
			* “send” method to send the message.
			*/
			
			System.out.println("Finish!");
		}
		catch (Exception ex)
		{
			System.out.println("Usage: "+ex.getMessage());
		}
	}
}
