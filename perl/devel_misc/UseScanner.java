import java.util.regex.Pattern;
import java.util.Scanner;

public class UseScanner {

  private static class Command {
    public void execute(Machine m) {
    }
  }

  private static class Machine {
    boolean stillInUse() {
      return true;
    }

    Command getCommand(String cmd) {
      return new Command();
    }

    void getStatus() {
      System.out.println( "bla>" );
    }

    String badCommand() {
      return "bad command: ";
    }
  }

  public static void main(String[] args) {
    Machine aMachine = new Machine();
    String select;
    Scanner br = new Scanner(System.in).useDelimiter("[\t ]"); 
    while(aMachine.stillInUse()){
      select = br.next();
      if (Pattern.matches("[rqRQ1-6]", select.trim())) {
        aMachine.getCommand(select.trim().toUpperCase()).execute(aMachine);
      }
      /*
       * Ignore blank input lines and simply
       * redisplay current status -- Scanner doesn't catch this
       */
      else if(select.trim().isEmpty()){
        aMachine.getStatus();

        /*
         * Everything else is treated
         * as an invalid command
         */
      } else {                
          System.out.println(aMachine.badCommand()+select);
          aMachine.getStatus();
        }
      }
    }
}



