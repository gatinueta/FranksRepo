import java.text.NumberFormat; 

public class ExceptionsVsAssertions {
  public static String getNonNullString(String val, String defaultVal)
  {
    if (defaultVal == null) { throw new NullPointerException(defaultVal); } 
    if (val == null) {
      return defaultVal;
    } else {
      return val;
    }
  }

  public static void main(String[] args) { 
          String value = "speed"; 
          String defaultValue = "run";
          int x=0;
          long startTime = System.currentTimeMillis(); 
          for (int i=0; i<100000000; i++) { // 100'000'000 times 
              if (getNonNullString(value, defaultValue) != null) {
               x++;
             }
          } 
          long elapsedTime = System.currentTimeMillis() - startTime; 
          NumberFormat nf = NumberFormat.getIntegerInstance(); 
          System.out.println(nf.format(elapsedTime)); 
    }
}

