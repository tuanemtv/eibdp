package test.org.eib.swt;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class UsingGridBag extends JFrame implements ActionListener
{
private JLabel jlbHeader, jlbName, jlbAdd, jlbSex, jlbClass, jlbDate;
private JTextField jtfName, jtfAdd, jtfClass;
private JRadioButton jrMale, jrFemale;

private JComboBox jcbDays, jcbMonths, jcbYear;
private JButton jbtSubmit, jbtCancel;

private GridBagLayout layout;
private GridBagConstraints c;
private Container container;

private static final String[] days = {
"1", "2", "3", "4", "5", "6", "7", "8", "9",
"10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
"20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
"30", "31"
};
private static final String[] months = {
"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Ausgt", "Sep",
"Oct", "Nov", "Dec"
};

private static final String[] years = {
"1980", "1981", "1982", "1983", "1984", "1985",
"1986", "1987", "1988", "1989", "1990", "1991"
};

public UsingGridBag(String title)
{
super(title);
this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);

layout = new GridBagLayout();
c = new GridBagConstraints();

jlbHeader = new JLabel("Using GridBagLayout");
jlbHeader.setFont(new Font("Verdana", Font.BOLD, 24));
jlbHeader.setForeground(Color.blue);

jlbName = new JLabel("Student's name:");
jlbAdd = new JLabel("Address:");
jlbSex = new JLabel("Sex:");
jlbClass = new JLabel("Class:");
jlbDate = new JLabel("DOB:");

jrMale = new JRadioButton("Male");
jrFemale = new JRadioButton("Female");

jtfName = new JTextField(20);
jtfAdd = new JTextField(20);
jtfClass = new JTextField(10);

jbtSubmit = new JButton("Submit");
jbtCancel = new JButton("Cancel");
jbtSubmit.addActionListener(this);
jbtCancel.addActionListener(this);
jbtSubmit.setActionCommand("SUBMIT");
jbtCancel.setActionCommand("CANCEL");

jcbDays = new JComboBox(days);
jcbMonths = new JComboBox(months);
jcbYear = new JComboBox(years);

container = this.getContentPane();
container.setLayout(layout);


c.gridx = 0;
c.gridy = 0;
c.gridwidth = 4;
c.anchor = GridBagConstraints.CENTER;
container.add(jlbHeader, c);

c.anchor = GridBagConstraints.WEST;
c.insets = new Insets(3, 0, 5, 5);
c.gridy = 1;
c.gridwidth = 1;
container.add(jlbName, c);

c.gridx = 1;
c.gridwidth = 3;
container.add(jtfName, c);

c.gridx = 0;
c.gridy = 2;
c.gridwidth = 1;
container.add(jlbAdd, c);

c.gridx = 1;
c.gridwidth = 3;
container.add(jtfAdd, c);

c.gridx = 0;
c.gridy = 3;
c.gridwidth = 1;
container.add(jlbSex, c);

c.gridx = 1;
c.gridwidth = 1;
container.add(jrMale, c);

c.gridx = 2;
c.gridwidth = 1;
container.add(jrFemale, c);

c.gridx = 0;
c.gridy = 4;
c.gridwidth = 1;
container.add(jlbClass, c);

c.gridx = 1;
c.gridwidth = 2;
container.add(jtfClass, c);

c.gridx = 0;
c.gridy = 5;
c.gridwidth = 1;
container.add(jlbDate, c);

c.gridx = 1;
c.gridwidth = 1;
container.add(jcbDays, c);

c.gridx = 2;
c.gridwidth = 1;
container.add(jcbMonths, c);
c.gridx = 3;
c.gridwidth = 1;
container.add(jcbYear, c);

JPanel panel = new JPanel();
panel.setLayout(new FlowLayout(FlowLayout.CENTER));
panel.add(jbtSubmit);
panel.add(jbtCancel);

c.gridx = 0;
c.gridy = 6;
c.gridwidth = 4;
c.insets = new Insets(10, 0, 0, 0);
c.anchor = GridBagConstraints.CENTER;
container.add(panel, c);

pack();
center();
setVisible(true);
setResizable(false);
}

private void center()
{
Dimension frameSize = getSize();
Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();

setLocation((screenSize.width - frameSize.width) / 2,
(screenSize.height - frameSize.height) / 2);
}

public void actionPerformed(ActionEvent e)
{
String command = e.getActionCommand();
if(command.equals("SUBMIT"))
{
JOptionPane.showMessageDialog(this, "You pressed submit button!", "Alert", JOptionPane.INFORMATION_MESSAGE);
}
else if(command.equals("CANCEL"))
{
System.exit(0);
}
}

public static void main(String[] args)
{
new UsingGridBag("Using GridBagLayout v1.0");
}
}