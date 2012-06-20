package test.org.eib.xml;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
//import com.borland.jbcl.layout.XYLayout;
//import com.borland.jbcl.layout.*;
import javax.swing.border.EtchedBorder;
import javax.swing.border.Border;
import javax.swing.border.BevelBorder;
import javax.swing.border.TitledBorder;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
//import net.sf.jeppers.calendar.JCalendarBox;
//Import cac lop can thiet de ghi file xml
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
//import org.apache.xml.serialize.OutputFormat;
//import org.apache.xml.serialize.XMLSerializer;
import org.dom4j.io.OutputFormat;
import org.w3c.dom.*;

public class CauHinhDialog extends JDialog implements ActionListener
{
    JPanel panel1 = new JPanel();
    //XYLayout xYLayout1 = new XYLayout();
    JLabel jLabel1 = new JLabel();
    JPanel jPanel1 = new JPanel();
    JLabel jLabel2 = new JLabel();
    //XYLayout xYLayout2 = new XYLayout();
    JTextField txtServer = new JTextField();
    JLabel jLabel3 = new JLabel();
    JTextField txtName = new JTextField();
    JTextField txtUsername = new JTextField();
    JLabel jLabel5 = new JLabel();
    JLabel jLabel6 = new JLabel();
    JPasswordField txtPassword = new JPasswordField();
    Border border8 = BorderFactory.createEtchedBorder(Color.white,
        new Color(255, 217, 60));
    Border border9 = new TitledBorder(border8, "Thông tin tài kho\u1EA3n",
                                     TitledBorder.LEFT, TitledBorder.ABOVE_TOP,
                                     new Font("Arial", Font.BOLD, 12));
    Border border11 = new TitledBorder(border8, "Thông tin khách hàng",
                                      TitledBorder.LEFT,
                                      TitledBorder.ABOVE_TOP,
                                      new Font("Arial", Font.BOLD, 12));
    Border border10 = new TitledBorder(border8, "Danh sách khách hàng",
                                      TitledBorder.LEFT,
                                      TitledBorder.ABOVE_TOP,
                                      new Font("Arial", Font.BOLD, 12));
    //XYLayout xYLayout3 = new XYLayout();
    JPanel jPanel4 = new JPanel();
    JButton btnLuu = new JButton();
    //XYLayout xYLayout4 = new XYLayout();
    JButton btnThoat = new JButton();
    JLabel errName = new JLabel();
    JLabel errUsername = new JLabel();
    JLabel errServer = new JLabel();
    public CauHinhDialog(Frame owner, String title, boolean modal)
    {
        super(owner, title, modal);
        try
        {
            setDefaultCloseOperation(DISPOSE_ON_CLOSE);
            jbInit();
            this.InitError();
            load();
        }
        catch (Exception exception)
        {
            exception.printStackTrace();
        }
    }

    public CauHinhDialog()
    {
        this(new Frame(), "CauHinhDialog", false);
        try
        {
            jbInit();
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }

    private void jbInit() throws Exception
    {
        //panel1.setLayout(xYLayout1);
        panel1.setBackground(new Color(255, 248, 220));
        jLabel1.setText("C\u1EA5u Hình C\u01A1 S\u1EDF D\u1EEF Li\u1EC7u");
        jPanel1.setBackground(new Color(255, 248, 220));
        jPanel1.setFont(new java.awt.Font("Arial", Font.BOLD, 12));
        jPanel1.setBorder(border11);
        //jPanel1.setLayout(xYLayout2);
        jLabel2.setFont(new java.awt.Font("Arial", Font.BOLD, 12));
        jLabel2.setText("Tên c\u01A1 s\u1EDF d\u1EEF li\u1EC7u");
        txtServer.setFont(new java.awt.Font("Arial", Font.PLAIN, 12));
        txtServer.setNextFocusableComponent(txtName);
        txtServer.setEditable(true);
        txtServer.setText("localhost");
        jLabel3.setFont(new java.awt.Font("Arial", Font.BOLD, 12));
        jLabel3.setText("\u0110\u1ECBa ch\u1EC9 c\u1EE7a c\u01A1 s\u1EDF d\u1EEF li\u1EC7u");
        txtName.setFont(new java.awt.Font("Arial", Font.PLAIN, 12));
        txtName.setNextFocusableComponent(txtUsername);
        txtName.setText("QLSTK");
        txtUsername.setFont(new java.awt.Font("Arial", Font.PLAIN, 12));
        txtUsername.setNextFocusableComponent(txtPassword);
        txtUsername.setText("sa");
        jLabel5.setFont(new java.awt.Font("Arial", Font.BOLD, 12));
        jLabel5.setText("Tên \u0111\u0103ng nh\u1EADp");
        jLabel6.setFont(new java.awt.Font("Arial", Font.BOLD, 12));
        jLabel6.setText("M\u1EADt kh\u1EA9u");
        txtPassword.setText("");
        jPanel4.setBackground(new Color(255, 248, 220));
        jPanel4.setBorder(border8);
       // jPanel4.setLayout(xYLayout4);
        btnLuu.setFont(new java.awt.Font("Arial", Font.BOLD, 11));
        btnLuu.setText("L\u01B0u");
        btnLuu.addActionListener(this);
        btnThoat.setFont(new java.awt.Font("Arial", Font.BOLD, 11));
        btnThoat.setNextFocusableComponent(txtServer);
        btnThoat.setText("Thoát");
        btnThoat.addActionListener(this);
        panel1.setBackground(new Color(255, 248, 220));
        this.setDefaultCloseOperation(javax.swing.WindowConstants.
                                      DO_NOTHING_ON_CLOSE);
        this.setFont(new java.awt.Font("Arial", Font.PLAIN, 12));
        this.setTitle("Qu\u1EA3n Lý Thông Tin Khách Hàng");
        errName.setFont(new java.awt.Font("Arial", Font.PLAIN, 25));
        errName.setForeground(Color.red);
        errName.setText("*");
        errUsername.setFont(new java.awt.Font("Arial", Font.PLAIN, 25));
        errUsername.setForeground(Color.red);
        errUsername.setText("*");
        errServer.setFont(new java.awt.Font("Arial", Font.PLAIN, 25));
        errServer.setForeground(Color.red);
        errServer.setText("*");
        this.getContentPane().add(panel1, java.awt.BorderLayout.CENTER);
        /*
        jPanel1.add(errName, new XYConstraints(376, 35, -1, -1));
        jPanel1.add(errServer, new XYConstraints(376, 5, -1, -1));
        jPanel4.add(btnLuu, new XYConstraints(110, 11, 74, -1));
        jPanel4.add(btnThoat, new XYConstraints(220, 11, 74, -1));
        jPanel1.add(jLabel3, new XYConstraints(13, 4, 147, -1));
        jPanel1.add(jLabel2, new XYConstraints(55, 35, 105, -1));
        jPanel1.add(jLabel5, new XYConstraints(75, 65, 85, -1));
        jPanel1.add(jLabel6, new XYConstraints(108, 96, 52, -1));
        panel1.add(jLabel1, new XYConstraints(80, 13, 296, 30));
        panel1.add(jPanel1, new XYConstraints(24, 54, 409, 152));
        panel1.add(jPanel4, new XYConstraints(24, 214, 409, 49));
        jPanel1.add(txtName, new XYConstraints(171, 35, 201, 20));
        jPanel1.add(txtServer, new XYConstraints(171, 4, 201, -1));
        jPanel1.add(txtUsername, new XYConstraints(171, 65, 201, 20));
        jPanel1.add(txtPassword, new XYConstraints(171, 96, 201, -1));
        jPanel1.add(errUsername, new XYConstraints(376, 65, -1, -1));
        jLabel1.setFont(new java.awt.Font("Arial", Font.BOLD, 25));*/
        this.setDefaultCloseOperation(javax.swing.WindowConstants.
                                      DO_NOTHING_ON_CLOSE);
        this.setFont(new java.awt.Font("Arial", Font.PLAIN, 12));
        this.setTitle("Qu\u1EA3n Lý Thông Tin Khách Hàng");
        this.getContentPane().add(panel1, java.awt.BorderLayout.CENTER);
    }

    private void InitError()
    {
        this.errServer.setVisible(false);
        this.errName.setVisible(false);
        this.errUsername.setVisible(false);
    }

    private boolean KTLoi()
    {
        this.InitError();
        if (this.txtServer.getText().equals(""))
        {
            //XLChung.ThongBaoLoi(this.txtServer, this.errServer,
              //                  "Xin vui long nhapp dia chi cua co so du lieu!");
            return true;
        }
        if (this.txtName.getText().equals(""))
        {
           // XLChung.ThongBaoLoi(this.txtName, this.errName,
            //                    "Xin vui long nhap ten co so du lieu!");
            return true;
        }
        if (this.txtUsername.getText().equals(""))
        {
            //XLChung.ThongBaoLoi(this.txtUsername, this.errUsername,
            //                    "Xin vui long nhap ten dang nhap!");
            return true;
        }
        return false;
    }


    //Phuong thuc load thong tin tu tap tin XML len form
    private void load()
    {
        String strServer = null;
        String strName = null;
        String strUsername = null;
        String strPassword = null;
        try
        {
            //Doc du lieu tu tap tin DBConfig.xml
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.
                newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
//            Document doc = docBuilder.parse(
//                new File(getClass().getResource("c:/DBConfig.xml").toString().
//                         substring(6)));
            Document doc = docBuilder.parse(new File("c:/DBConfig.xml"));
            doc.getDocumentElement().normalize();
            NodeList databaseList = doc.getElementsByTagName("Database");
            Node databaseNode = databaseList.item(0);
            //Kiem tra mot node la element
            if (databaseNode.getNodeType() == Node.ELEMENT_NODE)
            {
                Element database = (Element)databaseNode;
                //Lay node Server
                NodeList serverList = database.getElementsByTagName("Server");
                Element server = (Element)serverList.item(0);
                Node sNode = server.getChildNodes().item(0);
                if (sNode != null)
                {
                    this.txtServer.setText(sNode.getNodeValue());
                }
                else
                {
                    this.txtServer.setText("localhost");
                }
                //Lay node Name
                NodeList nameList = database.getElementsByTagName("Name");
                Element name = (Element)nameList.item(0);
                Node nNode = name.getChildNodes().item(0);
                if (nNode != null)
                {
                    this.txtName.setText(nNode.getNodeValue());
                }
                else
                {
                    this.txtName.setText("QLSTK");
                }
                //Lay node Username
                NodeList usernameList = database.getElementsByTagName(
                    "Username");
                Element username = (Element)usernameList.item(0);
                Node uText = username.getChildNodes().item(0);
                if (uText != null)
                {
                    this.txtUsername.setText(uText.getNodeValue());
                }
                else
                {
                    this.txtUsername.setText("sa");
                }
                //Lay node Password
                NodeList passwordList = database.getElementsByTagName(
                    "Password");
                Element password = (Element)passwordList.item(0);
                Node pText = password.getChildNodes().item(0);
                if (pText != null)
                {
                    this.txtPassword.setText(pText.getNodeValue());
                }
                else
                {
                    this.txtPassword.setText("");
                }
            }
        }
        catch (Exception ex)
        {
            this.txtServer.setText("localhost");
            this.txtName.setText("QLSTK");
            this.txtUsername.setText("sa");
            this.txtPassword.setText("");
        }
    }

    private Element createElement(String name, String value, Document doc)
    {
        Element ele = doc.createElement(name);
        Text textNode = doc.createTextNode(value);
        ele.appendChild(textNode);
        return ele;
    }

    private void luu()
    {
        if (this.KTLoi())
        {
            return;
        }
        try
        {
            //Tao ra mot document
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            Document doc = factory.newDocumentBuilder().newDocument();
            //Tao phan tu Database
            Element database = doc.createElement("Database");
            //Tao phan tu Server
            Element server = this.createElement("Server", this.txtServer.getText(), doc);
            database.appendChild(server);
            //Tao phan tu Name
            Element name = this.createElement("Name", this.txtName.getText(), doc);
            database.appendChild(name);
            //Tao phan tu Username
            Element username = this.createElement("Username", this.txtUsername.getText(), doc);
            database.appendChild(username);
            //Tao phan tu Password
            Element password = this.createElement("Password", new String(this.txtPassword.getPassword()), doc);
            database.appendChild(password);
            //Dat phan tu Database vao goc
            doc.appendChild(database);
            //Ghi file xuong tap tin
           // OutputFormat format = new OutputFormat(doc);
            //format.setIndent(4);
            //format.setLineSeparator(System.getProperty("line.separator"));
            //format.setLineWidth(80);

            FileWriter writer = new FileWriter(new File("c:/DBConfig.xml"));
            //XMLSerializer fileSerial = new XMLSerializer(new BufferedWriter(  writer),       format);
            //fileSerial.asDOMSerializer();
            //fileSerial.serialize(doc);
            writer.close();
            JOptionPane.showMessageDialog(this, "Luu cau hinh thanh cong !");
            dispose();
        }
        catch (IOException ex)
        {
        }
        catch (DOMException ex)
        {
        }
        catch (ParserConfigurationException ex)
        {
        }
    }

    public void actionPerformed(ActionEvent e)
    {
        if (e.getSource() == this.btnLuu)
        {
            luu();
        }
        if (e.getSource() == this.btnThoat)
        {
            dispose();
        }
    }
}