package org.eib.thread;


import java.sql.Connection;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.eib.common.AppCommon;
import org.eib.database.CommandMultiQuery;
import org.eib.database.Query;

/*
 * Run voi 1 connect
 */
public class RunMulScript {

	//Status script
	//0: Chua xu ly
	//1: Dang xy ly
	//3: Fail
	//8: Thanh cong
	
	//Truyen vao
	//Connection
	//Query
	//So luong script chay. Nam trong app
	//private static Logger logger =Logger.getLogger("RunMulScript");
	
	public static void commandMulQueryExcel(Connection _conn, 
											Query[] _query,
											AppCommon _app)
	{
         // boolean showHeaders, boolean showMetaData) {--> Dua 2 thang nay vao Appcon
		
		boolean bcheck =false;
		int i=0;//
		while (bcheck !=true){
			//Kiem tra trang thai bang 0 cua tat ca cac script
			if (checkStatus8(_query) == _query.length){//Ko con trang thai 0
				bcheck = true;
				//System.out.println("\n  >>> Run all script succesfull");
				//logger.info("\n  >>> Run all script succesfull");
			}			
						
			if (i < _query.length){					
				//Kiem tra lan chay dau tien bang cach diem TT = 0 bang so luong mang
				//Chay so luong
				if (checkStatus0(_query) == _query.length){//Moi bang dau chay						
					for (int l=0; l <_app.get_scriptnums();l++){//so script dang ky chay												
						CommandMultiQuery cq1 = new CommandMultiQuery(_conn,_query[l],_app);
						_query[l].set_status("1");
						cq1.start();
						
						DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss][dd/MM/yyyy]");
						Date date = new Date();						
						//System.out.println(dateFormat.format(date)+">>Run script= "+_query[l].get_queryid()+", name="+_query[l].get_querynm());
						//logger.info(dateFormat.format(date)+">>Run script= "+_query[l].get_queryid()+", name="+_query[l].get_querynm());
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
					if (checkStatus1(_query) < _app.get_scriptnums()){
						//Tang 1 script len					
						CommandMultiQuery cq3 = new CommandMultiQuery(_conn,_query[i],_app);
						_query[i].set_status("1");
						cq3.start();
						DateFormat dateFormat = new SimpleDateFormat("[HH:mm:ss][dd/MM/yyyy]");
						Date date = new Date();																
						//System.out.println(dateFormat.format(date)+">>Run script= "+_query[i].get_queryid()+", name="+_query[i].get_querynm());
						//logger.info(dateFormat.format(date)+">>Run script= "+_query[i].get_queryid()+", name="+_query[i].get_querynm());
						//System.out.println("Chay script "+i+", status="+ _query[i].get_status());
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
			else{//Da qua chieu dai mang
				bcheck = true;
				//System.out.println(" >>> Run script succesfull");
				//logger.info(" >>> Run all script succesfull");
			}			
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
