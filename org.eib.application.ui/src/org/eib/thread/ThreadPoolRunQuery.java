package org.eib.thread;

import java.sql.Connection;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import org.apache.log4j.Logger;
import org.eib.common.AppCommon;
import org.eib.common.QueryServer;
import org.eib.database.CommandMultiQuery;
import org.eib.database.Query;

public class ThreadPoolRunQuery {
	
	private static Logger logger =Logger.getLogger("ThreadRunQuery");
	
	public static void RunQueryToExcel(QueryServer _querser, 
			Query[] _query,
			AppCommon _app)
	{	
		int _numQuery=1;
		
		if (_query.length < _app.get_scriptnums()){
			_numQuery = _query.length;
		}else
			_numQuery = _app.get_scriptnums();
		
		logger.info("_numQuery= "+_numQuery);
		
		ExecutorService executor = Executors.newFixedThreadPool(_numQuery);
		
		for(int i=0; i<_query.length; i++) {
			_querser.connectDatabase();
            executor.submit(new CommandMultiQuery(_querser.get_conn(), _query[i], _app));
        }
		
		executor.shutdown();

		logger.info("All tasks submitted.");
		try {
            executor.awaitTermination(1, TimeUnit.DAYS);
        } catch (InterruptedException e) {
        }
		
		logger.info("Run query Successfull");
	}
}
