package test.org.eib.quartz;

import java.io.Serializable;  

public class JobContext implements Serializable {  
  
  private static final long serialVersionUID = 1L;  
  
  private String state = "Initial state.";  
  
  
  public String getState() {  
    synchronized (state) {  
       return state;  
    }  
  }  
  
  
  public void setState(String state) {  
    synchronized (state) {  
      this.state = state;  
    }  
  }  
}  