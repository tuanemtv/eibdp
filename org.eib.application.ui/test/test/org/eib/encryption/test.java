package test.org.eib.encryption;

public class test {

	public void coba() {
        String plainteks = "Semua #! Terserah PADAMU.";
        int[] intArr = null;
        String[] hexa = null;
        intArr = new int[plainteks.length()];
        hexa = new String[plainteks.length()];
        for(int i=0; i<plainteks.length(); i++) {
            char p = plainteks.charAt(i);            
            intArr[i] = (int) p;
        }
        for(int i=0; i<intArr.length; i++) {
            int arr = intArr[i];
            hexa[i] = Integer.toHexString(arr).toUpperCase();
            System.out.println(Integer.toHexString(arr).toUpperCase());
        }
        System.out.println();
        for(int i=0; i<hexa.length; i++) {
            int arr = Integer.parseInt(hexa[i], 16);
            System.out.println(arr);                        
        }
    }
    
    public static void main(String[] args) {
        test t = new test();
        t.coba();
    }

}
