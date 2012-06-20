package test.org.eib.Thread;

public class ThreadTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ExampleThread et1 = new ExampleThread( "Thread #1", "Hello World!" );
        ExampleThread et2 = new ExampleThread( "Thread #2", "Hey Earth!" );
        
        ExampleThread et3 = new ExampleThread( "Thread #3", "GG Tran" );
        ExampleThread et4 = new ExampleThread( "Thread #4", "Ai day" );
 
        Thread t1 = new Thread( et1 );
        Thread t2 = new Thread( et2 );
 
        t1.start();
        t2.start();
        System.out.println( " [1] Toi day roi. :D" );
        
        Thread t3 = new Thread( et3 );
        System.out.println( " [2] Toi day roi. :D" );
        Thread t4 = new Thread( et4 );
        
        t3.start();
        t4.start();
        // t1.interrupt();
	}

}
