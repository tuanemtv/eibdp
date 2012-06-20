package test.org.eib.swt;

import javax.swing.*;
import javax.swing.table.*;
import java.awt.*;
import java.awt.event.*;
import java.util.regex.*;

public class SortAndFilterTableDemo extends JFrame implements ActionListener
{
        String[] columns = {"First Name","Last Name",
                        "Sport","# of Years","Vegetarian"};
        Object[][] rows = {
        {"Mary", "Campione",
         "Snowboarding", new Integer(5), new Boolean(false)},
        {"Alison", "Huml",
         "Rowing", new Integer(3), new Boolean(true)},
        {"Kathy", "Walrath",
         "Knitting", new Integer(2), new Boolean(false)},
        {"Sharon", "Zakhour",
         "Speed reading", new Integer(20), new Boolean(true)},
        {"Philip", "Milne",
         "Pool", new Integer(10), new Boolean(false)}
        };
        TableRowSorter<TableModel> sorter;
        JTextField filterText = new JTextField("true");
        JButton button = new JButton("Filter");

        public SortAndFilterTableDemo()
        {
                super("Sorting and Filtering Demo");
                setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
this.setResizable(false);

                TableModel model = new DefaultTableModel(rows, columns)
                {
                public Class getColumnClass(int column)
                {
                        Class returnValue;
                        if ((column >= 0) && (column < getColumnCount()))
                        {
                                        returnValue = getValueAt(0,column).getClass();
                        }
                        else
                        {
                                        returnValue = Object.class;
                        }
                        return returnValue;
                }
                };

                JPanel panel = new JPanel(new BorderLayout());
                filterText.addActionListener(this);
                panel.add(filterText,BorderLayout.CENTER);
                button.addActionListener(this);
                panel.add(button,BorderLayout.EAST);
                getContentPane().add(panel,BorderLayout.NORTH);

                JTable table = new JTable(model);
                sorter = new TableRowSorter<TableModel>(model);
                table.setRowSorter(sorter);
                JScrollPane pane = new JScrollPane(table);
                getContentPane().add(pane,BorderLayout.CENTER);

                setSize(450,150);
                setVisible(true);
        }

        public void actionPerformed(ActionEvent e)
        {
                String text = filterText.getText();
        if (text.length() == 0)
                {
                        sorter.setRowFilter(null);
                }
                else
                {
                        try
                        {
                                sorter.setRowFilter(RowFilter.regexFilter(text));
                        }
                        catch (PatternSyntaxException pse)
                        {
                                System.err.println("Bad regex pattern");
                        }
                }
        }


        public static void main(String args[])
        {
                new SortAndFilterTableDemo();
        }
}