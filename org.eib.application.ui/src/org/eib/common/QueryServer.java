package org.eib.common;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.eib.database.JDBCURLHelper;
import org.eib.database.Query;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class QueryServer {
	
	private static Logger logger =Logger.getLogger("QueryServer");
	
	private String host = null;
    private int port = -1;
    private String database = null;
    private String driver = null;
    private String url = null;
    private String user = null;
    private String password = null;
    private String separator = "\t";
    private String query[];
    private String filename = null;
    private boolean showHeaders = true;
    private boolean showMetaData = false;
    private boolean showSummary = false;
    private Query _script[];
    private Connection _conn = null; 
    private int _countdatabase;
    private String _id;
    
        
    public String get_id() {
		return _id;
	}

	public void set_id(String _id) {
		this._id = _id;
	}

	public int get_countdatabase() {
		return _countdatabase;
	}

	public void set_countdatabase(int _countdatabase) {
		this._countdatabase = _countdatabase;
	}

	public Connection get_conn() {
		return _conn;
	}

	public void set_conn(Connection _conn) {
		this._conn = _conn;
	}

	public Query[] get_script() {
		return _script;
	}

	public void set_script(Query[] _script) {
		this._script = _script;
	}

	public QueryServer() {
		super();		
	}
    
	public QueryServer(String host, int port, String database, String driver,
			String url, String user, String password, String filename) {
		super();
		this.host = host;
		this.port = port;
		this.database = database;
		this.driver = driver;
		this.url = url;
		this.user = user;
		this.password = password;
		this.filename = filename;
	}
	public String getHost() {
		return host;
	}
	public void setHost(String host) {
		this.host = host;
	}
	public int getPort() {
		return port;
	}
	public void setPort(int port) {
		this.port = port;
	}
	public String getDatabase() {
		return database;
	}
	public void setDatabase(String database) {
		this.database = database;
	}
	public String getDriver() {
		return driver;
	}
	public void setDriver(String driver) {
		this.driver = driver;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getSeparator() {
		return separator;
	}
	public void setSeparator(String separator) {
		this.separator = separator;
	}
	public String[] getQuery() {
		return query;
	}
	public void setQuery(String[] query) {
		this.query = query;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public boolean isShowHeaders() {
		return showHeaders;
	}
	public void setShowHeaders(boolean showHeaders) {
		this.showHeaders = showHeaders;
	}
	public boolean isShowMetaData() {
		return showMetaData;
	}
	public void setShowMetaData(boolean showMetaData) {
		this.showMetaData = showMetaData;
	}
	public boolean isShowSummary() {
		return showSummary;
	}
	public void setShowSummary(boolean showSummary) {
		this.showSummary = showSummary;
	}
    
	/*
	 * Dung de doc XML dua vao QueryServer
	 * fileurl = D:\\database.xml. duong dan file XML
	 * servernm = Oralce-ALive
	 */
	public void getServer(String fileurl, String servernm) throws ParserConfigurationException, SAXException, IOException{
		 File f = new File(fileurl);
		 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		 DocumentBuilder db = dbf.newDocumentBuilder();
		 Document doc = db.parse(f);

		  //Element root = doc.getDocumentElement();		  
		  NodeList list = doc.getElementsByTagName(servernm);
		  for (int i = 0; i < list.getLength(); i++) {
			  Node node = list.item(i);			  
			  if (node.getNodeType() == Node.ELEMENT_NODE) {
				 Element element = (Element) node;
				 
				 NodeList nodelist = element.getElementsByTagName("id");
				 Element element1 = (Element) nodelist.item(0);
				 NodeList fstNm = element1.getChildNodes();
				 this._id = (fstNm.item(0)).getNodeValue();
				 
				 
				 nodelist = element.getElementsByTagName("driver");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this.driver = (fstNm.item(0)).getNodeValue();
				 //System.out.println("driver : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("host");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this.host = (fstNm.item(0)).getNodeValue();
				 //System.out.println("host : " + (fstNm.item(0)).getNodeValue());
				 				 
				 nodelist = element.getElementsByTagName("port");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this.port = Integer.parseInt((fstNm.item(0)).getNodeValue());
				 //System.out.println("port : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("database");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this.database = (fstNm.item(0)).getNodeValue();
				//System.out.println("database : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("user");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this.user = (fstNm.item(0)).getNodeValue();
				 //System.out.println("user : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("password");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 this.password = (fstNm.item(0)).getNodeValue().trim();
				 //System.out.println("password : " + (fstNm.item(0)).getNodeValue());				 
			  }
		  }
    }
	
	/**
	 * 
	 * @param _filepath
	 * @param _tagName
	 */
	public QueryServer(String _filepath, String _tagName) {
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		try {
			docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.parse(_filepath);
			NodeList list = doc.getElementsByTagName(_tagName);
			this._countdatabase = list.getLength();
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e.getMessage());
			e.printStackTrace();
		}								
	}
	
	
	/**
	 * Lay mang Query
	 * @param fileurl
	 * @param servernm
	 * @param _queryser
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	public void getXMLToScript(String fileurl, String servernm, QueryServer _queryser[]) throws ParserConfigurationException, SAXException, IOException{
		File f = new File(fileurl);
		 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
		 DocumentBuilder db = dbf.newDocumentBuilder();
		 Document doc = db.parse(f);

		  //Element root = doc.getDocumentElement();		  
		  NodeList list = doc.getElementsByTagName(servernm);
		  for (int i = 0; i < list.getLength(); i++) {
			  _queryser[i] = new QueryServer();	
			  Node node = list.item(i);			  
			  if (node.getNodeType() == Node.ELEMENT_NODE) {
				 Element element = (Element) node;
				 
				 NodeList nodelist = element.getElementsByTagName("id");
				 Element element1 = (Element) nodelist.item(0);
				 NodeList fstNm = element1.getChildNodes();
				 _queryser[i].set_id((fstNm.item(0)).getNodeValue());
								 
				 nodelist = element.getElementsByTagName("driver");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.driver = (fstNm.item(0)).getNodeValue();
				 _queryser[i].setDriver((fstNm.item(0)).getNodeValue());
				 //System.out.println("driver : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("host");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.host = (fstNm.item(0)).getNodeValue();
				 _queryser[i].setHost((fstNm.item(0)).getNodeValue());
				 //System.out.println("host : " + (fstNm.item(0)).getNodeValue());
				 				 
				 nodelist = element.getElementsByTagName("port");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.port = Integer.parseInt((fstNm.item(0)).getNodeValue());
				 _queryser[i].setPort(Integer.parseInt((fstNm.item(0)).getNodeValue()));
				 //System.out.println("port : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("database");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.database = (fstNm.item(0)).getNodeValue();
				 _queryser[i].setDatabase((fstNm.item(0)).getNodeValue());
				//System.out.println("database : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("user");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.user = (fstNm.item(0)).getNodeValue();
				 _queryser[i].setUser((fstNm.item(0)).getNodeValue());
				 //System.out.println("user : " + (fstNm.item(0)).getNodeValue());
				 
				 nodelist = element.getElementsByTagName("password");
				 element1 = (Element) nodelist.item(0);
				 fstNm = element1.getChildNodes();
				 //this.password = (fstNm.item(0)).getNodeValue().trim();
				 _queryser[i].setPassword((fstNm.item(0)).getNodeValue().trim());
				 //System.out.println("password : " + (fstNm.item(0)).getNodeValue());				 
			  }
		  }		
	}
	
	
	/**
	 * Tien hanh connect Database
	 */
	public void connectDatabase(){
		this.setUrl(JDBCURLHelper.generateURL(this.getDriver(), this.getHost(), this.getPort(), this.getDatabase()));
		try {
			Class.forName(this.getDriver()).newInstance();
			_conn = DriverManager.getConnection(this.getUrl(), this.getUser(), this.getPassword());
			
			logger.info("Connect "+this.getDatabase()+" Database Successful");
        } catch (Exception e2) {
			logger.error("Connect Database Fail. Unable to load driver " + this.getDriver());   
        }
	}
	
	
	
	/**
	 * 
	 */
	public void logQueryServer(){
		
		if (this.get_id() != null)
			logger.info("id: "+this.get_id());
		if (this.getHost() != null)
			logger.info("host: "+this.getHost());
		if (this.getPort() != 0)
			logger.info("port: "+this.getPort());
		if (this.getDatabase() != null)
			logger.info("database: "+this.getDatabase());
		if (this.getDriver() != null)
			logger.info("driver: "+this.getDriver());
		if (this.getUrl() != null)
			logger.info("url: "+this.getUrl());
		if (this.getUser() != null)
			logger.info("user: "+this.getUser());
		if (this.getPassword() != null)
			logger.info("password: "+this.getPassword());
		if (this.getSeparator() != null)
			logger.info("separator: "+this.getSeparator());
		if (this.getFilename() != null)
			logger.info("filename: "+this.getFilename());
		//logger.info("showHeaders: "+this.isShowHeaders);
		//logger.info("showMetaData: "+this.getFilename());
		//logger.info("showSummary: "+this.getFilename());


	    //private String query[];
	   
	    //private Query _script[];
	}
}
