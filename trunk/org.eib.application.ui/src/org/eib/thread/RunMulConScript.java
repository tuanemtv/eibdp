package org.eib.thread;

import java.sql.DriverManager;
import org.apache.log4j.Logger;
import org.eib.common.AppCommon;
import org.eib.common.DateTimeUtil;
import org.eib.common.QueryServer;
import org.eib.database.CommandMultiQuery;
import org.eib.database.JDBCURLHelper;
import org.eib.database.Query;

/*
 * Khoi tao nhieu connect
 */
public class RunMulConScript {
	//Status script
		//0: Chua xu ly
		//1: Dang xy ly
		//3: Fail
		//8: Thanh cong
		
		//Truyen vao
		//Connection
		//Query
		//So luong script chay. Nam trong app
		private static Logger logger =Logger.getLogger("RunMulConScript");
		
		public static void commandMulQueryExcel(QueryServer queryser,
												Query[] _query,
												AppCommon _app)
		{
	         // boolean showHeaders, boolean showMetaData) {--> Dua 2 thang nay vao Appcon
			
			boolean bcheck =false;
			int i=0;//
			while (bcheck !=true){
				//Kiem tra trang thai bang 0 cua tat ca cac script
				//if (checkStatus8(_query) == _query.length){//Ko con trang thai 0
				if ((checkStatus0(_query) == 0) && (checkStatus1(_query) == 0)){//Ko con trang thai 0
					//ko con trang thai 0 va 1
					bcheck = true;					
					logger.info("\n>>> Run all script succesfull\n");
										
					//Show tat ca gia tri chay
					for (int k=0; k<_query.length;k++){						
						logger.info("S["+ _query[k].get_startDate()+"] E[" + _query[k].get_endDate() +"] status["+_query[k].get_status()+"] script= "+_query[k].get_queryid()+", name="+_query[k].get_querynm());
					}
				}			
							
				if (i < _query.length){					
					//Kiem tra lan chay dau tien bang cach diem TT = 0 bang so luong mang
					//Chay so luong
					if (checkStatus0(_query) == _query.length){//Moi bang dau chay	
						//System.out.println("App scriptnums: "+_app.get_scriptnums());						
						if (_app.get_scriptnums()>_query.length){
							_app.set_scriptnums(_query.length);
						}
						logger.info("App scriptnums: "+_app.get_scriptnums());
						
						for (int l=0; l <_app.get_scriptnums();l++){//so script dang ky chay							
							//Khoi tai conect							
							//queryser.setUrl(JDBCURLHelper.generateURL(queryser.getDriver(), queryser.getHost(), queryser.getPort(), queryser.getDatabase()));
							
					        //System.out.println("url = "+queryser.getUrl());
							//java.sql.Connection conn = null;
							try {
								//Class.forName(queryser.getDriver()).newInstance();
								//conn = DriverManager.getConnection(queryser.getUrl(), queryser.getUser(), queryser.getPassword());																
								queryser.connectDatabase();
								//_query[l].logQuery();
								
								//da dong connect trong script
								CommandMultiQuery cq1 = new CommandMultiQuery(queryser.get_conn(),_query[l],_app);
								//Trang thai bat dau
								_query[l].set_status("1");
								
								//Set thoi gian chay
								_query[l].set_startDate(DateTimeUtil.getDateTime());
								
								cq1.start();								
					        } catch (Exception e2) {
					            //System.out.println("Unable to load driver " + queryser.getDriver());
					            //System.out.println("ERROR " + e2.getMessage());
					            logger.error("Unable to load driver "+ queryser.getDriver() +"ERROR " + e2.getMessage());
					            //return;				        
					        }																										
							//System.out.println(">>Run ="+_query[l].get_queryid()+", name="+_query[l].get_querynm());
							logger.info(">>Run ="+_query[l].get_queryid()+", name="+_query[l].get_querynm());
							/*
							try {
								//delay for one second
								CommandMultiQuery.currentThread();
								Thread.sleep(500);
							} catch (InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}*/
							i=i+1;
						}																
					}
					else{//Ko phai lan dau chay
						if (_app.get_scriptnums()>_query.length){
							_app.set_scriptnums(_query.length);
						}
						if (checkStatus1(_query) < _app.get_scriptnums()){
							//System.out.println("NEXT > ");
							//logger.info("NEXT > ");
							
							
							//Tang 1 script len				
							//Khoi tai conect							
							//queryser.setUrl(JDBCURLHelper.generateURL(queryser.getDriver(), queryser.getHost(), queryser.getPort(), queryser.getDatabase()));
					        //System.out.println("url = "+queryser.getUrl());
							// java.sql.Connection conn = null;
							try {
								//Class.forName(queryser.getDriver()).newInstance();
								//conn = DriverManager.getConnection(queryser.getUrl(), queryser.getUser(), queryser.getPassword());
								//da dong connect trong script
								queryser.connectDatabase();
								_query[i].set_status("1");								
								//Set thoi gian chay
								_query[i].set_startDate(DateTimeUtil.getDateTime());
								//if (_query[i].get_queryid().equals("G001")||_query[i].get_queryid().equals("G002")){									
									//CommandMultiQueryStr cq2 = new CommandMultiQueryStr(queryser.get_conn(),_query[i],_app);
									//cq2.start();
								//}else{
									CommandMultiQuery cq3 = new CommandMultiQuery(queryser.get_conn(),_query[i],_app);
									cq3.start();				
								//}
								
								
												
					        } catch (Exception e2) {
					            //System.out.println("Unable to load driver " + queryser.getDriver());
					            //System.out.println("ERROR " + e2.getMessage());
					            logger.error(e2.getMessage());
					            //return;				        
					        }													
							//DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss][dd/MM/yyyy]");
							//Date date = new Date();
							//dateFormat.format(date)+
							//System.out.println(">>Run script= "+_query[i].get_queryid()+", name="+_query[i].get_querynm());
							logger.info("NEXT >>Run ="+_query[i].get_queryid()+", name="+_query[i].get_querynm());							
							/*
							try {
								//delay for one second
								CommandMultiQuery.currentThread();
								Thread.sleep(500);
							} catch (InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							*/
							i=i+1;						
							//Truong hop 2 script ket thuc cung luc thi lam sao???
							
							//Chua dung
							/*
							for (int k=0; k<_query.length;k++){
								//System.out.println("["+k+"]"+" "+_query[k].get_queryid()+", status: "+_query[k].get_status());
								if (_query[k].get_status().equals("8")){
									System.out.println(" >>>script= "+_query[k].get_queryid()+": OK ");
								}
							}*/												
						}
					}
				}
				/* 
				else{//Da qua chieu dai mang
					bcheck = true;
					System.out.println(">>> Run script succesfull");
					logger.info("\n>>> Run all script succesfull");
				}*/			
			}		
	    }
		
		//Function, dem status = 0
		static int checkStatus0 (Query[] _query){
			int _count=0;
			for (int k=0; k<_query.length;k++){
				//System.out.println("saa"+_query[k].get_status());
				if (_query[k].get_status().equals("0")){				
					_count ++;
				}
			}	
			return _count;
		}
		
		//Fucntion, dem status = 1
		static int checkStatus1 (Query[] _query){
			int _count=0;
			for (int k=0; k<_query.length;k++){
				//System.out.println("["+k+"]"+" "+_query[k].get_queryid()+", status: "+_query[k].get_status());
				if (_query[k].get_status().equals("1")){
					_count ++;
				}
			}	
			//System.out.println("checkStatus1: "+_count);
			return _count;
		}
		
		//Fucntion, dem status = 8
		static int checkStatus8 (Query[] _query){
			int _count=0;
			for (int k=0; k<_query.length;k++){
				//System.out.println("["+k+"]"+" "+_query[k].get_queryid()+", status: "+_query[k].get_status());
				if (_query[k].get_status().equals("8")){
					_count ++;
				}
			}	
			//System.out.println("checkStatus1: "+_count);
			return _count;
		}
}
