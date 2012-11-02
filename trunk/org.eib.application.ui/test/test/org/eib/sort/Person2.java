package test.org.eib.sort;

public class Person2 {
	private String lastName;

	  private String firstName;

	  private int age;

	  public Person2(String last, String first, int a) {
	    lastName = last;
	    firstName = first;
	    age = a;
	  }

	  public void displayPerson() {
	    System.out.print("   Last name: " + lastName);
	    System.out.print(", First name: " + firstName);
	    System.out.println(", Age: " + age);
	  }

	  public String getLast() {
	    return lastName;
	  }

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}
}
