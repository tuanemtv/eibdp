package test.org.eib.sort;

class Person implements Comparable {
	
	  private String name;
	  private int _priority;

	  public int get_priority() {
		return _priority;
	}


	public void set_priority(int _priority) {
		this._priority = _priority;
	}


	public Person(String name) {
	    this.name = name;
	  }

	  
	  public int compareTo(Object o) {
	    Person p = (Person) o;
	    return this.name.compareTo(p.name);
	  }
	  
	  public String toString() {
	    return name;
	  }
	}