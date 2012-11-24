package test.org.eib.MultiThread1.Starting;

public class Test1 {
	public static void main(String[] args) {
        Runner1 runner1 = new Runner1();
        runner1.start();
         
        Runner1 runner2 = new Runner1();
        runner2.start();
 
    }
}

class Runner1 extends Thread {
	 
    @Override
    public void run() {
        for(int i=0; i<5; i++) {
            System.out.println("Hello: " + i);
             
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }
     
}
