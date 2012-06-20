package test.org.eib.swt;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Login extends JFrame{
/**
* Control in form
*/
	JLabel lblUserID = new JLabel("User Name", JLabel.RIGHT);
	JLabel lblPwd = new JLabel("Password", JLabel.RIGHT);
	static JTextField txtUserID = new JTextField();
	static JPasswordField txtPwd = new JPasswordField();
	JButton btnOK = new JButton("OK");
	JButton btnCancel = new JButton("Cancel");
/**
* Contructor
*/
public Login(){
	super("Login Database.");
	setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
	setSize(300, 140);
	setCenterScreen();
	createLayout();
	setVisible(true);
}

protected void createLayout(){
	Container c = getContentPane();
	
	btnOK.setPreferredSize(new Dimension(80, 25));
	btnOK.addActionListener(new OKAction(c));
	btnCancel.setPreferredSize(new Dimension(80, 25));
	btnCancel.addActionListener(new CancelAction());

	/**
	* Layout for form
	*/
	GridBagLayout l = new GridBagLayout();
	
	/**
	* GridBagConstraints
	*/
	GridBagConstraints gbc = new GridBagConstraints();
	/**
	* Insets
	*/
	Insets i = new Insets(5,5,5,5);
	
	/**
	* Set layout
	*/
	c.setLayout(l);
	
	/**
	* Set GridBagConstraints
	*/
	gbc.insets = i;
	gbc.gridheight = 1;
	gbc.gridwidth = 1;
	gbc.fill = GridBagConstraints.HORIZONTAL;
	
	/**
	* Add control to layout
	*/
	gbc.gridx = 1;
	gbc.gridy = 1;
	c.add(lblUserID, gbc);
	
	gbc.gridy = 2;
	c.add(lblPwd, gbc);
	
	gbc.gridx = 2;
	gbc.gridy = 1;
	gbc.gridwidth = 2;
	c.add(txtUserID, gbc);
	
	gbc.gridx = 2;
	gbc.gridy = 2;
	c.add(txtPwd, gbc);
	
	gbc.fill = GridBagConstraints.NONE;
	gbc.anchor = GridBagConstraints.SOUTHEAST;
	gbc.gridx = 2;
	gbc.gridy = 3;
	gbc.gridwidth = 1;
	gbc.weightx = 1;
	c.add(btnOK, gbc);
	
	gbc.gridx = 3;
	gbc.gridy = 3;
	gbc.weightx = 0;
	gbc.weighty = 1;
	c.add(btnCancel, gbc);
}

/**
* Set form to CenterScreen
*/
public void setCenterScreen(){
	Dimension s = Toolkit.getDefaultToolkit().getScreenSize();
	Dimension t = getSize();
	setLocation(new Point((int)(s.getWidth() - t.getWidth())/2, (int)(s.getHeight() - t.getHeight())/2));
}

/**
* OK button Action
*/
class OKAction extends AbstractAction{
	Container c;
	OKAction(Container container){
	super();
	c = container;
}

public void actionPerformed(ActionEvent e){
	JOptionPane.showMessageDialog(c, "User Name: " + txtUserID.getText() + "\n" + "Password: " + txtPwd.getText(),"Information", JOptionPane.INFORMATION_MESSAGE);
	}
}

/**
* Cancel button Action
*/
class CancelAction extends AbstractAction{
	CancelAction(){
		super();
}

public void actionPerformed(ActionEvent e){
	System.exit(0);
	}
}

public static void main(String[] args){
	Login l = new Login();
	}
}