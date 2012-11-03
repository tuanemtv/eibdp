package org.eib.common;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.TreeMap;


import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


import org.apache.log4j.Logger;
import org.eib.database.Query;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


public class QueryCron {
        
        private static Logger logger =Logger.getLogger("QueryCron");
        
        private String _cronNM;
        private String _jobNM;
        private String _jobClass;
        private String _jobGroup;
        private String _triggerNM;
        private String _triggerSchedule;
        private String _triggerGroup;
        private String _databaseID;
        
        
        public String get_databaseID() {
                return _databaseID;
        }
        public void set_databaseID(String _databaseID) {
                this._databaseID = _databaseID;
        }


        private String[] _queryid;
        
        
        public String[] get_queryid() {
                return _queryid;
        }
        public void set_queryid(String[] _queryid) {
                this._queryid = _queryid;
        }


        private int _countcron;
        
        
        public int get_countcron() {
                return _countcron;
        }
        public void set_countcron(int _countcron) {
                this._countcron = _countcron;
        }
        public String get_cronNM() {
                return _cronNM;
        }
        public void set_cronNM(String _cronNM) {
                this._cronNM = _cronNM;
        }
        public String get_jobNM() {
                return _jobNM;
        }
        public void set_jobNM(String _jobNM) {
                this._jobNM = _jobNM;
        }
        public String get_jobClass() {
                return _jobClass;
        }
        public void set_jobClass(String _jobClass) {
                this._jobClass = _jobClass;
        }
        public String get_jobGroup() {
                return _jobGroup;
        }
        public void set_jobGroup(String _jobGroup) {
                this._jobGroup = _jobGroup;
        }
        public String get_triggerNM() {
                return _triggerNM;
        }
        public void set_triggerNM(String _triggerNM) {
                this._triggerNM = _triggerNM;
        }
        public String get_triggerSchedule() {
                return _triggerSchedule;
        }
        public void set_triggerSchedule(String _triggerSchedule) {
                this._triggerSchedule = _triggerSchedule;
        }
        public String get_triggerGroup() {
                return _triggerGroup;
        }
        public void set_triggerGroup(String _triggerGroup) {
                this._triggerGroup = _triggerGroup;
        }
        
        
        public QueryCron() {
                super();
                // TODO Auto-generated constructor stub
        }
        
        /**
         * 
         * @param _filepath
         * @param _tagName
         */
        public QueryCron(String _filepath, String _tagName) {
                
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder;
                try {
                        docBuilder = docFactory.newDocumentBuilder();
                        Document doc = docBuilder.parse(_filepath);
                        NodeList list = doc.getElementsByTagName(_tagName);
                        this._countcron = list.getLength();
                        
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


        public void getXMLToCron(String fileurl, String servernm, QueryCron _querycron[]) throws ParserConfigurationException, SAXException, IOException{
                File f = new File(fileurl);
                 DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();
                 DocumentBuilder db = dbf.newDocumentBuilder();
                 Document doc = db.parse(f);


                  //Element root = doc.getDocumentElement();            
                  //System.out.println("getAttributes : " +root.getAttribute("id"));
                  NodeList list = doc.getElementsByTagName(servernm);
                  
                  for (int i = 0; i < list.getLength(); i++) {
                          _querycron[i] = new QueryCron();                        
                          Node node = list.item(i);
                          
                          if (node.getNodeType() == Node.ELEMENT_NODE) {
                                 Element element = (Element) node;
                                 NodeList nodelist = element.getElementsByTagName("cronNM");
                                 Element element1 = (Element) nodelist.item(0);
                                 NodeList fstNm = element1.getChildNodes();
                                 _querycron[i].set_cronNM((fstNm.item(0)).getNodeValue());
                                 //System.out.println("\ncronNM : " + (fstNm.item(0)).getNodeValue());
                                 
                                 nodelist = element.getElementsByTagName("jobNM");
                                 element1 = (Element) nodelist.item(0);
                                 fstNm = element1.getChildNodes();
                                 _querycron[i].set_jobNM((fstNm.item(0)).getNodeValue());
                                // System.out.println("jobNM : " + (fstNm.item(0)).getNodeValue());
                                                                
                                 
                                 nodelist = element.getElementsByTagName("jobClass");
                                 element1 = (Element) nodelist.item(0);
                                 fstNm = element1.getChildNodes();
                                 _querycron[i].set_jobClass((fstNm.item(0)).getNodeValue());
                                 //System.out.println("jobClass : " + (fstNm.item(0)).getNodeValue());
                                 
                                 
                                 nodelist = element.getElementsByTagName("jobGroup");
                                 element1 = (Element) nodelist.item(0);
                                 fstNm = element1.getChildNodes();
                                 _querycron[i].set_jobGroup((fstNm.item(0)).getNodeValue());
                                 //System.out.println("jobGroup : " + (fstNm.item(0)).getNodeValue());
                                 
                                 nodelist = element.getElementsByTagName("triggerNM");
                                 element1 = (Element) nodelist.item(0);
                                 fstNm = element1.getChildNodes();
                                 _querycron[i].set_triggerNM((fstNm.item(0)).getNodeValue());
                                 //System.out.println("triggerNM : " + (fstNm.item(0)).getNodeValue());
                                 
                                 nodelist = element.getElementsByTagName("triggerSchedule");
                                 element1 = (Element) nodelist.item(0);
                                 fstNm = element1.getChildNodes();
                                 _querycron[i].set_triggerSchedule((fstNm.item(0)).getNodeValue());
                                 //System.out.println("triggerSchedule : " + (fstNm.item(0)).getNodeValue());
                                 
                                 nodelist = element.getElementsByTagName("triggerGroup");
                                 element1 = (Element) nodelist.item(0);
                                 fstNm = element1.getChildNodes();
                                 _querycron[i].set_triggerGroup((fstNm.item(0)).getNodeValue());
                                 //System.out.println("triggerGroup : " + (fstNm.item(0)).getNodeValue());      
                                 
                                 nodelist = element.getElementsByTagName("databaseID");
                                 element1 = (Element) nodelist.item(0);
                                 fstNm = element1.getChildNodes();
                                 _querycron[i].set_databaseID((fstNm.item(0)).getNodeValue());
                                                                 
                                 NodeList qlist = doc.getElementsByTagName("Query");
                                 _querycron[i]._queryid = new String[qlist.getLength()];
                                 for (int j = 0; j < qlist.getLength(); j++) {  
                                         //_queryid[j] = new String();
                                         if (node.getNodeType() == Node.ELEMENT_NODE) {
                                                Element qelement1 = (Element) qlist.item(j);
                                                NodeList qfstNm = qelement1.getChildNodes();                                                    
                                                //System.out.println("ID : " +qelement1.getAttribute("id")+" Query : " + (qfstNm.item(0)).getNodeValue());
                                                _querycron[i]._queryid[j] = (qelement1.getAttribute("id"));
                                         }
                                 }
                                 
                                 /*
                                 for (int k = 0; k < _querycron[i]._queryid.length; k++) {                                              
                                         logger.info("k["+k+"]= "+_querycron[i]._queryid[k]);
                                 }*/
                          }
                  }
        }
        
        public void logQueryCron(){                                     
                if (this.get_cronNM() != null)
                        logger.info("_cronNM: "+this.get_cronNM());
                if (this.get_jobNM() != null)
                        logger.info("_jobNM: "+this.get_jobNM());
                if (this.get_jobClass() != null)
                        logger.info("_jobClass: "+this.get_jobClass());
                if (this.get_jobGroup() != null)
                        logger.info("_jobGroup: "+this.get_jobGroup());
                if (this.get_triggerNM() != null)
                        logger.info("_triggerNM: "+this.get_triggerNM());
                if (this.get_triggerSchedule() != null)
                        logger.info("_triggerSchedule: "+this.get_triggerSchedule());
                if (this.get_triggerGroup() != null)
                        logger.info("_triggerGroup: "+this.get_triggerGroup());
                if (this.get_databaseID() != null)
                        logger.info("_databaseID: "+this.get_databaseID());
                
                /*
                if (_queryid.length != null){
                        for (int i=0; i < _queryid.length; i++){
                                logger.info("_queryid["+i+"]= " + _queryid[i]);                         
                        }
                }*/
        }
}