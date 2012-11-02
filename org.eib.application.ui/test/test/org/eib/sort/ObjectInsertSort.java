package test.org.eib.sort;

public class ObjectInsertSort {

	private Person2[] a;

	  private int nElems;

	  public ObjectInsertSort(int max) {
	    a = new Person2[max];
	    nElems = 0;
	  }

	  // put person into array
	  public void insert(String last, String first, int age) {
	    a[nElems] = new Person2(last, first, age);
	    nElems++;
	  }

	  public void display() {
	    for (int j = 0; j < nElems; j++)
	      a[j].displayPerson();
	  }

	  public void insertionSort() {
	    int in, out;

	    for (out = 1; out < nElems; out++) {
	      Person2 temp = a[out]; // out is dividing line
	      in = out; // start shifting at out

	      while (in > 0 && // until smaller one found,
	          a[in - 1].getLast().compareTo(temp.getLast()) > 0) {
	        a[in] = a[in - 1]; // shift item to the right
	        --in; // go left one position
	      }
	      a[in] = temp; // insert marked item
	    }
	  }

	  
	  public void SortAge(Person2[] _b) {
		    int in, out;

		    for (out = 1; out < nElems; out++) {
		      Person2 temp = _b[out]; // out is dividing line
		      in = out; // start shifting at out

		      while (in > 0 && // until smaller one found,
		    		  _b[in - 1].getAge() > temp.getAge()) {
		    	  _b[in] = _b[in - 1]; // shift item to the right
		        --in; // go left one position
		      }
		      _b[in] = temp; // insert marked item
		    }
		    
		    
		    //System.out.println("After sorting age:");
		    //for (int j = 0; j < nElems; j++)
			      //_b[j].displayPerson();
		    
		    
		  }
	  
	  
	  public static void main(String[] args) {
	    int maxSize = 100; // array size
	    ObjectInsertSort arr;
	    arr = new ObjectInsertSort(maxSize); // create the array

	    arr.insert("Jo", "Yin", 24);
	    arr.insert("Pengzhou", "Yin", 59);
	    arr.insert("James", "Chen", 37);
	    arr.insert("Chirs", "Paul", 37);
	    arr.insert("Rob", "Tom", 43);
	    arr.insert("Carlo", "Sato", 21);
	    arr.insert("Al", "Henry", 29);
	    arr.insert("Nancy", "Jose", 72);
	    arr.insert("Vang", "Minh", 22);

	    System.out.println("Before sorting:");
	    arr.display(); // display items

	    arr.insertionSort(); // insertion-sort them

	    System.out.println("After sorting:");
	    arr.display(); // display them again.
	    
	    arr.SortAge(arr.getA());
	    
	    System.out.println("After sorting age:");
	    arr.display(); 
	  }

	public Person2[] getA() {
		return a;
	}

	public void setA(Person2[] a) {
		this.a = a;
	}

}
