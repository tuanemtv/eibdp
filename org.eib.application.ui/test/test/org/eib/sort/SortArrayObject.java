package test.org.eib.sort;

import java.util.Arrays;

public class SortArrayObject {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String names[] = { "W", "M", "N", "K" };
	    Arrays.sort(names);
	    
	    for (int i = 0; i < names.length; i++) {
	      String name = names[i];
	      System.out.print("name = " + name + "; ");
	    }

	    Person persons[] = new Person[4];
	    
	    persons[0] = new Person("W");
	    persons[1] = new Person("M");
	    persons[2] = new Person("N");
	    persons[3] = new Person("K");
	    Arrays.sort(persons);

	    System.out.println("\n");
	    for (int i = 0; i < persons.length; i++) {
	      Person person = persons[i];
	      System.out.println("person = " + person);
	    }
	}	

}
