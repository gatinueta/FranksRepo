public class LastTen {
  public static void main(String[] args) {
    long sum=0;
    for (int b=1; b<=1000; b++) {
      long fact = 1;
      for (int t=0; t<b; t++) {
        fact *= b;
        fact %= 10000000000L;
      }
      sum += fact;
      sum %= 10000000000L;
    }
    System.out.println(sum);
  }
}

