package test.org.eib.Thread;

public class ExampleThread2 extends Thread {
	private String name;
    private String text;
    private final int REPEATS = 5;
    private final int DELAY = 200;
 
    public ExampleThread2( String aName, String aText )
    {
        name = aName;
        text = aText;
    }
 
    public void run()
    {
        try
        {
            for ( int i = 0; i < REPEATS; ++i ) 
            {
                System.out.println( name + " says \"" + text + "\"");
                Thread.sleep( DELAY );
            }
        }
        catch( InterruptedException exception )
        {
            System.out.println( "An error occured in " + name );
        }
        finally
        {
            // Clean up, if necessary
            System.out.println( name + " is quiting..." );
        }
    }
}
