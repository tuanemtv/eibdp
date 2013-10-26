package test.org.eib.String;

import java.util.Arrays;

import org.apache.commons.lang3.ArrayUtils;

public class TestJoinArrayString {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String [] one = {"a", "b", "c"};
        String [] two = {"d", "e", "a"};
        String [] three = {"f", "g", "h"};

        
        String [] combined = ArrayUtils.addAll(one, two);
        
        
        System.out.println("First array : " + Arrays.toString(one));
        System.out.println("Second array : " + Arrays.toString(two));
        System.out.println("Combined array : " + Arrays.toString(combined));



	

	
	}

}
