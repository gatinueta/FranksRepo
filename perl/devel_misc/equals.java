public class equals {

  private static void printeq(String str1, String str2) {
    System.out.println(str1 + " == " + str2 + " is " + (str1==str2) );
    System.out.println(str1 + ".equals(" + str2 + ") is " + (str1.equals(str2)));
  }

  public static void main(String[] args) {
    String s1 = "hello";
    String s2 = "the hello";
    String s3 = s2.substring(4);

    printeq(s1, s1);
    printeq(s1, s2);
    printeq(s2, s3);
    printeq(s1, s3);
  }
}

